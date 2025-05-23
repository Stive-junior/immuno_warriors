const admin = require('firebase-admin');
const config = require('../config');
const path = require('path');

let serviceAccount;

try {
  // Construit le chemin absolu vers le fichier de clé de compte de service
  // '..' remonte d'un dossier depuis 'services', puis combine avec le chemin du .env
  const serviceAccountPath = path.resolve(__dirname, '..', config.firebaseServiceAccountPath);
  serviceAccount = require(serviceAccountPath);
} catch (error) {
  console.error('ERREUR: Le fichier de clé de compte de service Firebase n\'a pas pu être chargé.');
  console.error('Veuillez vérifier que FIREBASE_SERVICE_ACCOUNT_PATH est correctement configuré dans votre .env et que le fichier existe.');
  console.error('Détails de l\'erreur:', error.message);
  process.exit(1); // Arrête le processus si la clé n'est pas trouvée, car l'API ne peut pas fonctionner sans.
}

// Initialise l'application Firebase Admin si ce n'est pas déjà fait
if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
  });
  console.log('Firebase Admin SDK initialisé avec succès.');


}

// Exporte les instances de Firestore et d'Auth
const db = admin.firestore();
const auth = admin.auth();

module.exports = { db, auth, admin };
