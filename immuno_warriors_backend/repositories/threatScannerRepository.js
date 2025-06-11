const admin = require('firebase-admin');
const { v4: uuidv4 } = require('uuid');
const {  validateThreat, fromFirestore, toFirestore } = require('../models/threatModel');
const { AppError } = require('../utils/errorUtils');
const  logger  = require('../utils/logger');
const { formatTimestamp } = require('../utils/syncUtils');

/**
 * Repository pour gérer les opérations CRUD des menaces dans Firestore.
 */
class ThreatScannerRepository {
  constructor() {
    this.collection = admin.firestore().collection('threats');
    this.cacheCollection = admin.firestore().collection('threatCache');
  }

  /**
   * Récupère une menace par ID.
   * @param {string} id - ID de la menace.
   * @returns {Promise<Object|null>} Menace ou null.
   */
  async getThreat(id) {
    try {
      const doc = await this.collection.doc(id).get();
      if (!doc.exists) return null;
      return fromFirestore(doc.data());
    } catch (error) {
      logger.error('Erreur lors de la récupération de la menace', { error });
      throw new AppError(500, 'Erreur serveur lors de la récupération de la menace');
    }
  }

  /**
   * Ajoute une nouvelle menace.
   * @param {Object} threat - Données de la menace.
   * @returns {Promise<void>}
   */
  async addThreat(threat) {
    const validation = validateThreat(threat);
    if (validation.error) {
      throw new AppError(400, 'Données de menace invalides', validation.error.details);
    }

    try {
      await this.collection.doc(threat.id).set(toFirestore(threat));
      logger.info(`Menace ${threat.id} ajoutée`);
    } catch (error) {
      logger.error('Erreur lors de l\'ajout de la menace', { error });
      throw new AppError(500, 'Erreur serveur lors de l\'ajout de la menace');
    }
  }

  /**
   * Met en cache une menace.
   * @param {string} threatId - ID de la menace.
   * @param {Object} threatData - Données de la menace.
   * @returns {Promise<void>}
   */
  async cacheThreat(threatId, threatData) {
    try {
      await this.cacheCollection.doc(threatId).set({
        ...toFirestore(threatData),
        cachedAt: formatTimestamp()
      });
      logger.info(`Menace ${threatId} mise en cache`);
    } catch (error) {
      logger.error('Erreur lors de la mise en cache de la menace', { error });
      throw new AppError(500, 'Erreur serveur lors de la mise en cache de la menace');
    }
  }

  /**
   * Récupère une menace en cache.
   * @param {string} threatId - ID de la menace.
   * @returns {Promise<Object|null>} Menace ou null.
   */
  async getCachedThreat(threatId) {
    try {
      const doc = await this.cacheCollection.doc(threatId).get();
      if (!doc.exists) return null;
      return fromFirestore(doc.data());
    } catch (error) {
      logger.error('Erreur lors de la récupération de la menace en cache', { error });
      throw new AppError(500, 'Erreur serveur lors de la récupération de la menace en cache');
    }
  }

  /**
   * Supprime toutes les menaces en cache.
   * @returns {Promise<void>}
   */
  async clearCachedThreats() {
    try {
      const snapshot = await this.cacheCollection.get();
      const batch = admin.firestore().batch();
      snapshot.docs.forEach(doc => batch.delete(doc.ref));
      await batch.commit();
      logger.info('Toutes les menaces en cache ont été supprimées');
    } catch (error) {
      logger.error('Erreur lors de la suppression des menaces en cache', { error });
      throw new AppError(500, 'Erreur serveur lors de la suppression des menaces en cache');
    }
  }
}

module.exports = new ThreatScannerRepository();

