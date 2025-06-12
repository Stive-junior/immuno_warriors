const express = require('express');
const cors = require('cors');
const os = require('os');
const config = require('./config');
const { db, admin } = require('./services/firebaseService');
const { logger } = require('./utils/logger');
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

// --- Vérifications de santé avec réessai ---
async function healthCheck(maxRetries = 3, delayMs = 5000) {
  let lastError = null;
  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      // Vérification des variables d'environnement
      const requiredEnvVars = ['PORT', 'JWT_SECRET', 'GEMINI_API_KEY'];
      const missingVars = requiredEnvVars.filter(varName => !process.env[varName]);
      if (missingVars.length > 0) {
        throw new Error(`Variables d'environnement manquantes : ${missingVars.join(', ')}`);
      }
      logger.info('Vérification des variables d\'environnement : OK');

      // Vérification connexion Firestore
      await db.collection('status').doc('health_check').set({
        lastChecked: admin.firestore.FieldValue.serverTimestamp(),
        status: 'healthy',
      });
      const collections = await db.listCollections();
      logger.info('Connexion Firestore : OK', {
        collections: collections.map(col => col.id),
      });

      // Vérification clé API Gemini
      if (!config.geminiApiKey) {
        throw new Error('Clé API Gemini non définie');
      }
      logger.info('Clé API Gemini : OK');

      return true;
    } catch (error) {
      lastError = error;
      logger.warn(`Échec de la vérification de santé (tentative ${attempt}/${maxRetries})`, {
        error: error.message,
      });
      if (attempt < maxRetries) {
        await new Promise(resolve => setTimeout(resolve, delayMs));
      }
    }
  }
  logger.error('Échec définitif de la vérification de santé', {
    error: lastError.message,
    stack: lastError.stack,
  });
  process.exit(1);
}

// --- Middlewares globaux ---
app.use(cors({
  origin: process.env.NODE_ENV === 'production' ? 'https://immuno-warriors.com' : '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));
app.use(express.json());
app.use(loggingMiddleware);
app.use(rateLimitMiddleware);

// --- Route d'accueil ---
app.get('/', (req, res) => {
  res.status(200).json({
    message: 'Bienvenue sur l\'API Immuno-Warriors !',
    version: '1.0.0',
    environment: process.env.NODE_ENV || 'development',
    endpoints: routes.map(({ path }) => path),
  });
});

// --- Montage des routes avec routes de base ---
const routes = [
  { path: '/api/auth', router: authRoutes, baseMessage: 'API Authentification' },
  { path: '/api/user', router: userRoutes, baseMessage: 'API Utilisateurs' },
  { path: '/api/combat', router: combatRoutes, baseMessage: 'API Combats' },
  { path: '/api/research', router: researchRoutes, baseMessage: 'API Recherche' },
  { path: '/api/gemini', router: geminiRoutes, baseMessage: 'API Gemini AI' },
  { path: '/api/base-virale', router: baseViraleRoutes, baseMessage: 'API Base Virale' },
  { path: '/api/pathogen', router: pathogenRoutes, baseMessage: 'API Pathogènes' },
  { path: '/api/antibody', router: antibodyRoutes, baseMessage: 'API Anticorps' },
  { path: '/api/notification', router: notificationRoutes, baseMessage: 'API Notifications' },
  { path: '/api/memory', router: memoryRoutes, baseMessage: 'API Mémoire Immunitaire' },
  { path: '/api/inventory', router: inventoryRoutes, baseMessage: 'API Inventaire' },
  { path: '/api/progression', router: progressionRoutes, baseMessage: 'API Progression' },
  { path: '/api/achievement', router: achievementRoutes, baseMessage: 'API Réalisations' },
  { path: '/api/threat-scanner', router: threatScannerRoutes, baseMessage: 'API Scanner de Menaces' },
  { path: '/api/leaderboard', router: leaderboardRoutes, baseMessage: 'API Classement' },
  { path: '/api/multiplayer', router: multiplayerRoutes, baseMessage: 'API Multijoueur' },
  { path: '/api/sync', router: syncRoutes, baseMessage: 'API Synchronisation' },
];

routes.forEach(({ path, router, baseMessage }) => {
  // Route de base pour chaque module
  router.get('/', (req, res) => {
    res.status(200).json({
      message: baseMessage,
      version: '1.0.0',
      environment: process.env.NODE_ENV || 'development',
    });
  });
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

// --- Route de base API ---
app.get('/api', (req, res) => {
  res.status(200).json({
    message: 'Bienvenue sur l\'API Immuno-Warriors !',
    version: '1.0.0',
    environment: process.env.NODE_ENV || 'development',
    endpoints: routes.map(({ path }) => path),
  });
});

// --- Middleware de gestion des erreurs ---
app.use(errorMiddleware);

// --- Gestion des arrêts gracieux ---
process.on('SIGTERM', async () => {
  logger.info('Signal SIGTERM reçu. Arrêt du serveur...');
  try {
    await db.collection('status').doc('api_status').update({
      last_stopped: admin.firestore.FieldValue.serverTimestamp(),
      message: 'API arrêtée',
    });
  } catch (error) {
    logger.error('Erreur lors de l\'arrêt de Firestore', { error: error.message });
  }
  process.exit(0);
});

process.on('SIGINT', async () => {
  logger.info('Signal SIGINT reçu. Arrêt du serveur...');
  try {
    await db.collection('status').doc('api_status').update({
      last_stopped: admin.firestore.FieldValue.serverTimestamp(),
      message: 'API arrêtée',
    });
  } catch (error) {
    logger.error('Erreur lors de l\'arrêt de Firestore', { error: error.message });
  }
  process.exit(0);
});

// --- Démarrage du serveur ---
async function startServer() {
  try {
    await healthCheck();
    // Obtenir l'IP locale
    const interfaces = os.networkInterfaces();
    const ip = Object.values(interfaces)
      .flat()
      .find(i => i.family === 'IPv4' && !i.internal)?.address || '0.0.0.0';

    app.listen(config.port, '0.0.0.0', () => {
      logger.info(`Serveur démarré sur le port ${config.port}`, {
        url: `http://${ip}:${config.port}/api`,
        environment: process.env.NODE_ENV || 'development',
      });

      // Mise à jour du statut Firestore
      db.collection('status').doc('api_status').set({
        last_started: admin.firestore.FieldValue.serverTimestamp(),
        message: 'API démarrée',
        port: config.port,
        environment: process.env.NODE_ENV || 'development',
        ip,
      }).catch(error => {
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
