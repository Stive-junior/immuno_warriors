const express = require('express');
const router = express.Router();
const { db, admin } = require('../services/firebaseService');
const { verifyToken } = require('../middleware/auth');
const { generateContent } = require('../services/geminiAiService');


router.use(verifyToken);

// POST /api/combat/start - Démarrer un nouveau combat
router.post('/start', async (req, res) => {
  try {
    const userId = req.user.uid;
    const { pathogenId, userUnits, difficulty } = req.body; // Données nécessaires pour démarrer

    if (!pathogenId || !userUnits || !difficulty) {
      return res.status(400).json({ message: 'Données de combat manquantes (pathogenId, userUnits, difficulty).' });
    }

    // Récupérer les informations du pathogène depuis Firestore
    const pathogenDoc = await db.collection('pathogens').doc(pathogenId).get();
    if (!pathogenDoc.exists) {
      return res.status(404).json({ message: 'Pathogène introuvable.' });
    }
    const pathogenData = pathogenDoc.data();

    // Créer une nouvelle entrée de combat dans la collection 'combats'
    const combatRef = db.collection('combats').doc(); // Firestore génère un ID unique
    await combatRef.set({
      userId: userId,
      pathogenId: pathogenId,
      pathogenData: pathogenData,
      userUnits: userUnits,
      difficulty: difficulty,
      startTime: admin.firestore.FieldValue.serverTimestamp(), // Timestamp du début du combat
      status: 'in_progress'
    });

    res.status(200).json({
      message: 'Combat démarré avec succès.',
      combatId: combatRef.id, // Retourne l'ID du combat pour le client
      pathogen: pathogenData,
      initialUnits: userUnits,
      difficulty: difficulty
    });

  } catch (error) {
    console.error('Erreur lors du démarrage du combat:', error.message);
    res.status(500).json({ message: 'Erreur interne du serveur lors du démarrage du combat.' });
  }
});

// POST /api/combat/end - Terminer un combat et enregistrer le résultat
router.post('/end', async (req, res) => {
  try {
    const userId = req.user.uid;
    const { combatId, outcome, userHpRemaining, enemyHpRemaining, reward, summary } = req.body;

    if (!combatId || !outcome || userHpRemaining == null || enemyHpRemaining == null || !reward || !summary) {
      return res.status(400).json({ message: 'Données de fin de combat manquantes.' });
    }

    const combatRef = db.collection('combats').doc(combatId);
    const combatDoc = await combatRef.get();

    if (!combatDoc.exists || combatDoc.data().userId !== userId) {
      return res.status(404).json({ message: 'Combat introuvable ou non autorisé pour cet utilisateur.' });
    }

    // Mettre à jour l'état du combat dans la base de données
    await combatRef.update({
      outcome: outcome,
      userHpRemaining: userHpRemaining,
      enemyHpRemaining: enemyHpRemaining,
      reward: reward,
      summary: summary,
      endTime: admin.firestore.FieldValue.serverTimestamp(),
      status: 'completed'
    });

    // Mettre à jour les ressources de l'utilisateur si le combat est une victoire
    if (outcome === 'win') {
      const userRef = db.collection('users').doc(userId);
      await userRef.update({
        'resources.gold': admin.firestore.FieldValue.increment(reward.gold || 0),
        'resources.dna': admin.firestore.FieldValue.increment(reward.dna || 0),
        'resources.experience': admin.firestore.FieldValue.increment(reward.experience || 0),
    
      });
    }

    // Générer la chronique de combat avec Gemini
    let chronicle = null;
    try {
      const geminiPrompt = `${summary.trim()} Agis comme un chroniqueur de guerre épique. Rédige un récit détaillé et captivant de la bataille en utilisant un style littéraire et immersif.`;
      chronicle = await generateContent(geminiPrompt);
      await combatRef.update({ chronicle: chronicle }); // Sauvegarder la chronique générée
    } catch (geminiError) {
      console.error('Erreur lors de la génération de la chronique Gemini:', geminiError.message);
      // Ne pas bloquer la fin du combat si la génération Gemini échoue
    }

    res.status(200).json({
      message: 'Combat terminé avec succès.',
      outcome: outcome,
      reward: reward,
      chronicle: chronicle // Retourne la chronique générée à l'application
    });

  } catch (error) {
    console.error('Erreur lors de la fin du combat:', error.message);
    res.status(500).json({ message: 'Erreur interne du serveur lors de la fin du combat.' });
  }
});

// GET /api/combat/report/:combatId - Récupérer le rapport détaillé d'un combat
router.get('/report/:combatId', async (req, res) => {
  try {
    const userId = req.user.uid;
    const combatId = req.params.combatId;

    const combatDoc = await db.collection('combats').doc(combatId).get();

    if (!combatDoc.exists || combatDoc.data().userId !== userId) {
      return res.status(404).json({ message: 'Rapport de combat introuvable ou non autorisé.' });
    }

    res.status(200).json(combatDoc.data());
  } catch (error) {
    console.error('Erreur lors de la récupération du rapport de combat:', error.message);
    res.status(500).json({ message: 'Erreur interne du serveur lors de la récupération du rapport.' });
  }
});

module.exports = router;
