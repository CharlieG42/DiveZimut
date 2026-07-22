# DiveZimut

## 🚀 Application Connect IQ pour montres Garmin

**DiveZimut** est une application complète pour les montres Garmin (Instinct 2X, Instinct 2, Instinct 2S, Fenix 7, Epix 2, Quatix 7) qui propose des **exercices de respiration guidés** et des **tables d'apnée** pour l'entraînement.

[![Version](https://img.shields.io/badge/version-2.0.0-blue.svg)](https://github.com/CharlieG42/DiveZimut)
[![Licence](https://img.shields.io/badge/licence-MIT-green.svg)](https://github.com/CharlieG42/DiveZimut/blob/main/LICENSE)

---

## ✨ Fonctionnalités

### 🧘 Exercices de Respiration

| Exercice | Phases | Durée par défaut | Niveau | Bienfaits |
|----------|--------|------------------|--------|-----------|
| **Carré (Box Breathing)** | 4 phases égales | 4s | Débutant | Réduction du stress, amélioration de la concentration |
| **Triangle** | 3 phases | 3s | Débutant | Apaisement rapide, recentrage |
| **4-7-8** | Inspire 4s, Retien 7s, Expire 8s | Variable | Intermédiaire | Endormissement rapide, réduction de l'anxiété |
| **Cohérence Cardiaque** | Inspire 5s, Expire 5s | 5s | Intermédiaire | Équilibre du système nerveux, réduction du cortisol |

### 🏊 Tables d'Apnée

#### Tables CO2 (Tolérance au CO2)
- **CO2 Débutant**: 8 cycles à 50% du max, récupération 2:00 → 1:30
- **CO2 Intermédiaire**: 10 cycles à 60% du max, récupération 1:50 → 1:00
- **CO2 Avancé**: 12 cycles à 70% du max, récupération 1:30 → 0:45
- **CO2 Pyramide**: 7 cycles, durée progressive puis régressive

#### Tables O2 (Efficacité de l'O2)
- **O2 Débutant**: 5 cycles à 70% du max, récupération fixe 3:00
- **O2 Intermédiaire**: 6 cycles à 80% du max, récupération fixe 3:00
- **O2 Avancé**: 8 cycles à 85% du max, récupération fixe 2:30
- **O2 Progressive**: 6 cycles, durée progressive de 70% à 90%

#### Tables Mixtes
- **Mixte Équilibrée**: 8 cycles (4 CO2 + 4 O2 en alternance)
- **Mixte Avancée**: 10 cycles (5 CO2 + 5 O2 en alternance)

---

## 📱 Installation

### Méthode 1: Depuis le Garmin Connect IQ Store
1. Ouvrez l'application **Garmin Connect** sur votre téléphone
2. Allez dans **Connect IQ Store**
3. Recherchez **"DiveZimut"**
4. Installez sur votre montre

### Méthode 2: Installation manuelle (pour les développeurs)
1. Clonez ce dépôt:
   ```bash
   git clone https://github.com/CharlieG42/DiveZimut.git
   cd DiveZimut
   ```
2. Installez le [Connect IQ SDK](https://developer.garmin.com/connect-iq/sdk/)
3. Compilez et installez:
   ```bash
   make all
   monkeydo DiveZimut.prg
   ```

---

## 🎯 Utilisation

### Pour les exercices de respiration
1. Sélectionnez un exercice dans le menu **RESPIRATION**
2. Suivez les instructions à l'écran
3. Utilisez **UP/DOWN** pour mettre en pause/reprendre
4. Utilisez **BACK** pour quitter

### Pour les tables d'apnée
1. Configurez votre **temps maximal d'apnée** dans les réglages
2. Sélectionnez une table adaptée à votre niveau dans **TABLES APNEE**
3. Suivez le protocole: **Préparez-vous → Apnée → Récupérez**
4. Répétez pour le nombre de cycles prévu

### Navigation dans les menus
- **UP/DOWN**: Naviguer entre les options
- **ENTER**: Sélectionner une option
- **BACK**: Retour au menu précédent

---

## ⚙️ Réglages

| Option | Description | Valeurs possibles |
|--------|-------------|-------------------|
| Durée par défaut (respiration) | Durée de chaque phase | 1-20 secondes |
| Exercice favori | Exercice marqué d'une étoile ★ | Tous les exercices |
| Vibrations | Active/désactive les vibrations | ON/OFF |
| Son | Active/désactive les sons | ON/OFF |
| Temps max apnée | Votre temps maximal d'apnée | 30s - 10:00 |
| Tolérance CO2 | Votre niveau de tolérance au CO2 | 1-5 (Débutant à Avancé) |
| Efficacité O2 | Votre niveau d'efficacité O2 | 1-5 (Débutant à Avancé) |
| Table favorite | Table marquée d'une étoile ★ | Toutes les tables |
| Afficher timer | Affiche le temps restant | ON/OFF |
| Afficher compteur | Affiche le compteur de cycles | ON/OFF |

---

## 📊 Historique

L'application enregistre automatiquement toutes vos sessions dans l'historique. Vous pouvez:
- Voir la liste de toutes vos sessions
- Consulter les statistiques (nombre total, temps total, moyenne)
- Filtrer par type (respiration ou apnée)

---

## 🎖️ Système de Recommandations

L'application propose un système intelligent de recommandations basé sur:
- Votre **niveau** (déterminé par votre temps max d'apnée)
- Votre **tolérance CO2**
- Votre **efficacité O2**

Activez les **recommandations** dans le menu principal pour voir uniquement les exercices et tables adaptés à votre niveau.

---

## ⚠️ Sécurité

### 🔴 Règles d'Or (À RESPECTER ABSOLUMENT)

1. **TOUJOURS avec un partenaire** - même à sec, même pour les exercices de respiration
2. **JAMAIS dans l'eau sans surveillance** - risque de LOSS (Loss Of Consciousness Submerged)
3. **NE JAMAIS hyperventiler** avant une apnée - cela réduit le CO2 trop rapidement
4. **Respecter les temps de récupération** - le corps a besoin d'éliminer le CO2
5. **Arrêter immédiatement en cas de:**
   - Vertiges
   - Vision trouble ou tunnel
   - Nausées
   - Douleurs dans la poitrine
   - Sensation de malaise

### ⚠️ Précautions
- La récupération doit être au moins **2x la durée de l'apnée**
- Ne jamais réduire la récupération en dessous de **1:00**
- Écouter son corps et ses sensations
- Connaître ses limites
- Ne pas tenir plus de **30 secondes** après les premières contractions

### 🚫 Contre-indications
- Fatigue extrême
- Maladie ou fièvre
- Problèmes cardiaques
- Épilepsie
- Grossesse
- Blessures ou douleurs thoraciques

---

## 📈 Niveaux et Progression

### 🥇 Débutant
- **Temps max apnée**: < 1:30
- **Exercices recommandés**: Carré, Triangle
- **Tables recommandées**: CO2 Débutant
- **Fréquence**: 2-3x/semaine

**Objectifs:**
- Atteindre 2:00 en apnée statique
- Tenir 10 cycles de CO2 Débutant sans inconvénient
- Comprendre les sensations de contractions

### 🥈 Intermédiaire
- **Temps max apnée**: 2:00 - 3:00
- **Exercices recommandés**: Tous les exercices
- **Tables recommandées**: CO2 Intermédiaire, O2 Débutant
- **Fréquence**: 3-4x/semaine

**Objectifs:**
- Atteindre 3:00 en apnée statique
- Tenir 10 cycles de CO2 Intermédiaire
- Comprendre la différence entre CO2 et O2

### 🥉 Avancé
- **Temps max apnée**: 3:00+
- **Exercices recommandés**: Tous les exercices
- **Tables recommandées**: CO2 Avancé, O2 Avancé, Mixte
- **Fréquence**: 4-5x/semaine

**Objectifs:**
- Atteindre 4:00+ en apnée statique
- Tenir 12 cycles de CO2 Avancé
- Maîtriser les tables mixtes

---

## 📅 Planification Hebdomadaire

### Niveau Débutant
| Jour | Activité | Durée | Notes |
|------|----------|-------|-------|
| Lundi | CO2 Débutant | 15 min | À sec, avec partenaire |
| Mercredi | Respiration Carré | 10 min | Pour la récupération |
| Vendredi | CO2 Débutant | 15 min | À sec, avec partenaire |
| Dimanche | Repos | - | Étirements légers |

### Niveau Intermédiaire
| Jour | Activité | Durée | Notes |
|------|----------|-------|-------|
| Lundi | CO2 Intermédiaire | 20 min | À sec |
| Mercredi | O2 Débutant | 20 min | À sec |
| Vendredi | Mixte Équilibrée | 25 min | À sec |
| Dimanche | Repos | - | - |

### Niveau Avancé
| Jour | Activité | Durée | Notes |
|------|----------|-------|-------|
| Lundi | CO2 Avancé | 25 min | À sec |
| Mercredi | O2 Avancé | 30 min | À sec |
| Vendredi | Mixte Avancée | 30 min | À sec |
| Dimanche | Repos | - | - |

---

## 🔧 Développement

### Prérequis
- [Connect IQ SDK](https://developer.garmin.com/connect-iq/sdk/)
- Java JDK 8 ou supérieur
- Eclipse ou IDE de votre choix

### Structure du projet
```
DiveZimut/
├── source/
│   ├── DiveZimutApp.mc          # Point d'entrée de l'application
│   ├── models/
│   │   ├── Exercise.mc          # Modèle des exercices de respiration
│   │   ├── ApneaTable.mc        # Modèle des tables d'apnée
│   │   └── UserSettings.mc       # Gestion des réglages utilisateur
│   ├── utils/
│   │   ├── TimeUtils.mc         # Utilitaires de temps
│   │   └── HistoryManager.mc    # Gestion de l'historique
│   └── views/
│       ├── BaseExerciseView.mc  # Classe de base pour les vues d'exercice
│       ├── MainMenuView.mc      # Menu principal
│       ├── ExerciseView.mc      # Vue des exercices de respiration
│       ├── ApneaTableView.mc    # Vue des tables d'apnée
│       ├── SettingsView.mc      # Vue des réglages
│       ├── HistoryView.mc       # Vue de l'historique
│       └── AboutView.mc         # Vue "À propos"
├── resources/
│   └── strings/
│       └── strings.xml          # Ressources de chaînes de caractères
├── manifest.xml                 # Manifest de l'application
├── Makefile                     # Script de build
└── README.md                    # Ce fichier
```

### Compilation
```bash
# Compiler
make build

# Nettoyer
make clean

# Tout (nettoyer + compiler + packager)
make all

# Installer sur l'appareil
make install
```

### Architecture
L'application suit le pattern **MVC** (Modèle-Vue-Contrôleur):
- **Modèles**: Gèrent les données (exercices, tables, réglages)
- **Vues**: Gèrent l'affichage et l'interaction utilisateur
- **Contrôleur**: Gère la navigation entre les vues

### Bonnes pratiques
- Toujours valider les entrées utilisateur
- Gérer les erreurs de lecture/écriture des fichiers
- Libérer les ressources (timers, fichiers) dans `onStop()`
- Utiliser le système de cache pour les vues réutilisables

---

## 📚 Ressources

### Sites Web
- [Jean-Michel Gruber - Apnée](https://www.jeanmichelgruber.com/apnea-fr.html)
- [Apnea Squad](https://apneasquad.com/)
- [ION Products - Breath Holding](https://www.ion-products.com/fr/water/breathholding)

### Applications
- [Apnea Tables (iOS)](https://apps.apple.com/fr/app/tables-dapn%C3%A9e-coach-plong%C3%A9e/id1116159086)
- [Freedive Timer (Android)](https://play.google.com/store/apps/details?id=com.freedivetimer)

### Livres
- L'Entraînement en Apnée - Jean-Michel Gruber
- Free Diving: A Practical Approach - Eric Clua
- The Freediver's Guide to CO2 and O2 Tables - Ted Harty

---

## 📞 Contact

Pour toute question, suggestion ou rapport de bug:
- **Email**: charlie@wildzimut.com
- **GitHub**: [CharlieG42/DiveZimut](https://github.com/CharlieG42/DiveZimut)

---

## 📜 Licence

Ce projet est sous licence **MIT License** - voir le fichier [LICENSE](LICENSE) pour plus de détails.

---

*DiveZimut - Respirez mieux, plongez plus loin.*
