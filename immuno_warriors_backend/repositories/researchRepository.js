const admin = require('firebase-admin');
const {  validateResearch, fromFirestore, toFirestore } = require('../models/researchModel');
const { AppError, NotFoundError } = require('../utils/errorUtils');
const logger  = require('../utils/logger');
const { formatTimestamp } = require('../utils/syncUtils');

/**
 * Repository pour gérer les recherches dans le domaine de la recherche dans Firestore.
 */
class ResearchRepository {
  constructor() {
    this.collection = admin.firestore().collection('researches');
    this.cacheCollection = admin.firestore().collection('researchCache');
  }

  /**
   * Récupère tous les éléments de recherche.
   */
  async getAllResearchItems() {
    try {
      const snapshot = await this.collection.get();
      return snapshot.docs.map(doc => fromFirestore(doc.data()));
    } catch (e) {
      logger.error('Erreur dans la récupération des recherches', { e });
      throw error(new AppError('Erreur dans le serveur lors de la récupération des recherches'));
    }
  }

  /**
   * Récupère un élément de recherche par ID.
   */
  async getResearchItem(id) {
    try {
      await this.collection.doc(id).get();
      if (!doc.exists) return null;
      return fromFirestore(doc.data());
    } catch (e) {
      logger.error('Erreur dans la récupération de la recherche', { e });
      throw error(new AppError('Erreur dans le serveur lors de la récupération de la recherche'));
    }
  }

  /**
   * Déverrouille un élément de recherche.
   */
  async unlockResearchItem(id) {
    try {
      await this.collection.doc(id).update({ isUnlocked: true });
      logger.info(`Recherche ${id} déverrouillé`);
    } catch (e) {
      logger.error('Erreur dans le déverrouillage de la recherche', { e });
      throw error(`Erreur dans le serveur lors du déverrouillage de la recherche`);
    }
  }

  /**
   * Crée un nouvel élément de recherche.
   */
  async createResearchItem(researchItemData) {
    const validation = validateResearchItem(researchItemData);
    if (validation.error) {
      throw new NotFoundError(400, 'Données de recherche dans le domaine de la recherche invalides', validation.error.details);
    }

    try {
      await this.collection.doc(researchItemData.id).set(toFirestore(researchItemData));
      logger.info(`Données de recherche ${researchItemData.id} crées`);
      return researchItemData;
    } catch (e) {
      logger.error('Erreur dans la création de la recherche', { e });
      throw new AppError(500, 'Erreur dans le serveur lors de la création de la recherche');
    }
  }

  /**
   * Met à jour un élément de recherche.
   * @param {string} id - ID de la recherche.
   * @param {Object} updates - Données à mettre à jour.
   * @returns {Promise<void>}
   */
  async updateResearchItem(id, updates) {
    const validation = validateResearch(updates);
    if (validation.error) {
      throw new AppError(400, 'Données de recherche invalides', validation.error.details);
    }

    try {
      await this.collection.doc(id).update(toFirestore(updates));
      logger.info(`Recherche ${id} mise à jour`);
    } catch (error) {
      logger.error('Erreur lors de la mise à jour de la recherche', { error });
      throw new AppError(500, 'Erreur serveur lors de la mise à jour de la recherche');
    }
  }

  /**
   * Supprime un élément de recherche.
   * @param {string} id - ID de la recherche.
   * @returns {Promise<void>}
   */
  async deleteResearchItem(id) {
    try {
      await this.collection.doc(id).delete();
      await this.cacheCollection.doc(id).delete();
      logger.info(`Recherche ${id} supprimée`);
    } catch (error) {
      logger.error('Erreur lors de la suppression de la recherche', { error });
      throw new AppError(500, 'Erreur serveur lors de la suppression de la recherche');
    }
  }

  /**
   * Récupère la progression de la recherche pour un utilisateur.
   * @param {string} userId - ID de l'utilisateur.
   * @returns {Promise<Object>} Progression de la recherche.
   */
  async getResearchProgression(userId) {
    try {
      const snapshot = await this.collection.where('userId', '==', userId).get();
      const progress = {};
      snapshot.forEach(doc => {
        const data = fromFirestore(doc.data());
        progress[data.id] = data.progression || { progress: 0, completed: false };
      });
      logger.info(`Progression de la recherche récupérée pour l'utilisateur ${userId}`);
      return progress;
    } catch (error) {
      logger.error('Erreur lors de la récupération de la progression de la recherche', { error });
      throw new AppError(500, 'Erreur serveur lors de la récupération de la progression de la recherche');
    }
  }

  /**
   * Sauvegarde la progression de la recherche.
   * @param {string} userId - ID de l'utilisateur.
   * @param {string} researchId - ID de la recherche.
   * @param {Object} progress - Données de progression.
   * @returns {Promise<void>}
   */
  async saveResearchProgression(userId, researchId, progress) {
    try {
      await this.collection.doc(researchId).update({
        userId,
        progression: toFirestore(progress),
        updatedAt: formatTimestamp()
      });
      logger.info(`Progression de la recherche ${researchId} sauvegardée pour l'utilisateur ${userId}`);
    } catch (error) {
      logger.error('Erreur lors de la sauvegarde de la progression de la recherche', { error });
      throw new AppError(500, 'Erreur serveur lors de la sauvegarde de la progression de la recherche');
    }
  }

  /**
   * Déverrouille plusieurs éléments de recherche en lot.
   * @param {Array} researchIds - Liste des IDs de recherche.
   * @returns {Promise<void>}
   */
  async unlockBatchResearchItems(researchIds) {
    try {
      const batch = admin.firestore().batch();
      researchIds.forEach(id => {
        const docRef = this.collection.doc(id);
        batch.update(docRef, { isUnlocked: true });
      });
      await batch.commit();
      logger.info(`${researchIds.length} recherches déverrouillées en lot`);
    } catch (error) {
      logger.error('Erreur lors du déverrouillage du lot de recherches', { error });
      throw new AppError(500, 'Erreur serveur lors du déverrouillage du lot de recherches');
    }
  }

  /**
   * Met en cache un élément de recherche.
   * @param {string} researchId - ID de la recherche.
   * @param {Object} researchData - Données de la recherche.
   * @returns {Promise<void>}
   */
  async cacheResearchItem(researchId, researchData) {
    try {
      await this.cacheCollection.doc(researchId).set({
        ...toFirestore(researchData),
        cachedAt: formatTimestamp()
      });
      logger.info(`Recherche ${researchId} mise en cache`);
    } catch (error) {
      logger.error('Erreur lors de la mise en cache de la recherche', { error });
      throw new AppError(500, 'Erreur serveur lors de la mise en cache de la recherche');
    }
  }

  /**
   * Récupère un élément de recherche en cache.
   * @param {string} researchId - ID de la recherche.
   * @returns {Promise<Object|null>} Recherche ou null.
   */
  async getCachedResearchItem(researchId) {
    try {
      const doc = await this.cacheCollection.doc(researchId).get();
      if (!doc.exists) return null;
      return fromFirestore(doc.data());
    } catch (error) {
      logger.error('Erreur lors de la récupération de la recherche en cache', { error });
      throw new AppError(500, 'Erreur serveur lors de la récupération de la recherche en cache');
    }
  }

  /**
   * Supprime tous les éléments de recherche en cache.
   * @returns {Promise<void>}
   */
  async clearCachedResearchItems() {
    try {
      const snapshot = await this.cacheCollection.get();
      const batch = admin.firestore().batch();
      snapshot.docs.forEach(doc => batch.delete(doc.ref));
      await batch.commit();
      logger.info('Tous les éléments de recherche en cache ont été supprimés');
    } catch (error) {
      logger.error('Erreur lors de la suppression des recherches en cache', { error });
      throw new AppError(500, 'Erreur serveur lors de la suppression des recherches en cache');
    }
  }
}

module.exports = new ResearchRepository();
