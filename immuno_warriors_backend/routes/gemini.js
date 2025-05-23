const express = require('express');
const router = express.Router();
const { generateContent } = require('../services/geminiAiService');
const { verifyToken } = require('../middleware/auth');
const { db, admin } = require('../services/firebaseService');

// Appliquer le middleware d'authentification à toutes les routes Gemini
router.use(verifyToken);

// POST /api/gemini/chat - Endpoint générique pour une interaction de chat
// Utilisez cette route pour des requêtes Gemini générales non spécifiques à un combat ou conseil.
router.post('/chat', async (req, res) => {
  const userId = req.user.uid; // L'ID utilisateur vient du token vérifié
  const { prompt } = req.body;

  if (!prompt) {
    return res.status(400).json({ message: 'Le prompt est manquant dans le corps de la requête.' });
  }

  try {
    const generatedText = await generateContent(prompt);

    const geminiResponseRef = db.collection('users').doc(userId).collection('gemini_responses').doc();
    await geminiResponseRef.set({
      prompt: prompt,
      response: generatedText,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
      type: 'general_chat'
    });

    res.status(200).json({ text: generatedText });
  } catch (error) {
    console.error('Erreur lors de la requête Gemini /chat:', error.message);
    res.status(500).json({ message: error.message || 'Échec de la requête Gemini.' });
  }
});

// POST /api/gemini/generate-combat-chronicle - Générer une chronique de combat
// C'est l'endpoint que votre GeminiService en Flutter appellera pour les chroniques.
router.post('/generate-combat-chronicle', async (req, res) => {
  const userId = req.user.uid;
  const { combatSummary } = req.body;

  if (!combatSummary) {
    return res.status(400).json({ message: 'Le résumé de combat est manquant.' });
  }

  const prompt = `${combatSummary.trim()} Agis comme un chroniqueur de guerre épique. Rédige un récit détaillé et captivant de la bataille en utilisant un style littéraire et immersif.`;

  try {
    const chronicle = await generateContent(prompt);

 
    const geminiResponseRef = db.collection('users').doc(userId).collection('gemini_responses').doc();
    await geminiResponseRef.set({
      prompt: prompt,
      response: chronicle,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
      type: 'combat_chronicle'
    });

    res.status(200).json({ text: chronicle });
  } catch (error) {
    console.error('Erreur lors de la génération de la chronique de combat:', error.message);
    res.status(500).json({ message: error.message || 'Échec de la génération de la chronique de combat.' });
  }
});

// POST /api/gemini/get-tactical-advice - Obtenir des conseils tactiques
// C'est l'endpoint que votre GeminiService en Flutter appellera pour les conseils tactiques.
router.post('/get-tactical-advice', async (req, res) => {
  const userId = req.user.uid;
  const { gameState, enemyBaseInfo } = req.body;

  if (!gameState || !enemyBaseInfo) {
    return res.status(400).json({ message: 'Les informations d\'état du jeu ou de la base ennemie sont manquantes.' });
  }

  const prompt = `${gameState.trim()} ${enemyBaseInfo.trim()} Agis comme un conseiller militaire expérimenté dans un jeu de stratégie de défense immunitaire. Fournis des conseils tactiques détaillés et exploitables.`;

  try {
    const advice = await generateContent(prompt);

    // Sauvegarder les conseils tactiques dans Firestore
    const geminiResponseRef = db.collection('users').doc(userId).collection('gemini_responses').doc();
    await geminiResponseRef.set({
      prompt: prompt,
      response: advice,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
      type: 'tactical_advice'
    });

    res.status(200).json({ text: advice });
  } catch (error) {
    console.error('Erreur lors de l\'obtention des conseils tactiques:', error.message);
    res.status(500).json({ message: error.message || 'Échec de l\'obtention des conseils tactiques.' });
  }
});

// GET /api/gemini/stored-responses - Récupérer toutes les réponses Gemini stockées pour l'utilisateur
router.get('/stored-responses', async (req, res) => {
  const userId = req.user.uid;
  try {
    const responsesSnapshot = await db.collection('users').doc(userId).collection('gemini_responses')
                                      .orderBy('timestamp', 'desc')
                                      .get();

    const responses = responsesSnapshot.docs.map(doc => {
      const data = doc.data();
      return {
        id: doc.id,
        ...data,
        // Convertir le timestamp Firestore en une date lisible si nécessaire
        timestamp: data.timestamp ? data.timestamp.toDate().toISOString() : null,
      };
    });
    res.status(200).json(responses);
  } catch (error) {
    console.error('Erreur lors de la récupération des réponses Gemini stockées:', error.message);
    res.status(500).json({ message: 'Échec de la récupération des réponses Gemini stockées.' });
  }
});

module.exports = router;
