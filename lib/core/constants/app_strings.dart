import 'package:flutter/src/widgets/framework.dart';

class AppStrings {
  static const String initialization = 'Initialisation...';
  static const String loadingResources = 'Chargement des ressources...';
  static const String preparingInterface = 'Préparation de l\'interface...';
  static const String almostDone = 'Presque terminé...';

  static const String appName = 'Immuno Warriors';
  static const String appNameShort = 'I-Warriors';
  static const String accessingProfiles = 'Accès aux Profils';
  static const String help = 'Aide';
  static const String theme = 'Thème';
  static const String gemini = 'Gémeaux';
  static const String profileDatabase = 'Base de Données des Profils';
  static const String accessingSecureData = 'Accès aux Données Sécurisées...';
  static const String noProfilesFound = 'Aucun profil trouvé.';
  static const String noProfilesFoundFuturistic =
      'Aucun profil détecté dans le réseau neuronal.';
  static const String profileLoadError =
      'Erreur lors du chargement des profils';
  static const String addNewAccount = 'Ajouter un Nouveau Compte';
  static const String unknownUser = 'Utilisateur Inconnu';
  static const String noProfilesAvailable =
      'Aucun profil utilisateur disponible.';
  static const String lightTheme = 'Thème Clair';
  static const String darkTheme = 'Thème Sombre';
  static const String systemTheme = 'Thème Système';

  // Écrans d'authentification

  static const String invalidProfileId = 'ID de profil invalide.';
  static const String profileNotFound = 'Profil non trouvé.';
  static const String profileAuthentication = 'Authentification du Profil';
  static const String enterPassword = 'Entrez le mot de passe';
  static const String authenticate = 'Authentifier';

  static const String loginTitle = 'Connexion';
  static const String authentication = 'Authentification';
  static const String authenticating = 'Authentification...';
  static const String emailLabel = 'Adresse e-mail';
  static const String passwordLabel = 'Mot de passe';
  static const String loginButton = 'Se connecter';
  static const String forgotPassword = 'Mot de passe oublié ?';
  static const String registerSuccess =
      'Inscription réussie ! Veuillez vous connecter.';
  static const String loginFailed =
      'Échec de la connexion. Veuillez vérifier vos informations.';
  static const String registerFailed =
      'Échec de la registration. Veuillez vérifier vos informations.';
  static const String invalidEmail = 'Adresse e-mail invalide.';
  static const String invalidPassword = 'Mot de passe invalide.';
  static String emailNotVerified =
      'Votre e-mail n\'a pas été vérifié. Veuillez vérifier votre boîte de réception.';
  static String noCurrentUser = 'Aucun utilisateur connecté.';

  static const String enterEmailForPasswordReset =
      'Veuillez entrer votre email pour réinitialiser le mot de passe.';
  static const String passwordResetEmailSent =
      'Un email de réinitialisation de mot de passe a été envoyé à votre adresse.';
  static const String passwordResetFailed =
      'Échec de l\'envoi de l\'email de réinitialisation. Veuillez réessayer.';
  static const String loadingProfile = 'Chargement du profil...';

  static const String registerButton =
      'S\'inscrire'; // Ajouté pour ProfileAuthOptionsScreen
  static const String registerTitle =
      'Créer un Nouveau Cyber-Guerrier'; // Ajouté pour RegisterScreen
  static const String emailHint = 'Adresse Email'; // Ajouté pour RegisterScreen
  static const String passwordHint =
      'Mot de Passe'; // Ajouté pour RegisterScreen
  static const String confirmPasswordHint =
      'Confirmer le Mot de Passe'; // Ajouté pour RegisterScreen
  static const String passwordMismatch =
      'Les mots de passe ne correspondent pas.'; // Ajouté pour RegisterScreen
  static const String registerAccount =
      'Créer le Compte'; // Ajouté pour RegisterScreen
  static const String orConnectWith =
      'Ou connectez-vous avec :'; // Ajouté pour RegisterScreen
  static const String signInWithGoogle =
      'Connexion avec Google'; // Ajouté pour RegisterScreen
  static const String signInWithFacebook =
      'Connexion avec Facebook'; // Ajouté pour RegisterScreen
  static const String alreadyHaveAccount =
      'Vous avez déjà un compte ?'; // Ajouté pour RegisterScreen
  static const String signInHere =
      'Connectez-vous ici'; // Ajouté pour RegisterScreen

  // Écran d'accueil (Dashboard)
  static const String dashboardTitle = 'Tableau de bord';
  static const String energy = 'Énergie';
  static const String bioMaterials = 'Bio-matériaux';
  static const String threatLevel = 'Niveau de menace';
  static const String geminiAdvice = 'Conseil de l\'analyste IA';
  static const String resources = 'Ressources';

  // Écran de combat
  static const String combatTitle = 'Simulateur de Combat';
  static const String attack = 'Attaquer';
  static const String defend = 'Défendre';
  static const String combatLog = 'Journal de combat';
  static const String combatVictory = 'Victoire !';
  static const String combatDefeat = 'Défaite.';
  static const String combatTurn = 'Tour';
  static const String combatStart = 'Début du combat';
  static const String combatSummary = 'Résumé du combat';

  // Écran de recherche
  static const String researchTitle = 'Laboratoire de Recherche';
  static const String researchPoints = 'Points de recherche';
  static const String unlock = 'Débloquer';
  static const String researchTree = 'Arbre de recherche';
  static const String researchProgress = 'Progression de la recherche';
  static const String researchComplete = 'Recherche terminée !';

  // Écran BioForge
  static const String bioForgeTitle = 'BioForge';
  static const String deploy = 'Déployer';
  static const String saveConfiguration = 'Enregistrer la configuration';
  static const String baseConfiguration = 'Configuration de la base';
  static const String pathogenSlots = 'Emplacements de pathogènes';
  static const String defenseGrid = 'Grille de défense';

  // Écran War Archive
  static const String warArchiveTitle = 'Archives de Guerre';
  static const String combatReports = 'Rapports de combat';
  static const String generateChronicle = 'Générer la chronique';
  static const String chronicle = 'Chronique';
  static const String noReports = 'Aucun rapport de combat disponible.';

  // Écran Threat Scanner
  static const String threatScannerTitle = 'Scanner de Menaces';
  static const String scan = 'Scanner';
  static const String nearbyBases = 'Bases ennemies à proximité';
  static const String noBasesFound = 'Aucune base ennemie détectée.';
  static const String scanInProgress = 'Analyse en cours...';

  // Messages d'erreur
  static const String errorTitle = 'Erreur';
  static const String errorMessage =
      'Une erreur est survenue. Veuillez réessayer.';
  static const String networkError =
      'Erreur de réseau. Veuillez vérifier votre connexion.';
  static const String firebaseError = 'Erreur Firebase : ';
  static const String geminiError = 'Erreur Gemini : ';
  static const String hiveError = 'Erreur Hive : ';
  static const String signOutFailed =
      'Échec de la déconnexion. Veuillez réessayer.';

  // Messages de succès
  static const String successTitle = 'Succès';
  static const String successMessage = 'Opération réussie !';

  // Textes communs
  static const String ok = 'OK';
  static const String cancel = 'Annuler';
  static const String confirm = 'Confirmer';
  static const String loading = 'Chargement...';
  static const String emptyState = 'Aucun élément à afficher.';
  static const String back = 'Retour';
  static const String next = 'Suivant';
  static const String close = 'Fermer';

  static const String noUsersFound = " ";

  static String hiveInitializationFailed =
      'Failed to initialize local storage. The app may not function correctly.';

  static const String weakPassword = "Le mot de passe est trop faible";


  static const String chooseYourAvatar = 'Choisissez votre Avatar';
  static const String enterUsername = 'Nom d\'Utilisateur';
  static const String profileCreated = 'Profil créé avec succès !';
  static const String welcomeToImmunoWarriors = 'Bienvenue, Cyber-Guerrier !';
  static const String noInternetConnection = 'Pas de connexion internet. Veuillez vérifier votre connexion.';

  static String continueButtonText = "GO";

  static const String authWelcomeTitle = "Bienvenue dans votre Système Immunitaire Virtuel";
  static const String authWelcomeSubtitle = "Sélectionnez votre mode d'accès pour commencer";
  static const String loginDescription = "Accédez à votre espace sécurisé avec vos identifiants existants";
  static const String registerDescription = "Rejoignez notre communauté et créez votre profil immunitaire";
  static const String needHelp = "Besoin d'aide ?";
  static const String selectTheme = "Sélectionnez un Thème";
}
