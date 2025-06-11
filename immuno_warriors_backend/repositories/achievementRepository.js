const admin = require('firebase-admin');
const { achievementSchema, validateAchievement, fromFirestore, toFirestore } = require('../models/achievementModel');
const { AppError, NotFoundError } = require('../utils/errorUtils');
const  logger  = require('../utils/logger');
const { formatTimestamp } = require('../utils/dateUtils');

/**
 * Repository pour gérer les opérations CRUD des succès dans Firestore.
 */
class AchievementRepository {


  constructor() {
    this.collection = admin.firestore().collection('achievements');
    this.cacheCollection = admin.firestore().collection('achievementCache');
  }

  /**
   * Récupère un succès par ID.
   * @param {string} id - ID du succès.
   * @returns {Promise<Object|null>} Succès ou null.
   */
  async getAchievement(id) {
    try {
      const doc = await this.collection.doc(id).get();
      if (!doc.exists) return null;
      return fromFirestore(doc.data());
    } catch (error) {
      logger.error('Erreur lors de la récupération du succès', { error });
      throw new AppError(500, 'Erreur serveur lors de la récupération du succès');
    }
  }

  /**
   * Met à jour un succès.
   * @param {Object} achievement - Données du succès.
   * @returns {Promise<void>}
   */
  async updateAchievement(achievement) {
    const validation = validateAchievement(achievement);
    if (validation.error) {
      throw new AppError(400, 'Données de succès invalides', validation.error.details);
    }

    try {
      await this.collection.doc(achievement.id).set(toFirestore(achievement));
      logger.info(`Succès ${achievement.id} mis à jour`);
    } catch (error) {
      logger.error('Erreur lors de la mise à jour du succès', { error });
      throw new AppError(500, 'Erreur serveur lors de la mise à jour du succès');
    }
  }

  /**
   * Met en cache un succès.
   * @param {string} achievementId - ID du succès.
   * @param {Object} achievementData - Données du succès.
   * @returns {Promise<void>}
   */
  async cacheAchievement(achievementId, achievementData) {
    try {
      await this.cacheCollection.doc(achievementId).set({
        ...toFirestore(achievementData),
        cachedAt: formatTimestamp()
      });
      logger.info(`Succès ${achievementId} mis en cache`);
    } catch (error) {
      logger.error('Erreur lors de la mise en cache du succès', { error });
      throw new AppError(500, 'Erreur serveur lors de la mise en cache du succès');
    }
  }

  /**
   * Récupère un succès en cache.
   * @param {string} achievementId - ID du succès.
   * @returns {Promise<Object|null>} Succès ou null.
   */
  async getCachedAchievement(achievementId) {
    try {
      const doc = await this.cacheCollection.doc(achievementId).get();
      if (!doc.exists) return null;
      return fromFirestore(doc.data());
    } catch (error) {
      logger.error('Erreur lors de la récupération du succès en cache', { error });
      throw new AppError(500, 'Erreur serveur lors de la récupération du succès en cache');
    }
  }

  /**
   * Supprime tous les succès en cache.
   * @returns {Promise<void>}
   */
  async clearCachedAchievements() {
    try {
      const snapshot = await this.cacheCollection.get();
      const batch = admin.firestore().batch();
      snapshot.docs.forEach(doc => batch.delete(doc.ref));
      await batch.commit();
      logger.info('Tous les succès en cache ont été supprimés');
    } catch (error) {
      logger.error('Erreur lors de la suppression des succès en cache', { error });
      throw new AppError(500, 'Erreur serveur lors de la suppression des succès en cache');
    }
  }
}

module.exports = new AchievementRepository();
