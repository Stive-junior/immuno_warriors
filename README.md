# Welcome to immuno_warriors

// flutter pub run build_runner build --delete-conflicting-outputs


Controllers : Les fichiers de controllers/ gèrent les requêtes HTTP et appellent les fonctions des services/ pour exécuter la logique métier. Ils dépendent donc fortement des services/. Ils utilisent également les utilitaires de utils/ (ex. errorUtils.js, logger.js) et les schémas de models/ pour valider les données.
Repositories : Les fichiers de repositories/ interagissent directement avec Firestore pour les opérations CRUD. Ils n'ont pas de dépendances sur controllers/, services/, ou routes/, mais utilisent les schémas de models/ pour valider les données Firestore et les utilitaires de utils/ (ex. logger.js, errorUtils.js). Ils nécessitent firebase-admin pour l'accès à Firestore.
Services : Les fichiers de services/ contiennent la logique métier et appellent les méthodes des repositories/ pour accéder aux données. Ils dépendent donc des repositories/ et utilisent les schémas de models/ et les utilitaires de utils/.
Routes : Les fichiers de routes/ définissent les endpoints API et mappent les requêtes aux fonctions des controllers/. Ils dépendent donc des controllers/ et utilisent les middlewares de middleware/ (ex. authMiddleware.js) et les utilitaires de utils/ (ex. validationUtils.js).



Voici une représentation schématique de l'architecture complète du projet "ImmunoWarriors", intégrant les nouvelles fonctionnalités et les modifications discutées :immuno_warriors/
├── main.dart                      # Initialisation Firebase/Hive + runApp
├── firebase_options.dart          # Généré par FlutterFire CLI
├── core/
│   ├── constants/
│   │   ├── app_assets.dart    # Chemins des assets (images, polices)
│   │   ├── app_colors.dart    # Palette de couleurs
│   │   ├── app_keys.dart      # Clés pour les tests/intégration
│   │   ├── app_strings.dart   # Textes localisables
│   │   ├── app_styles.dart    # TextStyles et thèmes
│   │   ├── game_constants.dart    # PV, dégâts, coûts R&D...
│   │   └── pathogen_types.dart    # Types d'attaques/résistances
│   ├── extensions/            # Extensions Dart/Flutter
│   │   ├── context_extension.dart # Utilitaires pour BuildContext
│   │   └── string_extension.dart # Méthodes pour String
│   ├── network/            # Couche réseau
│   │   ├── api_endpoints.dart # URLs des API
│   │   ├── dio_client.dart    # Client HTTP
│   │   └── network_info.dart  # Vérification de la connectivité
│   ├── routes/                # Gestion des routes
│   │   ├── app_router.dart    # Génération des routes
│   │   ├── route_names.dart   # Noms des routes (ex: '/login')
│   │   └── route_transitions.dart # Animations de navigation
│   ├── services/              # Services globaux
│   │   ├── auth_service.dart  # Gestion authentification
│   │   ├── local_storage_service.dart # Stockage local (Hive)
│   │   ├── gemini_service.dart # Appels à l'API Gemini
│   │   ├── combat_service.dart    # Logique de combat
│   │   ├── research_service.dart  # Gestion R&D
│   │   └── mutation_service.dart  # Aléatoire des mutations
│   └── utils/                 # Utilitaires
│       ├── app_logger.dart    # Logging structuré
│       ├── date_utils.dart    # Formattage des dates
│       ├── dialog_utils.dart  # Affichage de dialogs
│       └── combat_utils.dart      # Calcul des dégâts/bonus
├── data/
│   ├── datasources/           # Sources de données
│   │   ├── local/             # Local (Hive)
│   │   │   └── user_local_datasource.dart
│   │   └── remote/            # Remote (Firebase, API)
│   │       ├── user_remote_datasource.dart
│   │       ├── base_viral_datasource.dart     # Firestore: Bases virales
│   │       ├── combat_report_datasource.dart  # Firestore: Historique combats
│   │       └── research_datasource.dart       # Firestore: Arbre R&D
│   ├── models/                # Modèles de données
│   │   ├── user_model.dart    # Modèle User
│   │   ├── api/              # Modèles spécifiques aux API
│   │   │   └── gemini_response.dart
│   │   ├── combat/
│   │   │   ├── antibody_model.dart
│   │   │   └── pathogen_model.dart
│   │   ├── base_viral_model.dart
│   │   └── research_model.dart
│   └── repositories/          # Implémentations des repositories
│       ├── user_repository_impl.dart
│       └── combat_repository_impl.dart
├── domain/
│   ├── entities/              # Entités métier
│   │   ├── user_entity.dart
│   │   ├── combat/
│   │   │   └── pathogen_entity.dart  # Classe abstraite
│   │   └── research_entity.dart
│   ├── repositories/          # Interfaces des repositories
│   │   ├── user_repository.dart
│       └── combat_repository.dart
│   └── usecases/              # Cas d'utilisation
│       ├── login_usecase.dart
│       ├── register_usecase.dart
│       ├── attack_base_usecase.dart  # Orchestre un combat
│       └── unlock_research_usecase.dart
├── features/
│   ├── auth/                  # Fonctionnalité Auth
│   │   ├── presentation/
│   │   │   ├── providers/      # Gestion d'état (Riverpod)
│   │   │   │   ├── auth_provider.dart
│   │   │   ├── screens/
│   │   │   │   ├── login_screen.dart
│   │   │   │   └── register_screen.dart
│   │   │   └── widgets/       # Widgets spécifiques
│   │   │       ├── auth_button.dart
│   │   │       └── email_field.dart
│   │   └── data/              # Surcharge si besoin de spécificités
│   │       └── auth_repository_impl.dart
│   ├── combat/                  # Nouveau module clé
│   │   ├── presentation/
│   │   │   ├── providers/      # Gestion d'état (Riverpod)
│   │   │   │   ├── combat_provider.dart
│   │   │   │   └── combat_state.dart
│   │   │   ├── widgets/
│   │   │   │   ├── pathogen_widget.dart  # Affichage animé
│   │   │   │   └── health_bar.dart
│   │   │   └── screens/
│   │   │       └── combat_screen.dart        # UI du simulateur
│   │   └── data/
│   │       └── combat_repository_impl.dart
│   ├── research/                # Module Laboratoire R&D
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── research_remote_ds.dart # Firestore: Arbre de recherche
│   │   │   └── repositories/
│   │   │       └── research_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── tech_node_entity.dart  # Nœud de recherche
│   │   │   └── usecases/
│   │   │       ├── unlock_tech_usecase.dart
│   │   │       └── get_research_tree_usecase.dart
│   │   └── presentation/
│   │       ├── state/
│   │       │   ├── research_provider.dart
│   │       │   └── research_state.dart
│   │       ├── widgets/
│   │       │   ├── tech_node_widget.dart   # Carte interactive
│   │       │   └── research_progress.dart # Barre de progression
│   │       └── screens/
│   │           └── research_screen.dart
│   ├── viral_scanner/           # Scanner de bases ennemies
│   │   └── ...                  # Liste + détails
│   ├── bio_forge/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── bio_forge_local_ds.dart  # Hive: Configurations sauvegardées
│   │   │   │   └── bio_forge_remote_ds.dart # Firestore: Sync avec autres joueurs
│   │   │   └── repositories/
│   │   │       └── bio_forge_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── base_config_entity.dart  # Config de défense
│   │   │   └── usecases/
│   │   │       ├── save_base_config_usecase.dart
│   │   │       └── deploy_pathogens_usecase.dart
│   │   └── presentation/
│   │       ├── state/
│   │       │   ├── bio_forge_provider.dart  # Riverpod
│   │       │   └── bio_forge_state.dart
│   │       ├── widgets/
│   │       │   ├── pathogen_slot_widget.dart # Slot interactif
│   │       │   └── defense_grid_widget.dart  # Grille de placement
│   │       └── screens/
│   │           └── bio_forge_screen.dart
│   ├── war_archive/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── archive_local_ds.dart  # Hive: Cache des rapports
│   │   │   │   └── archive_remote_ds.dart # Firestore: Historique complet
│   │   │   └── repositories/
│   │   │       └── archive_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── combat_report_entity.dart
│   │   │   └── usecases/
│   │   │       ├── fetch_reports_usecase.dart
│   │   │       └── generate_chronicle_usecase.dart # Appel Gemini
│   │   └── presentation/
│   │       ├── state/
│   │       │   ├── archive_provider.dart
│   │       │   └── archive_state.dart
│   │       ├── widgets/
│   │       │   ├── report_card_widget.dart  # Carte résumé
│   │       │   └── chronicle_viewer.dart   # Affichage riche texte
│   │       └── screens/
│   │           └── archive_screen.dart
│   ├── dashboard/
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── dashboard_repository_impl.dart
│   │   └── presentation/
│   │       ├── state/
│   │       │   ├── dashboard_provider.dart # Agrège multiples providers
│   │       │   └── dashboard_state.dart
│   │       ├── widgets/
│   │       │   ├── resource_gauge.dart    # Jauge animée
│   │       │   ├── threat_level_indicator.dart
│   │       │   └── gemini_advice_widget.dart # Conseil IA
│   │       └── screens/
│   │           └── dashboard_screen.dart
│   ├── threat_scanner/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── threat_remote_ds.dart # Firestore: Bases ennemies
            │   └── threat_local_ds.dart   # Cache Hive des bases scannées
│   │   │   └── repositories/
│   │   │       └── threat_repository_impl.dart
        ├── domain/
    │   │        ├── entities/
    │   │        │     └── enemy_base_entity.dart # Détails de la base ennemie
    │   │        └── usecases/
    │   │            ├── fetch_nearby_bases.dart
    │   │            └── scan_base_usecase.dart # Interaction avec Gemini
│   │   └── presentation/
│   │       ├── state/
│   │       │   ├── threat_provider.dart
│   │       │   └── threat_state.dart
│   │       ├── widgets/
│   │       │   ├── enemy_base_card.dart
│   │       │   └── scan_animation.dart    # Effet sonar
│   │       └── screens
│   │           └── threat_scanner_screen.dart
├── shared/                   # Composants UI réutilisables
│   ├── widgets/
│   │   ├── buttons/
│   │   │   └── primary_button.dart
│   │   ├── cards/
│   │   │   └── info_card.dart
│   │   └── loaders/
│   │       └── shimmer_loader.dart
│   └── ui/
│       └── app_theme.dart
└── lib/
    └── generated_plugin_registrant.dart  # Pour Firebase



C'est une liste impressionnante d'use cases ! Elle couvre une grande partie des fonctionnalités du jeu "ImmunoWarriors" décrites dans le cahier des charges. Pour m'assurer que nous n'avons rien oublié d'essentiel, comparons-la aux exigences du TP et voyons s'il y a des ajouts potentiels.

Analyse par rapport au Cahier des Charges :

    3.1. L'Arsenal Biologique :
        create\_antibody\_usecase.dart, update\_antibody\_usecase.dart, get\_antibody\_by\_id\_usecase.dart, get\_antibodies\_by\_type\_usecase.dart, get\_all\_antibodies\_usecase.dart: Cela semble couvrir la gestion des anticorps.
        create\_base\_virale\_usecase.dart, update\_base\_virale\_usecase.dart, get\_base\_virale\_by\_id\_usecase.dart, get\_all\_base\_virales\_usecase.dart, delete\_base\_virale\_usecase.dart: Cela semble couvrir la gestion des bases virales.
        create\_pathogen\_usecase.dart, update\_pathogen\_usecase.dart, get\_pathogen\_by\_id\_usecase.dart, get\_pathogens\_by\_type\_usecase.dart, get\_all\_pathogens\_usecase.dart, delete\_pathogen\_usecase.dart, apply\_mutation\_to\_pathogen\_usecase.dart: Cela semble couvrir la gestion des agents pathogènes, y compris les mutations.
        simulate\_combat\_usecase.dart: Cela semble couvrir la simulation de combat.
    3.2. Le Centre de Commandement Immunitaire :
        get\_user\_resources\_usecase.dart, update\_user\_resources\_usecase.dart: Cela pourrait couvrir l'affichage et la gestion des Ressources Défensives.
        get\_combat\_history\_usecase.dart: Cela couvre l'historique des combats.
        generate\_combat\_chronicle\_usecase.dart, get\_combat\_tactical\_advice\_usecase.dart: Cela couvre l'intégration avec Gemini.
    3.3. Systèmes de Survie Numériques :
        sign\_in\_usecase.dart, sign\_up\_usecase.dart, sign\_out\_usecase.dart: Cela couvre l'authentification.
        get\_user\_progression\_usecase.dart, update\_user\_progression\_usecase.dart, get\_user\_achievements\_usecase.dart, update\_user\_achievements\_usecase.dart, get\_user\_settings\_usecase.dart, update\_user\_settings\_usecase.