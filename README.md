# 🏥 Système de Gestion de Dossiers Médicaux

## 📝 Présentation du projet
Ce projet consiste en la création d'une application web complète permettant aux médecins hospitaliers d'accéder et de gérer de manière sécurisée les dossiers médicaux de leurs patients. 

L'interface permet de consulter les antécédents, de modifier les fiches patients et d'enrichir le dossier avec de nouveaux actes médicaux ou des fichiers numériques associés.

---

## 🛠️ Stack Technique
* **Langage :** Python 3
* **Framework Web :** Flask
* **Base de données :** PostgreSQL (ou SQL standard)
* **Frontend :** HTML5 / CSS3 (Stylisation personnalisée)
* **Sécurité :** Hachage des mots de passe (Passlib/Argon2) et gestion de sessions utilisateur.

---

## 🚀 Fonctionnalités Clés
* **Authentification Sécurisée :** Système de connexion pour les médecins avec identifiant interne et vérification de mot de passe haché.
* **Tableau de bord personnalisé :** Affichage automatique des patients rattachés au service du médecin connecté.
* **Gestion complète du Patient :**
    * Consultation des actes médicaux, allergies et informations personnelles.
    * Modification des données administratives.
    * Ajout d'actes médicaux et de fichiers numériques (images/comptes-rendus).
* **Gestion des Allergies :** Module permettant d'ajouter de nouvelles allergies à la base de données globale ou au profil spécifique d'un patient.
* **Sécurité des données :** Vérification systématique des droits d'accès (un médecin ne peut pas accéder à un patient hors de son service en modifiant l'URL).

---

## 🏗️ Architecture de la Base de Données
Le projet repose sur un schéma Entité-Association optimisé :
* **Optimisation des types :** Utilisation de types `SERIAL` pour les clés primaires afin d'automatiser l'incrémentation.
* **Contraintes d'intégrité :** Mise en place de contraintes `UNIQUE` sur les noms d'allergies pour éviter les doublons.
* **Stockage de fichiers :** Gestion d'URLs de grande taille (VARCHAR 10 000) pour les fichiers numériques associés aux actes.

---

## 📖 Manuel Utilisateur
1.  **Lancement :** Exécuter `python3 main.py` dans le terminal.
2.  **Accès :** Se rendre sur `http://127.0.0.1:5000`.
3.  **Connexion :** Utiliser les identifiants médecins fournis dans la base de données.
4.  **Navigation :** Cliquer sur le Numéro de Sécurité Sociale d'un patient pour ouvrir son dossier complet.

---

## 📈 Idées d'améliorations (Backlog)
- [ ] Mise en place d'un espace personnel pour le médecin (profil et changement de mot de passe).
- [ ] Encodage direct des fichiers images au lieu de l'URL.
- [ ] Système d'affichage des messages d'erreur dynamique (sans changement de page).
- [ ] Ajout d'une barre de recherche filtrante pour les patients et les allergies.

---

## 👥 Organisation du travail
Projet réalisé en binôme :
* **Féryel BOUKADA :** Architecture backend du site (main.py), gestion des sessions, routes de connexion, affichage dynamique des tableaux de bord et des dossiers patients.
* **Corinne LIU :** Création des formulaires (ajout/modification), templates HTML de gestion des actes et allergies, gestion des erreurs et design CSS.
