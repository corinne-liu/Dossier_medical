--
-- Create table allergie
--

CREATE TABLE allergie (
        code serial primary key,
        nom varchar(50) not null UNIQUE,
        niveau smallint CHECK (niveau BETWEEN 1 AND 10) not null
);

--
-- Create table medecin
--

CREATE TABLE medecin (
        num_pro int primary key,
        id_interne int UNIQUE,
        nom varchar(50) not null,
        prenom varchar(50) not null,
        adresse varchar(100) not null,
        mdp varchar(100)
);

--
-- Create table patient
--

CREATE TABLE patient (
        num_secu int primary key,
        nom_naissance varchar(50) not null,
        nom_usage varchar(50) not null,
        prenom varchar(50) not null,
        adresse varchar(100),
        num_pro int references medecin(num_pro) not null
);

--
-- Create table acte_medicaux
--

CREATE TABLE acte_medicaux (
        id_acte serial primary key,
        nom_a varchar(200) not null,
        resume text not null,
        date_heure timestamp not null,
        num_secu int references patient(num_secu) not null
);

--
-- Create table fichier_num
--

CREATE TABLE fichier_num (
        num serial primary key,
        nom varchar(100),
        fichier varchar(1000) not null unique,
        id_acte serial references acte_medicaux(id_acte) not null
);

--
-- Create table service
--

CREATE TABLE service (
        id_service serial primary key,
        nom varchar(50) not null,
        localite varchar(100) not null
);

--
-- Create table fonction
--

CREATE TABLE fonction (
        nom_f varchar(50) primary key
);

--
-- Create table touche
--

CREATE TABLE touche (
        code int references allergie(code),
        num_secu int references patient(num_secu),
        date_debutT date not null,
        date_finT date CHECK (date_finT > date_debutT),
        primary key(code, num_secu)
);

--
-- Create table contient
--

CREATE TABLE contient (
        num_secu int references patient(num_secu),
        id_service serial references service(id_service),
        date date not null,
        primary key(num_secu, id_service, date)
);

--
-- Create table occupe
--

CREATE TABLE occupe (
        id_service int references service(id_service),
        num_pro int references medecin(num_pro),
        nom_f varchar(50) references fonction(nom_f),
        date_debutO date not null,
        date_finO date CHECK (date_finO > date_debutO),
        primary key(id_service, num_pro, nom_f)
);


--
-- Data for Name: allergie
--

INSERT INTO allergie (nom, niveau) VALUES ('Chat', 1);
INSERT INTO allergie (nom, niveau) VALUES ('Abeille', 4);
INSERT INTO allergie (nom, niveau) VALUES ('Arachides', 10);
INSERT INTO allergie (nom, niveau) VALUES ('Pénicilline', 3);
INSERT INTO allergie (nom, niveau) VALUES ('Fruits de mer', 8);
INSERT INTO allergie (nom, niveau) VALUES ('Morphine', 8);

--
-- Data for Name: medecin
--

INSERT INTO medecin VALUES (12608013, 3308905, 'Dupont', 'Paul', '23 avenue Marchal 77000 Marne-la-Vallée', '$2b$12$yEC2sq6CzHgr6EPPBqH7a.OwRKr/I/jfYwK4SJFiNB.RU9wLX6BDC');          --azerty123
INSERT INTO medecin VALUES (20731450, 7800120, 'Nguyen', 'Emilie', '107 rue République 75016 Paris', '$2b$12$glCbiE49yOQS8fOQ6ICSOeYhMK3S3kW/A6VnZwDs/XB20oJG3jvp.');                 --0123456789
INSERT INTO medecin VALUES (40891234, 9876543, 'Smith', 'Sophia', '42 Avenue des Lilas 92130 Issy-les-Moulineaux', '$2b$12$ca5z0YluoC3T.g2ZmEOqTOUSbdxdS0UsRkYF3YoBgnH1VwNoVS7sS');   --qwerty159357
INSERT INTO medecin VALUES (31570248, 6543210, 'Nguyen', 'Joseph', '107 rue République 75016 Paris', '$2b$12$SK0G1Di1hMSwpvB8vK6lT.5UQqSQjUNcBCvKtvaiPw0YGJDdOPy/2');                 --00000000
INSERT INTO medecin VALUES (52360123, 1234567, 'Garcia', 'Pedro', '28 Boulevard Saint-Michel 94250 Gentilly', '$2b$12$uwovYjzHutoivNV8WfcjG.9MRUwIQYMfVCBb9O43WvxhWoMcEoFf.');        --potato<3
INSERT INTO medecin VALUES (69584321, 7654321, 'Chang', 'Lily', '5 Avenue du Général Leclerc 93120 La Courneuve', '$2b$12$4ji29OfgefPFqZ/zSyvt3.QKUY2Z2SD2zrSkPSuVAuTCeKeZ0uYGO');    --bonjour
INSERT INTO medecin VALUES (81903456, 3450123, 'Dubois', 'Luc', '71 Rue de la Paix 78000 Versailles', '$2b$12$vbmQIM5JEmp69SImLqtf2OKCquJ94dCm4xfW0svVGDnm.ZCqa1mTO');                --246813579
INSERT INTO medecin VALUES (93784512, 5678901, 'Fernandez', 'Juan', '39 Quai de la Tournelle 75005 Paris', '$2b$12$kH1fAn5ggtCDwuu074OY9OBgz07LgnJroGHoF6agh0pzbV.4wKfXa');           --789456123
INSERT INTO medecin VALUES (62450789, 8901234, 'Garcia', 'Antoine', '11 Rue des Roses 92140 Clamart', '$2b$12$GoyR7NRVCXnxT.bmea3ZeeOdqe7DRJMh23HI0z/LlYIpWAYZzlQHa');                --00000000
INSERT INTO medecin VALUES (63450789, 8101234, 'Hubert', 'Antoinette', '14 Rue des Roses 92140 Clamart', '$2b$12$EGU0LEJJEeGOLtqEb5Ps3OgwTvkNctQfDIilHzblckGM3fO/u.CMy');             --wxcvbnWXCVBN
INSERT INTO medecin VALUES (63454734, 8119472, 'Jean', 'Charles', '15 Rue des Roses 92140 Clamart', '$2b$12$sumjyG71Y1zpOa6BNVEru.qXc9LE.xwL6yWMMv6f20VtOVL6fMiwS');                  --hello15
INSERT INTO medecin VALUES (60418923, 4872468,'Rodriguez', 'Gustave', '71 Rue de la Paix 78000 Versailles', '$2b$12$9BAq/6puYfD3T.EIT4YjBO/.ph2dZ9tNQeUsirlHNfW33Ace3XhUK');          --jesuistropfort
INSERT INTO medecin(num_pro, nom, prenom, adresse) VALUES (30765489, 'Girard', 'Louis', '14 Boulevard de l Indépendance 75012 Paris');
INSERT INTO medecin(num_pro, nom, prenom, adresse) VALUES (46521378, 'Moreau', 'Juliette', '3 Avenue des Champs-Élysées 92000 Nanterre');
INSERT INTO medecin(num_pro, nom, prenom, adresse) VALUES (51907634, 'Lee', 'Juliette', '55 Rue du Faubourg Saint-Antoine 75011 Paris');

--
-- Data for Name: patient
--

INSERT INTO patient VALUES (31582074, 'Martin','Martin', 'Lucas', '42 avenue des Fleurs 92100 Boulogne-Billancourt', 30765489);
INSERT INTO patient VALUES (72641038,'Leroy', 'Moreau', 'Juliette', '3 Avenue des Champs-Élysées 92000 Nanterre', 30765489);
INSERT INTO patient VALUES (91345628, 'Leroy', 'Gustave','Hugo', '8 rue de la Paix 75002 Paris', 51907634);
INSERT INTO patient VALUES (67210395, 'Lee', 'Lee','Jade', '27 boulevard Voltaire 75011 Paris', 51907634);
INSERT INTO patient VALUES (84569213, 'Leclerc', 'Lee', 'Mathis', '27 boulevard Voltaire 75011 Paris', 46521378);
INSERT INTO patient VALUES (53987102, 'Roy', 'Blanc', 'Léa', '21 rue du Faubourg Saint-Antoine 75011 Paris', 60418923);
INSERT INTO patient (num_secu, nom_naissance, nom_usage, prenom, num_pro) VALUES (21789035, 'Dupont', 'Dupont', 'Marco', 51907634);

--
-- Data for Name: acte_medicaux
--

INSERT INTO acte_medicaux (nom_a, resume, date_heure, num_secu) VALUES ('Vaccinations ',
                                                                        'Vaccin grippe fait. Vaccin en régle.',
                                                                        '2016/12/05 16:25',
                                                                        67210395);
INSERT INTO acte_medicaux (nom_a, resume, date_heure, num_secu)VALUES ('Radiographie pulmonaire',
                                                                        'Image des poumons obtenus par rayons X. Détections d une tumeurs au poumon. Niveau gravité : grave.',
                                                                        '2018/03/02 10:39',
                                                                        31582074);
INSERT INTO acte_medicaux (nom_a, resume, date_heure, num_secu)VALUES ('Test cutané d allergie',
                                                                        'Test cutanné fait. Allergie au pollen.',
                                                                        '2018/03/02 13:00',
                                                                        31582074);
INSERT INTO acte_medicaux (nom_a, resume, date_heure, num_secu)VALUES ('Tests sanguins d immunoglobulines',
                                                                        'Test sanguin fait. Allergie au acarien.',
                                                                        '2020/11/15 14:47',
                                                                        53987102);
INSERT INTO acte_medicaux (nom_a, resume, date_heure, num_secu)VALUES ('IRM cérébrale',
                                                                        'Image cérébrale du patient obtenue par radio. Détections d un kyest au cerveau.',
                                                                        '2019/07/11 16:05',
                                                                        84569213);

--
-- Data for Name: fichier_num
--

INSERT INTO fichier_num(nom, fichier, id_acte) VALUES ('Image radio poumon droit de M.Martin', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQfQzMG1-kHcy2Z-20NnESUuCSRdLceRBUUJQ&usqp=CAU', 2);
INSERT INTO fichier_num(nom, fichier, id_acte) VALUES ('Image radio poumon gauche de M.Martin', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSwOxjvLjd5vDdi-8Sas2ddVXnuGkS3k8m4w&usqp=CAU', 2);
INSERT INTO fichier_num(fichier, id_acte) VALUES ('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQXuQ7zrNeY-SY7MFwrqQLcsl-JnX2JBlO9jw&usqp=CAU', 5);

--
-- Data for Name: service
--

INSERT INTO service( nom, localite) VALUES ('Urgences médicales', '1er étage Batiment Copernic Porte A' );
INSERT INTO service( nom, localite) VALUES ('Consultations externes', '1er étage Batiment Copernic Porte B');
INSERT INTO service( nom, localite) VALUES ('Chirurgie', '1er étage Batiment Copernic Porte C');
INSERT INTO service( nom, localite) VALUES ('Radiologie', '2eme étage Batiment Copernic Porte D');
INSERT INTO service( nom, localite) VALUES ('Laboratoire médical', '2eme étage Batiment Copernic Porte E');
INSERT INTO service( nom, localite) VALUES ('Soins intensifs', '2eme étage Batiment Copernic Porte F');
INSERT INTO service( nom, localite) VALUES ('Médecine interne', '3eme étage Batiment Copernic Porte G');
INSERT INTO service( nom, localite) VALUES ('Pédiatrie', '3eme étage Batiment Copernic Porte H');
INSERT INTO service( nom, localite) VALUES ('Soins palliatifs', '1eme étage Batiment Eiffel Porte B');
INSERT INTO service( nom, localite) VALUES ('Pharmacie hospitalière', '2eme étage Batiment Eiffel Porte C');
INSERT INTO service( nom, localite) VALUES ('Service des admissions', 'Internet');

--
-- Data for Name: fonction
--

INSERT INTO fonction VALUES ('Médecin urgentiste');
INSERT INTO fonction VALUES ('Cardiologue');
INSERT INTO fonction VALUES ('Chirurgien');
INSERT INTO fonction VALUES ('Anesthésiologiste');
INSERT INTO fonction VALUES ('Radiologue');
INSERT INTO fonction VALUES ('Pathologiste');
INSERT INTO fonction VALUES ('Médecin de soins intensifs');
INSERT INTO fonction VALUES ('Médecin de médecine interne');
INSERT INTO fonction VALUES ('Pédiatre');
INSERT INTO fonction VALUES ('Médecin de soins palliatifs');
INSERT INTO fonction VALUES ('Médecin généraliste');

--
-- Data for Name: touche
--

INSERT INTO touche VALUES (1 , 31582074, '2018/03/02', '2020/07/02');
INSERT INTO touche(code, num_secu, date_debutT) VALUES (3 , 31582074, '2018/03/02');
INSERT INTO touche VALUES (1 , 72641038, '2016/12/12', '2021/09/02');
INSERT INTO touche(code, num_secu, date_debutT) VALUES (4 , 21789035, '2016/12/12');
INSERT INTO touche VALUES (4 , 53987102, '1978/09/01', '2012/12/30');

--
-- Data for Name: contient
--

INSERT INTO contient VALUES(31582074, 4, '2018/03/02');
INSERT INTO contient VALUES(31582074, 8, '2018/02/23');
INSERT INTO contient VALUES(72641038, 7, '2001/06/29');
INSERT INTO contient VALUES(91345628, 1, '1978/11/06');
INSERT INTO contient VALUES(67210395, 1, '1978/11/06');
INSERT INTO contient VALUES(67210395, 1, '1999/06/04');
INSERT INTO contient VALUES(84569213, 2, '2004/02/14');
INSERT INTO contient VALUES(53987102, 6, '2014/05/18');
INSERT INTO contient VALUES(21789035, 9, '2019/05/18');

--
-- Data for Name: occupe
--

INSERT INTO occupe VALUES(4, 12608013, 'Radiologue', '2000/05/18', '2017/05/18');
INSERT INTO occupe(id_service, num_pro, nom_f, date_debutO) VALUES(1, 12608013, 'Médecin urgentiste', '2019/05/18');
INSERT INTO occupe(id_service, num_pro, nom_f, date_debutO) VALUES(8, 12608013, 'Pédiatre', '2020/05/18');
INSERT INTO occupe VALUES(2, 20731450, 'Cardiologue', '1999/11/18','2005/05/20');
INSERT INTO occupe(id_service, num_pro, nom_f, date_debutO) VALUES(2, 20731450, 'Médecin généraliste', '2005/05/20');
INSERT INTO occupe VALUES(2, 40891234, 'Cardiologue', '2005/05/20', '2020/05/20');
INSERT INTO occupe(id_service, num_pro, nom_f, date_debutO) VALUES(6, 40891234, 'Cardiologue', '2005/05/20');
INSERT INTO occupe(id_service, num_pro, nom_f, date_debutO) VALUES(7, 31570248, 'Médecin de médecine interne', '2000/10/29');
INSERT INTO occupe VALUES(3, 40891234, 'Anesthésiologiste', '1980/05/20', '2010/04/27');
INSERT INTO occupe(id_service, num_pro, nom_f, date_debutO) VALUES(3, 69584321, 'Chirurgien', '2009/12/02');
INSERT INTO occupe(id_service, num_pro, nom_f, date_debutO) VALUES(3, 69584321, 'Anesthésiologiste', '2010/12/02');
INSERT INTO occupe(id_service, num_pro, nom_f, date_debutO) VALUES(9, 63450789, 'Médecin de soins palliatifs', '2009/12/02');
INSERT INTO occupe(id_service, num_pro, nom_f, date_debutO) VALUES(5, 81903456, 'Pathologiste', '2015/11/02');
INSERT INTO occupe(id_service, num_pro, nom_f, date_debutO) VALUES(4, 81903456, 'Pathologiste', '2013/10/22');
INSERT INTO occupe(id_service, num_pro, nom_f, date_debutO) VALUES(4, 62450789, 'Radiologue', '2017/05/18');
INSERT INTO occupe VALUES(3, 63454734, 'Anesthésiologiste', '1980/05/20', '2018/04/27');
INSERT INTO occupe(id_service, num_pro, nom_f, date_debutO) VALUES(2, 60418923, 'Médecin généraliste', '2005/05/20');

--
-- Create view medecin_dispo
--

CREATE VIEW medecin_dispo AS
(
SELECT DISTINCT num_pro, id_service
FROM occupe NATURAL JOIN medecin
WHERE date_finO IS NULL AND id_interne IS not NULL
EXCEPT (
        SELECT DISTINCT num_pro, id_service
        FROM patient NATURAL JOIN occupe
)
);