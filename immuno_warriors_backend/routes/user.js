const express = require('express');
const router = express.Router();
const { db } = require('../services/firebaseService');
const { verifyToken } = require('../middleware/auth');


router.use(verifyToken);

// GET /api/user/profile - Récupérer le profil de l'utilisateur connecté
router.get('/profile', async (req, res) => {
  try {
    const userId = req.user.uid; // L'ID utilisateur vient du token vérifié
    const userDoc = await db.collection('users').doc(userId).get();

    if (!userDoc.exists) {
      // Si le document utilisateur n'existe pas, peut-être qu'il faut le créer
      return res.status(404).json({ message: 'Profil utilisateur introuvable. Veuillez le créer si c\'est une nouvelle inscription.' });
    }

    res.status(200).json(userDoc.data());
  } catch (error) {
    console.error('Erreur lors de la récupération du profil utilisateur:', error.message);
    res.status(500).json({ message: 'Erreur interne du serveur lors de la récupération du profil.' });
  }
});

// PUT /api/user/profile
router.put('/profile', async (req, res) => {
  try {
    const userId = req.user.uid;
    const updates = req.body;

    if (Object.keys(updates).length === 0) {
      return res.status(400).json({ message: 'Aucune donnée fournie pour la mise à jour.' });
    }

    await db.collection('users').doc(userId).update(updates);
    res.status(200).json({ message: 'Profil utilisateur mis à jour avec succès.' });
  } catch (error) {
    console.error('Erreur lors de la mise à jour du profil utilisateur:', error.message);
    // Gestion spécifique des erreurs (ex: document non trouvé si l'utilisateur n'existe pas)
    if (error.code === 5 || error.code === 'not-found') { // 'not-found' pour Firestore, 5 pour GRPC
      return res.status(404).json({ message: 'Profil utilisateur introuvable pour la mise à jour.' });
    }
    res.status(500).json({ message: 'Erreur interne du serveur lors de la mise à jour du profil.' });
  }
});

// POST /api/user/resources - Mettre à jour les ressources de l'utilisateur (ex: après un combat)
router.post('/resources', async (req, res) => {
  try {
    const userId = req.user.uid;
    const { gold, dna, experience } = req.body; // Ex: { gold: 100, dna: 50, experience: 20 }

    if (gold == null && dna == null && experience == null) {
      return res.status(400).json({ message: 'Aucune ressource fournie pour la mise à jour.' });
    }

    const updates = {};
    if (gold != null) updates['resources.gold'] = admin.firestore.FieldValue.increment(gold);
    if (dna != null) updates['resources.dna'] = admin.firestore.FieldValue.increment(dna);
    if (experience != null) updates['resources.experience'] = admin.firestore.FieldValue.increment(experience);

    
    await db.collection('users').doc(userId).update(updates);
    res.status(200).json({ message: 'Ressources utilisateur mises à jour avec succès.' });
  } catch (error) {
    console.error('Erreur lors de la mise à jour des ressources:', error.message);
    res.status(500).json({ message: 'Erreur interne du serveur lors de la mise à jour des ressources.' });
  }
});

// GET /api/user/inventory
router.get('/inventory', async (req, res) => {
  try {
    const userId = req.user.uid;
    // Supposons que l'inventaire est un sous-document dans la collection 'inventory'
    const inventoryDoc = await db.collection('users').doc(userId).collection('inventory').doc('user_items').get();

    if (!inventoryDoc.exists) {
      return res.status(200).json({ items: {} }); 
    }

    res.status(200).json(inventoryDoc.data());
  } catch (error) {
    console.error('Erreur lors de la récupération de l\'inventaire:', error.message);
    res.status(500).json({ message: 'Erreur interne du serveur lors de la récupération de l\'inventaire.' });
  }
});

// POST /api/user/inventory 
router.post('/inventory', async (req, res) => {
  try {
    const userId = req.user.uid;
    const { itemsToAddOrUpdate } = req.body; // Ex: { 'item_id_1': { quantity: 5, level: 2 }, 'item_id_2': { quantity: 1 } }

    if (!itemsToAddOrUpdate || typeof itemsToAddOrUpdate !== 'object' || Object.keys(itemsToAddOrUpdate).length === 0) {
      return res.status(400).json({ message: 'Données d\'inventaire invalides ou manquantes.' });
    }

    const inventoryRef = db.collection('users').doc(userId).collection('inventory').doc('user_items');

    // Récupère l'inventaire actuel pour fusionner
    const currentInventoryDoc = await inventoryRef.get();
    const currentItems = currentInventoryDoc.exists ? currentInventoryDoc.data().items : {};

    const newItems = { ...currentItems }; // Copie l'inventaire actuel

    for (const itemId in itemsToAddOrUpdate) {
      const { quantity, level } = itemsToAddOrUpdate[itemId];
      if (newItems[itemId]) {
        // Si l'item existe, met à jour la quantité et/ou le niveau
        newItems[itemId].quantity = (newItems[itemId].quantity || 0) + (quantity || 0);
        if (level != null) { // Seulement si un niveau est spécifié
          newItems[itemId].level = level;
        }
      } else {
        // Sinon, ajoute le nouvel item
        newItems[itemId] = { quantity: quantity || 0, level: level || 1 };
      }
    }

    await inventoryRef.set({ items: newItems }); // Écrase avec le nouvel objet d'inventaire fusionné
    res.status(200).json({ message: 'Inventaire mis à jour avec succès.', inventory: newItems });
  } catch (error) {
    console.error('Erreur lors de la mise à jour de l\'inventaire:', error.message);
    res.status(500).json({ message: 'Erreur interne du serveur lors de la mise à jour de l\'inventaire.' });
  }
});


module.exports = router;
