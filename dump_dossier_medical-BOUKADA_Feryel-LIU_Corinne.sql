--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.19
-- Dumped by pg_dump version 9.6.24

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: acte_medicaux; Type: TABLE; Schema: public; Owner: corinne.liu
--

CREATE TABLE public.acte_medicaux (
    id_acte integer NOT NULL,
    nom_a character varying(200) NOT NULL,
    resume text NOT NULL,
    date_heure timestamp without time zone NOT NULL,
    num_secu integer NOT NULL
);


ALTER TABLE public.acte_medicaux OWNER TO "corinne.liu";

--
-- Name: acte_medicaux_id_acte_seq; Type: SEQUENCE; Schema: public; Owner: corinne.liu
--

CREATE SEQUENCE public.acte_medicaux_id_acte_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.acte_medicaux_id_acte_seq OWNER TO "corinne.liu";

--
-- Name: acte_medicaux_id_acte_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: corinne.liu
--

ALTER SEQUENCE public.acte_medicaux_id_acte_seq OWNED BY public.acte_medicaux.id_acte;


--
-- Name: allergie; Type: TABLE; Schema: public; Owner: corinne.liu
--

CREATE TABLE public.allergie (
    code integer NOT NULL,
    nom character varying(50) NOT NULL,
    niveau smallint NOT NULL,
    CONSTRAINT allergie_niveau_check CHECK (((niveau >= 1) AND (niveau <= 10)))
);


ALTER TABLE public.allergie OWNER TO "corinne.liu";

--
-- Name: allergie_code_seq; Type: SEQUENCE; Schema: public; Owner: corinne.liu
--

CREATE SEQUENCE public.allergie_code_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.allergie_code_seq OWNER TO "corinne.liu";

--
-- Name: allergie_code_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: corinne.liu
--

ALTER SEQUENCE public.allergie_code_seq OWNED BY public.allergie.code;


--
-- Name: contient; Type: TABLE; Schema: public; Owner: corinne.liu
--

CREATE TABLE public.contient (
    num_secu integer NOT NULL,
    id_service integer NOT NULL,
    date date NOT NULL
);


ALTER TABLE public.contient OWNER TO "corinne.liu";

--
-- Name: contient_id_service_seq; Type: SEQUENCE; Schema: public; Owner: corinne.liu
--

CREATE SEQUENCE public.contient_id_service_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.contient_id_service_seq OWNER TO "corinne.liu";

--
-- Name: contient_id_service_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: corinne.liu
--

ALTER SEQUENCE public.contient_id_service_seq OWNED BY public.contient.id_service;


--
-- Name: fichier_num; Type: TABLE; Schema: public; Owner: corinne.liu
--

CREATE TABLE public.fichier_num (
    num integer NOT NULL,
    nom character varying(100),
    fichier character varying(1000) NOT NULL,
    id_acte integer NOT NULL
);


ALTER TABLE public.fichier_num OWNER TO "corinne.liu";

--
-- Name: fichier_num_id_acte_seq; Type: SEQUENCE; Schema: public; Owner: corinne.liu
--

CREATE SEQUENCE public.fichier_num_id_acte_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fichier_num_id_acte_seq OWNER TO "corinne.liu";

--
-- Name: fichier_num_id_acte_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: corinne.liu
--

ALTER SEQUENCE public.fichier_num_id_acte_seq OWNED BY public.fichier_num.id_acte;


--
-- Name: fichier_num_num_seq; Type: SEQUENCE; Schema: public; Owner: corinne.liu
--

CREATE SEQUENCE public.fichier_num_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fichier_num_num_seq OWNER TO "corinne.liu";

--
-- Name: fichier_num_num_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: corinne.liu
--

ALTER SEQUENCE public.fichier_num_num_seq OWNED BY public.fichier_num.num;


--
-- Name: fonction; Type: TABLE; Schema: public; Owner: corinne.liu
--

CREATE TABLE public.fonction (
    nom_f character varying(50) NOT NULL
);


ALTER TABLE public.fonction OWNER TO "corinne.liu";

--
-- Name: medecin; Type: TABLE; Schema: public; Owner: corinne.liu
--

CREATE TABLE public.medecin (
    num_pro integer NOT NULL,
    id_interne integer,
    nom character varying(50) NOT NULL,
    prenom character varying(50) NOT NULL,
    adresse character varying(100) NOT NULL,
    mdp character varying(100)
);


ALTER TABLE public.medecin OWNER TO "corinne.liu";

--
-- Name: occupe; Type: TABLE; Schema: public; Owner: corinne.liu
--

CREATE TABLE public.occupe (
    id_service integer NOT NULL,
    num_pro integer NOT NULL,
    nom_f character varying(50) NOT NULL,
    date_debuto date NOT NULL,
    date_fino date,
    CONSTRAINT occupe_check CHECK ((date_fino > date_debuto))
);


ALTER TABLE public.occupe OWNER TO "corinne.liu";

--
-- Name: patient; Type: TABLE; Schema: public; Owner: corinne.liu
--

CREATE TABLE public.patient (
    num_secu integer NOT NULL,
    nom_naissance character varying(50) NOT NULL,
    nom_usage character varying(50) NOT NULL,
    prenom character varying(50) NOT NULL,
    adresse character varying(100),
    num_pro integer NOT NULL
);


ALTER TABLE public.patient OWNER TO "corinne.liu";

--
-- Name: medecin_dispo; Type: VIEW; Schema: public; Owner: corinne.liu
--

CREATE VIEW public.medecin_dispo AS
 SELECT DISTINCT occupe.num_pro,
    occupe.id_service
   FROM (public.occupe
     JOIN public.medecin USING (num_pro))
  WHERE ((occupe.date_fino IS NULL) AND (medecin.id_interne IS NOT NULL))
EXCEPT
 SELECT DISTINCT patient.num_pro,
    occupe.id_service
   FROM (public.patient
     JOIN public.occupe USING (num_pro));


ALTER TABLE public.medecin_dispo OWNER TO "corinne.liu";

--
-- Name: service; Type: TABLE; Schema: public; Owner: corinne.liu
--

CREATE TABLE public.service (
    id_service integer NOT NULL,
    nom character varying(50) NOT NULL,
    localite character varying(100) NOT NULL
);


ALTER TABLE public.service OWNER TO "corinne.liu";

--
-- Name: service_id_service_seq; Type: SEQUENCE; Schema: public; Owner: corinne.liu
--

CREATE SEQUENCE public.service_id_service_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.service_id_service_seq OWNER TO "corinne.liu";

--
-- Name: service_id_service_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: corinne.liu
--

ALTER SEQUENCE public.service_id_service_seq OWNED BY public.service.id_service;


--
-- Name: touche; Type: TABLE; Schema: public; Owner: corinne.liu
--

CREATE TABLE public.touche (
    code integer NOT NULL,
    num_secu integer NOT NULL,
    date_debutt date NOT NULL,
    date_fint date,
    CONSTRAINT touche_check CHECK ((date_fint > date_debutt))
);


ALTER TABLE public.touche OWNER TO "corinne.liu";

--
-- Name: acte_medicaux id_acte; Type: DEFAULT; Schema: public; Owner: corinne.liu
--

ALTER TABLE ONLY public.acte_medicaux ALTER COLUMN id_acte SET DEFAULT nextval('public.acte_medicaux_id_acte_seq'::regclass);


--
-- Name: allergie code; Type: DEFAULT; Schema: public; Owner: corinne.liu
--

ALTER TABLE ONLY public.allergie ALTER COLUMN code SET DEFAULT nextval('public.allergie_code_seq'::regclass);


--
-- Name: contient id_service; Type: DEFAULT; Schema: public; Owner: corinne.liu
--

ALTER TABLE ONLY public.contient ALTER COLUMN id_service SET DEFAULT nextval('public.contient_id_service_seq'::regclass);


--
-- Name: fichier_num num; Type: DEFAULT; Schema: public; Owner: corinne.liu
--

ALTER TABLE ONLY public.fichier_num ALTER COLUMN num SET DEFAULT nextval('public.fichier_num_num_seq'::regclass);


--
-- Name: fichier_num id_acte; Type: DEFAULT; Schema: public; Owner: corinne.liu
--

ALTER TABLE ONLY public.fichier_num ALTER COLUMN id_acte SET DEFAULT nextval('public.fichier_num_id_acte_seq'::regclass);


--
-- Name: service id_service; Type: DEFAULT; Schema: public; Owner: corinne.liu
--

ALTER TABLE ONLY public.service ALTER COLUMN id_service SET DEFAULT nextval('public.service_id_service_seq'::regclass);


--
-- Data for Name: acte_medicaux; Type: TABLE DATA; Schema: public; Owner: corinne.liu
--

INSERT INTO public.acte_medicaux VALUES (1, 'Vaccinations ', 'Vaccin grippe fait. Vaccin en régle.', '2016-12-05 16:25:00', 67210395);
INSERT INTO public.acte_medicaux VALUES (2, 'Radiographie pulmonaire', 'Image des poumons obtenus par rayons X. Détections d une tumeurs au poumon. Niveau gravité : grave.', '2018-03-02 10:39:00', 31582074);
INSERT INTO public.acte_medicaux VALUES (3, 'Test cutané d allergie', 'Test cutanné fait. Allergie au pollen.', '2018-03-02 13:00:00', 31582074);
INSERT INTO public.acte_medicaux VALUES (4, 'Tests sanguins d immunoglobulines', 'Test sanguin fait. Allergie au acarien.', '2020-11-15 14:47:00', 53987102);
INSERT INTO public.acte_medicaux VALUES (5, 'IRM cérébrale', 'Image cérébrale du patient obtenue par radio. Détections d un kyest au cerveau.', '2019-07-11 16:05:00', 84569213);


--
-- Name: acte_medicaux_id_acte_seq; Type: SEQUENCE SET; Schema: public; Owner: corinne.liu
--

SELECT pg_catalog.setval('public.acte_medicaux_id_acte_seq', 5, true);


--
-- Data for Name: allergie; Type: TABLE DATA; Schema: public; Owner: corinne.liu
--

INSERT INTO public.allergie VALUES (1, 'Chat', 1);
INSERT INTO public.allergie VALUES (2, 'Abeille', 4);
INSERT INTO public.allergie VALUES (3, 'Arachides', 10);
INSERT INTO public.allergie VALUES (4, 'Pénicilline', 3);
INSERT INTO public.allergie VALUES (5, 'Fruits de mer', 8);
INSERT INTO public.allergie VALUES (6, 'Morphine', 8);


--
-- Name: allergie_code_seq; Type: SEQUENCE SET; Schema: public; Owner: corinne.liu
--

SELECT pg_catalog.setval('public.allergie_code_seq', 6, true);


--
-- Data for Name: contient; Type: TABLE DATA; Schema: public; Owner: corinne.liu
--

INSERT INTO public.contient VALUES (31582074, 4, '2018-03-02');
INSERT INTO public.contient VALUES (31582074, 8, '2018-02-23');
INSERT INTO public.contient VALUES (72641038, 7, '2001-06-29');
INSERT INTO public.contient VALUES (91345628, 1, '1978-11-06');
INSERT INTO public.contient VALUES (67210395, 1, '1978-11-06');
INSERT INTO public.contient VALUES (67210395, 1, '1999-06-04');
INSERT INTO public.contient VALUES (84569213, 2, '2004-02-14');
INSERT INTO public.contient VALUES (53987102, 6, '2014-05-18');
INSERT INTO public.contient VALUES (21789035, 9, '2019-05-18');


--
-- Name: contient_id_service_seq; Type: SEQUENCE SET; Schema: public; Owner: corinne.liu
--

SELECT pg_catalog.setval('public.contient_id_service_seq', 1, false);


--
-- Data for Name: fichier_num; Type: TABLE DATA; Schema: public; Owner: corinne.liu
--

INSERT INTO public.fichier_num VALUES (1, 'Image radio poumon droit de M.Martin', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQfQzMG1-kHcy2Z-20NnESUuCSRdLceRBUUJQ&usqp=CAU', 2);
INSERT INTO public.fichier_num VALUES (2, 'Image radio poumon gauche de M.Martin', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSwOxjvLjd5vDdi-8Sas2ddVXnuGkS3k8m4w&usqp=CAU', 2);
INSERT INTO public.fichier_num VALUES (3, NULL, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQXuQ7zrNeY-SY7MFwrqQLcsl-JnX2JBlO9jw&usqp=CAU', 5);


--
-- Name: fichier_num_id_acte_seq; Type: SEQUENCE SET; Schema: public; Owner: corinne.liu
--

SELECT pg_catalog.setval('public.fichier_num_id_acte_seq', 1, false);


--
-- Name: fichier_num_num_seq; Type: SEQUENCE SET; Schema: public; Owner: corinne.liu
--

SELECT pg_catalog.setval('public.fichier_num_num_seq', 3, true);


--
-- Data for Name: fonction; Type: TABLE DATA; Schema: public; Owner: corinne.liu
--

INSERT INTO public.fonction VALUES ('Médecin urgentiste');
INSERT INTO public.fonction VALUES ('Cardiologue');
INSERT INTO public.fonction VALUES ('Chirurgien');
INSERT INTO public.fonction VALUES ('Anesthésiologiste');
INSERT INTO public.fonction VALUES ('Radiologue');
INSERT INTO public.fonction VALUES ('Pathologiste');
INSERT INTO public.fonction VALUES ('Médecin de soins intensifs');
INSERT INTO public.fonction VALUES ('Médecin de médecine interne');
INSERT INTO public.fonction VALUES ('Pédiatre');
INSERT INTO public.fonction VALUES ('Médecin de soins palliatifs');
INSERT INTO public.fonction VALUES ('Médecin généraliste');


--
-- Data for Name: medecin; Type: TABLE DATA; Schema: public; Owner: corinne.liu
--

INSERT INTO public.medecin VALUES (12608013, 3308905, 'Dupont', 'Paul', '23 avenue Marchal 77000 Marne-la-Vallée', '$2b$12$yEC2sq6CzHgr6EPPBqH7a.OwRKr/I/jfYwK4SJFiNB.RU9wLX6BDC');
INSERT INTO public.medecin VALUES (20731450, 7800120, 'Nguyen', 'Emilie', '107 rue République 75016 Paris', '$2b$12$glCbiE49yOQS8fOQ6ICSOeYhMK3S3kW/A6VnZwDs/XB20oJG3jvp.');
INSERT INTO public.medecin VALUES (40891234, 9876543, 'Smith', 'Sophia', '42 Avenue des Lilas 92130 Issy-les-Moulineaux', '$2b$12$ca5z0YluoC3T.g2ZmEOqTOUSbdxdS0UsRkYF3YoBgnH1VwNoVS7sS');
INSERT INTO public.medecin VALUES (31570248, 6543210, 'Nguyen', 'Joseph', '107 rue République 75016 Paris', '$2b$12$SK0G1Di1hMSwpvB8vK6lT.5UQqSQjUNcBCvKtvaiPw0YGJDdOPy/2');
INSERT INTO public.medecin VALUES (52360123, 1234567, 'Garcia', 'Pedro', '28 Boulevard Saint-Michel 94250 Gentilly', '$2b$12$uwovYjzHutoivNV8WfcjG.9MRUwIQYMfVCBb9O43WvxhWoMcEoFf.');
INSERT INTO public.medecin VALUES (69584321, 7654321, 'Chang', 'Lily', '5 Avenue du Général Leclerc 93120 La Courneuve', '$2b$12$4ji29OfgefPFqZ/zSyvt3.QKUY2Z2SD2zrSkPSuVAuTCeKeZ0uYGO');
INSERT INTO public.medecin VALUES (81903456, 3450123, 'Dubois', 'Luc', '71 Rue de la Paix 78000 Versailles', '$2b$12$vbmQIM5JEmp69SImLqtf2OKCquJ94dCm4xfW0svVGDnm.ZCqa1mTO');
INSERT INTO public.medecin VALUES (93784512, 5678901, 'Fernandez', 'Juan', '39 Quai de la Tournelle 75005 Paris', '$2b$12$kH1fAn5ggtCDwuu074OY9OBgz07LgnJroGHoF6agh0pzbV.4wKfXa');
INSERT INTO public.medecin VALUES (62450789, 8901234, 'Garcia', 'Antoine', '11 Rue des Roses 92140 Clamart', '$2b$12$GoyR7NRVCXnxT.bmea3ZeeOdqe7DRJMh23HI0z/LlYIpWAYZzlQHa');
INSERT INTO public.medecin VALUES (63450789, 8101234, 'Hubert', 'Antoinette', '14 Rue des Roses 92140 Clamart', '$2b$12$EGU0LEJJEeGOLtqEb5Ps3OgwTvkNctQfDIilHzblckGM3fO/u.CMy');
INSERT INTO public.medecin VALUES (63454734, 8119472, 'Jean', 'Charles', '15 Rue des Roses 92140 Clamart', '$2b$12$sumjyG71Y1zpOa6BNVEru.qXc9LE.xwL6yWMMv6f20VtOVL6fMiwS');
INSERT INTO public.medecin VALUES (60418923, 4872468, 'Rodriguez', 'Gustave', '71 Rue de la Paix 78000 Versailles', '$2b$12$9BAq/6puYfD3T.EIT4YjBO/.ph2dZ9tNQeUsirlHNfW33Ace3XhUK');
INSERT INTO public.medecin VALUES (30765489, NULL, 'Girard', 'Louis', '14 Boulevard de l Indépendance 75012 Paris', NULL);
INSERT INTO public.medecin VALUES (46521378, NULL, 'Moreau', 'Juliette', '3 Avenue des Champs-Élysées 92000 Nanterre', NULL);
INSERT INTO public.medecin VALUES (51907634, NULL, 'Lee', 'Juliette', '55 Rue du Faubourg Saint-Antoine 75011 Paris', NULL);


--
-- Data for Name: occupe; Type: TABLE DATA; Schema: public; Owner: corinne.liu
--

INSERT INTO public.occupe VALUES (4, 12608013, 'Radiologue', '2000-05-18', '2017-05-18');
INSERT INTO public.occupe VALUES (1, 12608013, 'Médecin urgentiste', '2019-05-18', NULL);
INSERT INTO public.occupe VALUES (8, 12608013, 'Pédiatre', '2020-05-18', NULL);
INSERT INTO public.occupe VALUES (2, 20731450, 'Cardiologue', '1999-11-18', '2005-05-20');
INSERT INTO public.occupe VALUES (2, 20731450, 'Médecin généraliste', '2005-05-20', NULL);
INSERT INTO public.occupe VALUES (2, 40891234, 'Cardiologue', '2005-05-20', '2020-05-20');
INSERT INTO public.occupe VALUES (6, 40891234, 'Cardiologue', '2005-05-20', NULL);
INSERT INTO public.occupe VALUES (7, 31570248, 'Médecin de médecine interne', '2000-10-29', NULL);
INSERT INTO public.occupe VALUES (3, 40891234, 'Anesthésiologiste', '1980-05-20', '2010-04-27');
INSERT INTO public.occupe VALUES (3, 69584321, 'Chirurgien', '2009-12-02', NULL);
INSERT INTO public.occupe VALUES (3, 69584321, 'Anesthésiologiste', '2010-12-02', NULL);
INSERT INTO public.occupe VALUES (9, 63450789, 'Médecin de soins palliatifs', '2009-12-02', NULL);
INSERT INTO public.occupe VALUES (5, 81903456, 'Pathologiste', '2015-11-02', NULL);
INSERT INTO public.occupe VALUES (4, 81903456, 'Pathologiste', '2013-10-22', NULL);
INSERT INTO public.occupe VALUES (4, 62450789, 'Radiologue', '2017-05-18', NULL);
INSERT INTO public.occupe VALUES (3, 63454734, 'Anesthésiologiste', '1980-05-20', '2018-04-27');
INSERT INTO public.occupe VALUES (2, 60418923, 'Médecin généraliste', '2005-05-20', NULL);


--
-- Data for Name: patient; Type: TABLE DATA; Schema: public; Owner: corinne.liu
--

INSERT INTO public.patient VALUES (31582074, 'Martin', 'Martin', 'Lucas', '42 avenue des Fleurs 92100 Boulogne-Billancourt', 30765489);
INSERT INTO public.patient VALUES (72641038, 'Leroy', 'Moreau', 'Juliette', '3 Avenue des Champs-Élysées 92000 Nanterre', 30765489);
INSERT INTO public.patient VALUES (91345628, 'Leroy', 'Gustave', 'Hugo', '8 rue de la Paix 75002 Paris', 51907634);
INSERT INTO public.patient VALUES (67210395, 'Lee', 'Lee', 'Jade', '27 boulevard Voltaire 75011 Paris', 51907634);
INSERT INTO public.patient VALUES (84569213, 'Leclerc', 'Lee', 'Mathis', '27 boulevard Voltaire 75011 Paris', 46521378);
INSERT INTO public.patient VALUES (53987102, 'Roy', 'Blanc', 'Léa', '21 rue du Faubourg Saint-Antoine 75011 Paris', 60418923);
INSERT INTO public.patient VALUES (21789035, 'Dupont', 'Dupont', 'Marco', NULL, 51907634);


--
-- Data for Name: service; Type: TABLE DATA; Schema: public; Owner: corinne.liu
--

INSERT INTO public.service VALUES (1, 'Urgences médicales', '1er étage Batiment Copernic Porte A');
INSERT INTO public.service VALUES (2, 'Consultations externes', '1er étage Batiment Copernic Porte B');
INSERT INTO public.service VALUES (3, 'Chirurgie', '1er étage Batiment Copernic Porte C');
INSERT INTO public.service VALUES (4, 'Radiologie', '2eme étage Batiment Copernic Porte D');
INSERT INTO public.service VALUES (5, 'Laboratoire médical', '2eme étage Batiment Copernic Porte E');
INSERT INTO public.service VALUES (6, 'Soins intensifs', '2eme étage Batiment Copernic Porte F');
INSERT INTO public.service VALUES (7, 'Médecine interne', '3eme étage Batiment Copernic Porte G');
INSERT INTO public.service VALUES (8, 'Pédiatrie', '3eme étage Batiment Copernic Porte H');
INSERT INTO public.service VALUES (9, 'Soins palliatifs', '1eme étage Batiment Eiffel Porte B');
INSERT INTO public.service VALUES (10, 'Pharmacie hospitalière', '2eme étage Batiment Eiffel Porte C');
INSERT INTO public.service VALUES (11, 'Service des admissions', 'Internet');


--
-- Name: service_id_service_seq; Type: SEQUENCE SET; Schema: public; Owner: corinne.liu
--

SELECT pg_catalog.setval('public.service_id_service_seq', 11, true);


--
-- Data for Name: touche; Type: TABLE DATA; Schema: public; Owner: corinne.liu
--

INSERT INTO public.touche VALUES (1, 31582074, '2018-03-02', '2020-07-02');
INSERT INTO public.touche VALUES (3, 31582074, '2018-03-02', NULL);
INSERT INTO public.touche VALUES (1, 72641038, '2016-12-12', '2021-09-02');
INSERT INTO public.touche VALUES (4, 21789035, '2016-12-12', NULL);
INSERT INTO public.touche VALUES (4, 53987102, '1978-09-01', '2012-12-30');


--
-- Name: acte_medicaux acte_medicaux_pkey; Type: CONSTRAINT; Schema: public; Owner: corinne.liu
--

ALTER TABLE ONLY public.acte_medicaux
    ADD CONSTRAINT acte_medicaux_pkey PRIMARY KEY (id_acte);


--
-- Name: allergie allergie_nom_key; Type: CONSTRAINT; Schema: public; Owner: corinne.liu
--

ALTER TABLE ONLY public.allergie
    ADD CONSTRAINT allergie_nom_key UNIQUE (nom);


--
-- Name: allergie allergie_pkey; Type: CONSTRAINT; Schema: public; Owner: corinne.liu
--

ALTER TABLE ONLY public.allergie
    ADD CONSTRAINT allergie_pkey PRIMARY KEY (code);


--
-- Name: contient contient_pkey; Type: CONSTRAINT; Schema: public; Owner: corinne.liu
--

ALTER TABLE ONLY public.contient
    ADD CONSTRAINT contient_pkey PRIMARY KEY (num_secu, id_service, date);


--
-- Name: fichier_num fichier_num_fichier_key; Type: CONSTRAINT; Schema: public; Owner: corinne.liu
--

ALTER TABLE ONLY public.fichier_num
    ADD CONSTRAINT fichier_num_fichier_key UNIQUE (fichier);


--
-- Name: fichier_num fichier_num_pkey; Type: CONSTRAINT; Schema: public; Owner: corinne.liu
--

ALTER TABLE ONLY public.fichier_num
    ADD CONSTRAINT fichier_num_pkey PRIMARY KEY (num);


--
-- Name: fonction fonction_pkey; Type: CONSTRAINT; Schema: public; Owner: corinne.liu
--

ALTER TABLE ONLY public.fonction
    ADD CONSTRAINT fonction_pkey PRIMARY KEY (nom_f);


--
-- Name: medecin medecin_id_interne_key; Type: CONSTRAINT; Schema: public; Owner: corinne.liu
--

ALTER TABLE ONLY public.medecin
    ADD CONSTRAINT medecin_id_interne_key UNIQUE (id_interne);


--
-- Name: medecin medecin_pkey; Type: CONSTRAINT; Schema: public; Owner: corinne.liu
--

ALTER TABLE ONLY public.medecin
    ADD CONSTRAINT medecin_pkey PRIMARY KEY (num_pro);


--
-- Name: occupe occupe_pkey; Type: CONSTRAINT; Schema: public; Owner: corinne.liu
--

ALTER TABLE ONLY public.occupe
    ADD CONSTRAINT occupe_pkey PRIMARY KEY (id_service, num_pro, nom_f);


--
-- Name: patient patient_pkey; Type: CONSTRAINT; Schema: public; Owner: corinne.liu
--

ALTER TABLE ONLY public.patient
    ADD CONSTRAINT patient_pkey PRIMARY KEY (num_secu);


--
-- Name: service service_pkey; Type: CONSTRAINT; Schema: public; Owner: corinne.liu
--

ALTER TABLE ONLY public.service
    ADD CONSTRAINT service_pkey PRIMARY KEY (id_service);


--
-- Name: touche touche_pkey; Type: CONSTRAINT; Schema: public; Owner: corinne.liu
--

ALTER TABLE ONLY public.touche
    ADD CONSTRAINT touche_pkey PRIMARY KEY (code, num_secu);


--
-- Name: acte_medicaux acte_medicaux_num_secu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: corinne.liu
--

ALTER TABLE ONLY public.acte_medicaux
    ADD CONSTRAINT acte_medicaux_num_secu_fkey FOREIGN KEY (num_secu) REFERENCES public.patient(num_secu);


--
-- Name: contient contient_id_service_fkey; Type: FK CONSTRAINT; Schema: public; Owner: corinne.liu
--

ALTER TABLE ONLY public.contient
    ADD CONSTRAINT contient_id_service_fkey FOREIGN KEY (id_service) REFERENCES public.service(id_service);


--
-- Name: contient contient_num_secu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: corinne.liu
--

ALTER TABLE ONLY public.contient
    ADD CONSTRAINT contient_num_secu_fkey FOREIGN KEY (num_secu) REFERENCES public.patient(num_secu);


--
-- Name: fichier_num fichier_num_id_acte_fkey; Type: FK CONSTRAINT; Schema: public; Owner: corinne.liu
--

ALTER TABLE ONLY public.fichier_num
    ADD CONSTRAINT fichier_num_id_acte_fkey FOREIGN KEY (id_acte) REFERENCES public.acte_medicaux(id_acte);


--
-- Name: occupe occupe_id_service_fkey; Type: FK CONSTRAINT; Schema: public; Owner: corinne.liu
--

ALTER TABLE ONLY public.occupe
    ADD CONSTRAINT occupe_id_service_fkey FOREIGN KEY (id_service) REFERENCES public.service(id_service);


--
-- Name: occupe occupe_nom_f_fkey; Type: FK CONSTRAINT; Schema: public; Owner: corinne.liu
--

ALTER TABLE ONLY public.occupe
    ADD CONSTRAINT occupe_nom_f_fkey FOREIGN KEY (nom_f) REFERENCES public.fonction(nom_f);


--
-- Name: occupe occupe_num_pro_fkey; Type: FK CONSTRAINT; Schema: public; Owner: corinne.liu
--

ALTER TABLE ONLY public.occupe
    ADD CONSTRAINT occupe_num_pro_fkey FOREIGN KEY (num_pro) REFERENCES public.medecin(num_pro);


--
-- Name: patient patient_num_pro_fkey; Type: FK CONSTRAINT; Schema: public; Owner: corinne.liu
--

ALTER TABLE ONLY public.patient
    ADD CONSTRAINT patient_num_pro_fkey FOREIGN KEY (num_pro) REFERENCES public.medecin(num_pro);


--
-- Name: touche touche_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: corinne.liu
--

ALTER TABLE ONLY public.touche
    ADD CONSTRAINT touche_code_fkey FOREIGN KEY (code) REFERENCES public.allergie(code);


--
-- Name: touche touche_num_secu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: corinne.liu
--

ALTER TABLE ONLY public.touche
    ADD CONSTRAINT touche_num_secu_fkey FOREIGN KEY (num_secu) REFERENCES public.patient(num_secu);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

