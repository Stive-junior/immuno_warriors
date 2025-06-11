const express = require('express');
const cors = require('cors');
const config = require('./config');
const { db, admin } = require('./services/firebaseService');
const  logger  = require('./utils/logger');
const loggingMiddleware = require('./middleware/loggingMiddleware');
const rateLimitMiddleware = require('./middleware/rateLimitMiddleware');
const errorMiddleware = require('./middleware/errorMiddleware');

// Importation des routes
const authRoutes = require('./routes/authRoutes');
const userRoutes = require('./routes/userRoutes');
const combatRoutes = require('./routes/combatRoutes');
const researchRoutes = require('./routes/researchRoutes');
const geminiRoutes = require('./routes/geminiRoutes');
const baseViraleRoutes = require('./routes/baseViraleRoutes');
const pathogenRoutes = require('./routes/pathogenRoutes');
const antibodyRoutes = require('./routes/antibodyRoutes');
const notificationRoutes = require('./routes/notificationRoutes');
const memoryRoutes = require('./routes/memoryRoutes');
const inventoryRoutes = require('./routes/inventoryRoutes');
const progressionRoutes = require('./routes/progressionRoutes');
const achievementRoutes = require('./routes/achievementRoutes');
const threatScannerRoutes = require('./routes/threatScannerRoutes');
const leaderboardRoutes = require('./routes/leaderboardRoutes');
const multiplayerRoutes = require('./routes/multiplayerRoutes');
const syncRoutes = require('./routes/syncRoutes');

const app = express();

// --- Vérifications de santé avant démarrage ---
async function healthCheck() {
  try {
    // Vérification des variables d'environnement
    const requiredEnvVars = [
      'PORT',
      'JWT_SECRET',
      'GEMINI_API_KEY',
      // 'FIREBASE_PROJECT_ID',
      // 'FIREBASE_CLIENT_EMAIL',
      // 'FIREBASE_PRIVATE_KEY',
    ];
    const missingVars = requiredEnvVars.filter((varName) => !process.env[varName]);
    if (missingVars.length > 0) {
      throw new Error(`Variables d'environnement manquantes : ${missingVars.join(', ')}`);
    }
    logger.info('Vérification des variables d\'environnement : OK');

    // Verify Firestore connection
    await db.collection('status').doc('health_check').set({
      lastChecked: admin.firestore.FieldValue.serverTimestamp(),
      status: 'healthy',
    });
    const collections = await db.listCollections();
    logger.info('Connexion Firestore : OK', {
      collections: collections.map((col) => col.id),
    });

    // Verify Gemini API key
    if (!config.geminiApiKey) {
      throw new Error('Clé API Gemini non définie');
    }
    logger.info('Clé API Gemini : OK');

    return true;
  } catch (error) {
    logger.error('Échec de la vérification de santé', {
      error: error.message,
      stack: error.stack,
    });
    process.exit(1);
  }
}

// --- Middlewares globaux ---
app.use(cors({
  origin: process.env.NODE_ENV === 'production'
    ? 'https://immuno-warriors.com'
    : '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));
app.use(express.json());
app.use(loggingMiddleware);
app.use(rateLimitMiddleware);

// --- Montage des routes ---
const routes = [
  { path: '/api/auth', router: authRoutes },
  { path: '/api/user', router: userRoutes },
  { path: '/api/combat', router: combatRoutes },
  { path: '/api/research', router: researchRoutes },
  { path: '/api/gemini', router: geminiRoutes },
  { path: '/api/base-virale', router: baseViraleRoutes },
  { path: '/api/pathogen', router: pathogenRoutes },
  { path: '/api/antibody', router: antibodyRoutes },
  { path: '/api/notification', router: notificationRoutes },
  { path: '/api/memory', router: memoryRoutes },
  { path: '/api/inventory', router: inventoryRoutes },
  { path: '/api/progression', router: progressionRoutes },
  { path: '/api/achievement', router: achievementRoutes },
  { path: '/api/threat-scanner', router: threatScannerRoutes },
  { path: '/api/leaderboard', router: leaderboardRoutes },
  { path: '/api/multiplayer', router: multiplayerRoutes },
  { path: '/api/sync', router: syncRoutes },
];

routes.forEach(({ path, router }) => {
  app.use(path, router);
  logger.info(`Route montée : ${path}`);
});

// --- Route de santé ---
app.get('/api/health', async (req, res) => {
  try {
    await db.collection('status').doc('health_check').get();
    res.status(200).json({
      status: 'healthy',
      uptime: process.uptime(),
      timestamp: new Date().toISOString(),
    });
  } catch (error) {
    logger.error('Échec de la vérification de santé', { error: error.message });
    res.status(500).json({ status: 'unhealthy', error: error.message });
  }
});

// --- Route de base ---
app.get('/api', (req, res) => {
  res.status(200).json({
    message: 'Bienvenue sur l\'API Immuno-Warriors !',
    version: '1.0.0',
    environment: process.env.NODE_ENV || 'development',
  });
});

// --- Middleware de gestion des erreurs ---
app.use(errorMiddleware);

// --- Gestion des arrêts gracieux ---
process.on('SIGTERM', async () => {
  logger.info('Signal SIGTERM reçu. Arrêt du serveur...');
  await db.collection('status').doc('api_status').update({
    last_stopped: admin.firestore.FieldValue.serverTimestamp(),
    message: 'API arrêtée',
  });
  process.exit(0);
});

process.on('SIGINT', async () => {
  logger.info('Signal SIGINT reçu. Arrêt du serveur...');
  await db.collection('status').doc('api_status').update({
    last_stopped: admin.firestore.FieldValue.serverTimestamp(),
    message: 'API arrêtée',
  });
  process.exit(0);
});

// --- Démarrage du serveur ---
async function startServer() {
  try {
    await healthCheck();
    app.listen(config.port, () => {
      logger.info(`Serveur démarré sur le port ${config.port}`, {
        url: `http://localhost:${config.port}/api`,
        environment: process.env.NODE_ENV || 'development',
      });

      // Mise à jour du statut Firestore
      db.collection('status').doc('api_status').set({
        last_started: admin.firestore.FieldValue.serverTimestamp(),
        message: 'API démarrée',
        port: config.port,
        environment: process.env.NODE_ENV || 'development',
      }).catch((error) => {
        logger.error('Erreur lors de la mise à jour du statut Firestore', {
          error: error.message,
        });
      });
    });
  } catch (error) {
    logger.error('Échec du démarrage du serveur', {
      error: error.message,
      stack: error.stack,
    });
    process.exit(1);
  }
}

startServer();

module.exports = app;

