# DiveZimut

## Application de Respiration pour Garmin Instinct 2X

DiveZimut est une application Connect IQ pour les montres Garmin (Instinct 2X, Instinct 2) qui propose des exercices de respiration guidés pour gérer le stress, améliorer la concentration et favoriser le bien-être.

## Fonctionnalités

- **4 exercices de respiration** :
  - **Carré (Box Breathing)** : 4 phases égales (inspiration, rétention, expiration, rétention)
  - **Triangle** : 3 phases (inspiration, expiration, rétention)
  - **4-7-8** : Technique de relaxation profonde
  - **Cohérence Cardiaque** : Synchronisation respiration/rythme cardiaque

- **Personnalisation** :
  - Réglage de la durée de chaque phase
  - Sélection dun exercice favori
  - Activation/désactivation des vibrations

- **Historique** : Suivi des sessions passées

- **Interface intuitive** : Navigation simple avec les boutons de la montre

## Installation

1. **Prérequis** :
   - Une montre Garmin Instinct 2 ou Instinct 2X
   - Lapplication Garmin Connect sur votre smartphone

2. **Installation** :
   - Ouvrez lapplication **Garmin Connect IQ Store** sur votre smartphone ou sur [apps.garmin.com](https://apps.garmin.com)
   - Recherchez DiveZimut
   - Installez lapplication sur votre montre

3. **Lancement** :
   - Sur votre montre, allez dans Menu > Apps > DiveZimut
   - Sélectionnez un exercice et suivez les instructions

## Développement

### Prérequis
- [Connect IQ SDK](https://developer.garmin.com/connect-iq/sdk/)
- [VS Code](https://code.visualstudio.com/) avec lextension Connect IQ
- Compte développeur Garmin

### Structure du projet
```
DiveZimut/
├── manifest.xml          # Configuration de lapplication
├── source/
│   ├── DiveZimutApp.mc   # Point dentrée
│   ├── models/
│   │   ├── Exercise.mc   # Modèle des exercices
│   │   └── UserSettings.mc # Gestion des préférences
│   └── views/
│       ├── MainMenuView.mc
│       ├── ExerciseView.mc
│       ├── SettingsView.mc
│       ├── HistoryView.mc
│       └── AboutView.mc
└── README.md
```

### Compilation et test
1. Ouvrez le projet dans VS Code
2. Configurez lémulateur Instinct 2X
3. Compilez avec Ctrl+Shift+B
4. Testez sur lémulateur ou sur votre montre

### Publication
1. Créez un compte sur [Garmin Developer Portal](https://developer.garmin.com/)
2. Soumettez votre application pour validation
3. Une fois approuvée, elle sera disponible sur le Connect IQ Store

## Roadmap

- [x] MVP avec exercices de base (Carré, Triangle)
- [x] Ajout des exercices 4-7-8 et Cohérence Cardiaque
- [x] Personnalisation des durées
- [x] Historique des sessions
- [ ] Intégration du capteur de rythme cardiaque (futur)
- [ ] Synchronisation avec Garmin Connect
- [ ] Mode Défi avec enchaînement aléatoire
- [ ] Thèmes personnalisables

## Licence

MIT License

## Contact

Pour toute question ou suggestion : charlie@wildzimut.com

---

DiveZimut - Respirez mieux, vivez mieux.