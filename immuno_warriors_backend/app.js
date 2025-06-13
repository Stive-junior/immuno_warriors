const express = require('express');
const cors = require('cors');
const os = require('os');
const ngrok = require('ngrok');
const config = require('./config');
const { db, admin } = require('./services/firebaseService');
const { logger, info, error, warn } = require('./utils/logger');
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
let ngrokUrl = null;

// --- Vérifications de santé avec réessai ---
async function healthCheck(maxRetries = 3, delayMs = 5000) {
  let lastError = null;
  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      info('Début de la vérification de santé', { attempt });

      const requiredEnvVars = ['PORT', 'JWT_SECRET', 'GEMINI_API_KEY'];
      const missingVars = requiredEnvVars.filter(varName => !process.env[varName]);
      if (missingVars.length > 0) {
        throw new Error(`Variables d'environnement manquantes : ${missingVars.join(', ')}`);
      }
      info('Vérification des variables d\'environnement : OK');

      try {
        await db.collection('status').doc('health_check').set({
          lastChecked: admin.firestore.FieldValue.serverTimestamp(),
          status: 'healthy',
        });
        info('Écriture de test Firestore réussie');
      } catch (firestoreWriteError) {
        throw new Error(`Échec de l'écriture dans Firestore : ${firestoreWriteError.message}`);
      }

      try {
        const collections = await db.listCollections();
        info('Connexion Firestore : OK', {
          collections: collections.map(col => col.id),
        });
      } catch (firestoreListError) {
        throw new Error(`Échec de la liste des collections Firestore : ${firestoreListError.message}`);
      }

      if (!config.geminiApiKey) {
        throw new Error('Clé API Gemini non définie');
      }
      info('Clé API Gemini : OK');

      return true;
    } catch (err) {
      lastError = err;
      warn(`Échec de la vérification de santé (tentative ${attempt}/${maxRetries})`, {
        error: err.message,
        stack: err.stack,
      });
      if (attempt < maxRetries) {
        await new Promise(resolve => setTimeout(resolve, delayMs));
      }
    }
  }
  error('Échec définitif de la vérification de santé', {
    error: lastError.message,
    stack: lastError.stack,
  });
  throw lastError;
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

// --- Route pour récupérer l'URL ngrok ---
app.get('/api/ngrok-url', (req, res) => {
  if (ngrokUrl) {
    res.status(200).json({
      ngrokUrl,
      status: 'active',
      timestamp: new Date().toISOString(),
    });
  } else {
    res.status(503).json({
      message: 'ngrok non connecté ou serveur non démarré',
      status: 'inactive',
      timestamp: new Date().toISOString(),
    });
  }
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
  router.get('/', (req, res) => {
    res.status(200).json({
      message: baseMessage,
      version: '1.0.0',
      environment: process.env.NODE_ENV || 'development',
    });
  });
  app.use(path, router);
  info(`Route montée : ${path}`);
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
  } catch (err) {
    error('Échec de la vérification de santé', { error: err.message });
    res.status(500).json({ status: 'unhealthy', error: err.message });
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
let isShuttingDown = false;

process.on('SIGTERM', async () => {
  if (isShuttingDown) return;
  isShuttingDown = true;
  info('Signal SIGTERM reçu. Arrêt du serveur...');
  try {
    await db.collection('status').doc('api_status').update({
      last_stopped: admin.firestore.FieldValue.serverTimestamp(),
      message: 'API arrêtée',
    });
    info('Statut Firestore mis à jour pour arrêt');
    if (ngrokUrl) {
      await ngrok.disconnect();
      info('ngrok déconnecté');
    }
  } catch (err) {
    error('Erreur lors de l\'arrêt de Firestore ou ngrok', { error: err.message });
  }
  process.exit(0);
});

process.on('SIGINT', async () => {
  if (isShuttingDown) return;
  isShuttingDown = true;
  info('Signal SIGINT reçu. Arrêt du serveur...');
  try {
    await db.collection('status').doc('api_status').update({
      last_stopped: admin.firestore.FieldValue.serverTimestamp(),
      message: 'API arrêtée',
    });
    info('Statut Firestore mis à jour pour arrêt');
    if (ngrokUrl) {
      await ngrok.disconnect();
      info('ngrok déconnecté');
    }
  } catch (err) {
    error('Erreur lors de l\'arrêt de Firestore ou ngrok', { error: err.message });
  }
  process.exit(0);
});

// --- Gestion des erreurs non gérées ---
process.on('unhandledRejection', (reason, promise) => {
  error('Promesse non gérée rejetée', {
    reason: reason.message || reason,
    stack: reason.stack,
    promise,
  });
});

process.on('uncaughtException', (err) => {
  error('Exception non gérée', {
    error: err.message,
    stack: err.stack,
  });
  if (!isShuttingDown) {
    process.exit(1);
  }
});

// --- Démarrage du serveur ---
async function startServer() {
  try {
    info('Démarrage du serveur...');
    await healthCheck();
    const interfaces = os.networkInterfaces();
    const ip = Object.values(interfaces)
      .flat()
      .find(i => i.family === 'IPv4' && !i.internal)?.address || '0.0.0.0';

    const server = app.listen(config.port, '0.0.0.0', async () => {
      try {
        // Démarrer ngrok
        ngrokUrl = await ngrok.connect({
          addr: config.port,
          authtoken: process.env.NGROK_AUTH_TOKEN,
        });
        info(`Serveur démarré sur le port ${config.port}`, {
          localUrl: `http://${ip}:${config.port}/api`,
          ngrokUrl,
          environment: process.env.NODE_ENV || 'development',
        });

        // Mise à jour du statut Firestore avec l'URL ngrok
        await db.collection('status').doc('api_status').set({
          last_started: admin.firestore.FieldValue.serverTimestamp(),
          message: 'API démarrée',
          port: config.port,
          environment: process.env.NODE_ENV || 'development',
          ip,
          ngrokUrl,
        });
      } catch (ngrokError) {
        error('Erreur lors de la connexion ngrok', {
          error: ngrokError.message,
          stack: ngrokError.stack,
        });
      }
    });

    process.on('SIGTERM', () => server.close());
    process.on('SIGINT', () => server.close());
  } catch (err) {
    error('Échec du démarrage du serveur', {
      error: err.message,
      stack: err.stack,
    });
    process.exit(1);
  }
}

startServer();

module.exports = app;
