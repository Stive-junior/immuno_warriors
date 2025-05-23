const express = require('express');
const router = express.Router();
const { auth } = require('../services/firebaseService');

// POST /api/auth/verify-token
// Permet à l'application Flutter de vérifier si un token est toujours valide
// Utile par exemple au démarrage de l'app ou lors du rafraîchissement.
router.post('/verify-token', async (req, res) => {
  const { idToken } = req.body;

  if (!idToken) {
    return res.status(400).json({ message: 'Token ID manquant dans le corps de la requête.' });
  }

  try {
    const decodedToken = await auth.verifyIdToken(idToken);
    res.status(200).json({
      message: 'Token valide.',
      uid: decodedToken.uid,
      email: decodedToken.email || null, // L'email peut être null si l'utilisateur n'en a pas
      emailVerified: decodedToken.email_verified,
    });
  } catch (error) {
    console.error('Erreur lors de la vérification du token:', error.message);
    res.status(401).json({ message: 'Token invalide ou expiré.' });
  }
});

module.exports = router;
