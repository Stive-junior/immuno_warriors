const express = require('express');
const cors = require('cors'); // Pour gérer les requêtes Cross-Origin (nécessaire en dev)
const config = require('./config'); // Charge la configuration (port, clés API)
const { db } = require('./services/firebaseService'); // S'assure que Firebase Admin SDK est initialisé

// Importation des routes
const authRoutes = require('./routes/auth');
const userRoutes = require('./routes/user');
const combatRoutes = require('./routes/combat');
const geminiRoutes = require('./routes/gemini');

const app = express();

// --- Middlewares globaux ---
// Active CORS pour toutes les requêtes (important en développement pour permettre à Flutter de se connecter)
// En production, vous voudrez peut-être restreindre les origines (ex: cors({ origin: 'https://immuno-warriors.com' }))
app.use(cors());
// Parse les corps de requête JSON (pour recevoir les données envoyées par Flutter)
app.use(express.json());

// --- Routes API ---
// Chaque ligne associe un chemin de base à un ensemble de routes
app.use('/api/auth', authRoutes);
app.use('/api/user', userRoutes);
app.use('/api/combat', combatRoutes);
app.use('/api/gemini', geminiRoutes); // Route pour toutes les interactions Gemini

// Route de base pour tester que le serveur est accessible
app.get('/api', (req, res) => {
  res.status(200).json({ message: 'Bienvenue sur l\'API Immuno-Warriors ! Le serveur est opérationnel.' });
});


app.use((err, req, res, next) => {
  console.error('Erreur non gérée:', err.stack);
  res.status(500).send('Quelque chose s\'est mal passé sur le serveur !');
});


const PORT = config.port;
app.listen(PORT, () => {
  console.log(`Serveur démarré sur le port ${PORT}`);
  console.log(`URL de base de l'API : http://localhost:${PORT}/api`);


  db.collection('status').doc('api_status').set({ last_started: new Date(), message: 'API démarrée' })
    .then(() => console.log('Firestore: Connexion OK et statut mis à jour.'))
    .catch(err => console.error('Firestore: ERREUR lors de la vérification de connexion:', err.message));

    db.listCollections().then(collections => {
        console.log('Firestore: Collections existantes:', collections.map(col => col.id));
    }).catch(error => {
        console.error('Firestore: Erreur lors de la liste des collections:', error.message);
    });

});
