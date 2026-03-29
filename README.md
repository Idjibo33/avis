# Avis

Avis est une application mobile interactive conçue pour faciliter la prise de décision sociale à travers un système de "Swipe". Les utilisateurs peuvent poser des questions sous forme de duels (Texte vs Texte ou Image vs Image) et laisser la communauté voter via une interface intuitive inspirée de Tinder.

## Fonctionnalités

- **Authentification :** Creation de compte utilisateur et connexion au compte utilisateur
- **Système de Swipe :** Interaction sur les posts pour enregistrer les votes..
- **Création de Posts :** Support des duels textuels et visuels avec upload d'images.
- **Real-time Updates :** Flux de données en direct.
- **Page de profil** : Affichage des posts et interactions de l'utilisateur sur la page de profil
- **Sécurité Avancée :** Protection des données via des politiques RLS (Row Level Security) strictes.
- **Statistiques d'un duel :** Affichage des resultat d'un duel

## Aperću

<img src="assets/screenshots/accueil.png" width="250" alt="Capture d'écran"> | <img src="assets/screenshots/drawer.png" width="250" alt="Capture d'écran"> | <img src="assets/screenshots/auth1.png" width="250" alt="Capture d'écran"> | <img src="assets/screenshots/auth2.png" width="250" alt="Capture d'écran"> | <img src="assets/screenshots/profil.png" width="250" alt="Capture d'écran"> | <img src="assets/screenshots/resultat_duel.png" width="250" alt="Capture d'écran">

## Stack technique
- **Front-end :** Flutter
- **Back-end :** Supabase(Auth, Storage)
- **State management :** Provider

## Architecture de la base de donnée 
Le projet utilise une base de données relationnelle robuste avec des Vues SQL pour optimiser les performances de lecture et simplifier le mapping des données dans Flutter.
- **Schema des tables :**
**Profiles** Stockage des informations des utilisateurs.
**posts** Contenu des duels (questions, options, auteur).
**interactions** Enregistrement des votes.

## Prochaines étapes
- Modification du design de la page du feed