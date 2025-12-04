import random
import db
from passlib.context import CryptContext
from flask import Flask, render_template, request, redirect, url_for, session


app = Flask(__name__)

password_ctx = CryptContext(schemes=['bcrypt'])
app.secret_key = b'c1b2a1a12678dfd25165d991e4a8d7738b2423cee31bf64dc02adb3c8ffc7138'

@app.route("/")
@app.route("/accueil")
def accueil():
    return render_template(
        "accueil.html"
    )

@app.route("/connexion")
def connexion():
    mdp_incorrect = request.args.get('mdp_incorrect')
    return render_template(
        "connexion.html", mdp_incorrect = mdp_incorrect
    )

@app.route("/connexion", methods=["POST"])
def traite_connexion():
    form_idf = request.form.get("identifiant")
    form_mdp = request.form.get("mdp")

    for chiffre in form_idf :
        if type(chiffre) == str and chiffre not in ' 1234567890 ':
            return redirect(url_for("connexion", mdp_incorrect=1))
        
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT id_interne, mdp FROM medecin WHERE id_interne = %s", (int(form_idf),))
            medecin = cur.fetchall()

    if medecin[0].id_interne == int(form_idf) :
        if password_ctx.verify(form_mdp, medecin[0].mdp) :
            with db.connect() as conn:
                with conn.cursor() as cur:
                    cur.execute("SELECT num_pro FROM medecin WHERE id_interne = %s",(int(form_idf),))
                    numpro = cur.fetchall()
                    session['identifiant'] = numpro[0]

            return redirect(url_for(
            "session_utilisateur"
            ))
           
    return redirect(url_for("connexion", mdp_incorrect=1))

@app.route("/session_utilisateur")
def session_utilisateur():
    identifiant = session.get('identifiant')

    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT DISTINCT num_secu, nom_naissance, nom_usage, prenom, adresse, id_service FROM patient NATURAL JOIN contient")
            lst_patient = cur.fetchall()

    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT id_service FROM medecin_dispo WHERE num_pro = %s", (identifiant,))
            lst_service = cur.fetchall()

    lst = []
    for service in lst_service:
        for patient in lst_patient:
            if patient.id_service == service.id_service : 
                lst_info = [patient.num_secu, patient.nom_naissance, patient.nom_usage, patient.prenom, patient.adresse, patient.id_service]
                lst.append(lst_info)

    return render_template(
        "session_utilisateur.html", lst=lst, lst_service = lst_service
    )

@app.route("/session_utilisateur/<numero_secu>")
def information_patient(numero_secu):
    session['numero_secu'] = numero_secu
    identifiant = session.get('identifiant')

    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT DISTINCT num_secu, nom_naissance, nom_usage, prenom, adresse, num_pro,id_service FROM patient NATURAL JOIN contient WHERE num_secu = %s", (numero_secu,))
            lst_patient = cur.fetchall()

    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT code, date_debutT, date_finT, niveau, nom FROM touche NATURAL JOIN allergie WHERE num_secu = %s", (numero_secu,))
            lst_allergie = cur.fetchall()

    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT id_acte, nom_a, resume, date_heure FROM acte_medicaux WHERE num_secu = %s", (numero_secu,))
            lst_acte = cur.fetchall()

    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT id_acte, nom, fichier FROM fichier_num")
            lst_fichier = cur.fetchall()

    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT id_service FROM medecin_dispo WHERE num_pro = %s", (identifiant,))
            lst_service = cur.fetchall()

    lst = []
    for service in lst_service:
        for patient in lst_patient:
            if patient.id_service == service.id_service : 
                lst_info = [patient.num_secu, patient.nom_naissance, patient.nom_usage, patient.prenom, patient.adresse, patient.num_pro]
                lst.append(lst_info)

    if lst :
        return render_template("information_patient.html", lst_acte = lst_acte, lst_allergie = lst_allergie, lst_fichier = lst_fichier, lst_patient = lst)
    return render_template("erreur.html")

@app.route("/session_utilisateur/ajout_acte", methods=["POST"])
def ajout_acte():
    return render_template("ajout_acte.html")

@app.route("/session_utilisateur/ajout_acte/traite", methods=["POST"])
def traite_ajout_acte():
    nom = request.form.get("nom")
    resume = request.form.get("resume")
    date = request.form.get("date_heure")
    numero_secu = session.get('numero_secu')

    if nom == '' or resume == '' or date == '' or numero_secu == '' :
        return render_template("erreur2.html")

    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("INSERT INTO acte_medicaux (nom_a, resume, date_heure, num_secu) VALUES (%s,%s,%s,%s)", (nom, resume, date, numero_secu))

    return redirect(url_for(
                "information_patient", numero_secu=numero_secu
                ))

@app.route("/session_utilisateur/ajout_fichier", methods=["POST"])
def ajout_fichier():
    numero_secu = session.get('numero_secu')
                              
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT id_acte FROM acte_medicaux WHERE num_secu = %s ORDER BY id_acte DESC LIMIT 1", (numero_secu,))
            id_acte = cur.fetchall()

    if id_acte == []:
        return render_template("erreur10.html")

    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM acte_medicaux WHERE id_acte = %s", (id_acte[0],))
            acte = cur.fetchall()

    return render_template("ajout_fichier.html", acte = acte)

@app.route("/session_utilisateur/ajout_fichier/traite", methods=["POST"])
def traite_ajout_fichier():
    nom = request.form.get("nom")
    fichier = request.form.get("fichier")
    numero_secu = session.get('numero_secu')

    if fichier == '' :
        return render_template("erreur2.html")

    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT id_acte FROM acte_medicaux WHERE num_secu = %s ORDER BY id_acte DESC LIMIT 1", (numero_secu,))
            id_acte = cur.fetchall()

    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT fichier FROM fichier_num")
            lst_fichier = cur.fetchall()

    for i in range(len(lst_fichier)):
        if fichier == lst_fichier[i].fichier:
            return render_template("erreur11.html")

    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("INSERT INTO fichier_num (nom, fichier, id_acte) VALUES (%s,%s,%s)", (nom, fichier, id_acte[0]))

    return redirect(url_for(
                "information_patient", numero_secu = numero_secu
                ))

@app.route("/session_utilisateur/ajouter_allergie", methods=["POST"])
def ajouter_allergie():
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM allergie")
            allergie = cur.fetchall()

    return render_template("ajouter_allergie.html", allergie = allergie)

@app.route("/session_utilisateur/ajouter_allergie/traite", methods=["POST"])
def traite_ajouter_allergie():
    nom = request.form.get("nom")
    niveau = request.form.get("niveau")
    numero_secu = session.get('numero_secu')

    if niveau == '' or nom == '':
        return render_template("erreur2.html")
    
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM allergie")
            allergie = cur.fetchall()

    for i in range(len(allergie)):
        if nom == allergie[i].nom:
            return render_template("erreur5.html")
        
    if int(niveau) < 1 or int(niveau) > 10:
        return render_template("erreur7.html")

    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("INSERT INTO allergie (nom, niveau)VALUES (%s,%s)", (nom, niveau))

    return redirect(url_for(
                "information_patient", numero_secu=numero_secu
                ))

@app.route("/session_utilisateur/ajout_allergie", methods=["POST"])
def ajout_allergie():
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT nom FROM allergie")
            allergie = cur.fetchall()

    return render_template("ajout_allergie.html", allergie = allergie)

@app.route("/session_utilisateur/ajout_allergie/traite", methods=["POST"])
def traite_ajout_allergie():
    nom = request.form.get("nom")
    date_debutT = request.form.get("date_debutT")
    numero_secu = session.get('numero_secu')

    if date_debutT == '' or nom == '':
        return render_template("erreur2.html")

    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT code FROM allergie WHERE nom = %s", (nom,))
            code = cur.fetchall()

    if code == []:
        return render_template("erreur9.html")

    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM touche WHERE code = %s AND num_secu = %s", (int(code[0].code), numero_secu))
            touche = cur.fetchall()

    if touche != []:
        return render_template("erreur6.html")
        
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("INSERT INTO touche (code, num_secu, date_debutT) VALUES (%s,%s,%s)", (code[0], numero_secu, date_debutT))

    return redirect(url_for(
                "information_patient", numero_secu=numero_secu
                ))

@app.route("/session_utilisateur/modifie_allergie", methods=["POST"])
def modifie_allergie():
    numero_secu = session.get('numero_secu')

    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT code, date_debutT, date_finT, niveau, nom FROM touche NATURAL JOIN allergie WHERE num_secu = %s", (numero_secu,))
            lst_allergie = cur.fetchall()

    return render_template("modifie_allergie.html", lst_allergie = lst_allergie)

@app.route("/session_utilisateur/modifie_allergie/traite", methods=["POST"])
def traite_modifie_allergie():
    code = request.form.get("code")
    date_finT = request.form.get("date_finT")
    numero_secu = session.get('numero_secu')

    if code == '' :
        return render_template("erreur2.html")
    
    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT date_debutT FROM touche WHERE code = %s AND num_secu = %s", (int(code), numero_secu))
            dated = cur.fetchall()

    if dated == []:
        return render_template("erreur8.html")

    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT date_finT FROM touche WHERE code = %s AND num_secu = %s", (int(code), numero_secu))
            datef = cur.fetchall()

    if datef[0].date_fint != None:
        return render_template("erreur4.html")

    if date_finT < str(dated[0].date_debutt):
        return render_template("erreur3.html")

    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("UPDATE touche SET date_finT = %s WHERE code = %s AND num_secu = %s", (date_finT, int(code), numero_secu))

    return redirect(url_for(
                "information_patient", numero_secu=numero_secu
                ))


@app.route("/session_utilisateur/modifie_patient", methods=["POST"])
def modifie_patient():
    numero_secu = session.get('numero_secu')

    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM patient WHERE num_secu = %s", (numero_secu,))
            lst_patient = cur.fetchall()

    return render_template("modifie_patient.html", lst_patient = lst_patient)

@app.route("/session_utilisateur/modifie_patient/traite", methods=["POST"])
def traite_modifie_patient():
    nom_usage = request.form.get("nom_usage")
    prenom = request.form.get("prenom")
    adresse = request.form.get("adresse")
    numero_secu = session.get('numero_secu')

    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM patient WHERE num_secu = %s", (numero_secu,))
            lst_patient = cur.fetchall()

    if nom_usage == '' or prenom == '' :
         return render_template("erreur2.html")

    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT num_pro FROM patient WHERE num_secu = %s", (numero_secu,))
            num_pro = cur.fetchall()

    with db.connect() as conn:
        with conn.cursor() as cur:
            cur.execute("UPDATE patient SET nom_usage = %s, prenom = %s, adresse = %s, num_pro = %s WHERE num_secu = %s", (nom_usage, prenom, adresse, num_pro[0], numero_secu))

    return redirect(url_for(
                "information_patient", numero_secu=numero_secu
                ))


if __name__ == '__main__':
    app.run(debug = True)
