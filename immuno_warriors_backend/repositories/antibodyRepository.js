const admin = require('firebase-admin');
const { v4: uuidv4 } = require('uuid');
const { validateAntibody, fromFirestore, toFirestore } = require('../models/antibodyModel');
const { AppError, NotFoundError } = require('../utils/errorUtils');
const  logger  = require('../utils/logger');
const { formatTimestamp } = require('../utils/dateUtils');

/**
 * Repository pour gérer les opérations CRUD des anticorps dans Firestore.
 */
class AntibodyRepository {
  constructor() {
    this.collection = admin.firestore().collection('antibodies');
    this.cacheCollection = admin.firestore().collection('antibodyCache');
  }

  /**
   * Récupère un anticorps par ID.
   * @param {string} id - ID de l'anticorps.
   * @returns {Promise<Object|null>} Anticorps ou null.
   */
  async getAntibodyById(id) {
    try {
      const doc = await this.collection.doc(id).get();
      if (!doc.exists) return null;
      return fromFirestore(doc.data());
    } catch (error) {
      logger.error('Erreur lors de la récupération de l\'anticorps', { error });
      throw new AppError(500, 'Erreur serveur lors de la récupération de l\'anticorps');
    }
  }

  /**
   * Crée un nouvel anticorps.
   * @param {Object} antibody - Données de l'anticorps.
   * @returns {Promise<void>}
   */
  async createAntibody(antibody) {
    const validation = validateAntibody(antibody);
    if (validation.error) {
      throw new AppError(400, 'Données d\'anticorps invalides', validation.error.details);
    }

    try {
      await this.collection.doc(antibody.id).set(toFirestore(antibody));
      logger.info(`Anticorps ${antibody.id} créé`);
    } catch (error) {
      logger.error('Erreur lors de la création de l\'anticorps', { error });
      throw new AppError(500, 'Erreur serveur lors de la création de l\'anticorps');
    }
  }

  /**
   * Met à jour un anticorps.
   * @param {string} id - ID de l'anticorps.
   * @param {Object} updates - Données à mettre à jour.
   * @returns {Promise<void>}
   */
  async updateAntibody(id, updates) {
    try {
      await this.collection.doc(id).update(toFirestore(updates));
      logger.info(`Anticorps ${id} mis à jour`);
    } catch (error) {
      logger.error('Erreur lors de la mise à jour de l\'anticorps', { error });
      throw new AppError(500, 'Erreur serveur lors de la mise à jour de l\'anticorps');
    }
  }

  /**
   * Récupère les anticorps par type.
   * @param {string} type - Type d'anticorps.
   * @returns {Promise<Array>} Liste des anticorps.
   */
  async getAntibodiesByType(type) {
    try {
      const snapshot = await this.collection.where('type', '==', type).get();
      return snapshot.docs.map(doc => fromFirestore(doc.data()));
    } catch (error) {
      logger.error('Erreur lors de la récupération des anticorps par type', { error });
      throw new AppError(500, 'Erreur serveur lors de la récupération des anticorps par type');
    }
  }

  /**
   * Récupère tous les anticorps.
   * @returns {Promise<Array>} Liste des anticorps.
   */
  async getAllAntibodies() {
    try {
      const snapshot = await this.collection.get();
      return snapshot.docs.map(doc => fromFirestore(doc.data()));
    } catch (error) {
      logger.error('Erreur lors de la récupération de tous les anticorps', { error });
      throw new AppError(500, 'Erreur serveur lors de la récupération de tous les anticorps');
    }
  }

  /**
   * Supprime un anticorps.
   * @param {string} id - ID de l'anticorps.
   * @returns {Promise<void>}
   */
  async deleteAntibody(id) {
    try {
      await this.collection.doc(id).delete();
      await this.cacheCollection.doc(id).delete();
      logger.info(`Anticorps ${id} supprimé`);
    } catch (error) {
      logger.error('Erreur lors de la suppression de l\'anticorps', { error });
      throw new AppError(500, 'Erreur serveur lors de la suppression de l\'anticorps');
    }
  }

  /**
   * Récupère les anticorps par type d'attaque.
   * @param {string} attackType - Type d'attaque.
   * @returns {Promise<Array>} Liste des anticorps.
   */
  async getAntibodiesByAttackType(attackType) {
    try {
      const snapshot = await this.collection.where('attackType', '==', attackType).get();
      return snapshot.docs.map(doc => fromFirestore(doc.data()));
    } catch (error) {
      logger.error('Erreur lors de la récupération des anticorps par type d\'attaque', { error });
      throw new AppError(500, 'Erreur serveur lors de la récupération des anticorps par type d\'attaque');
    }
  }

  /**
   * Crée plusieurs anticorps en lot.
   * @param {Array} antibodies - Liste des anticorps.
   * @returns {Promise<void>}
   */
  async createBatchAntibodies(antibodies) {
    try {
      const batch = admin.firestore().batch();
      antibodies.forEach(antibody => {
        const validation = validateAntibody(antibody);
        if (validation.error) {
          throw new AppError(400, `Données d'anticorps invalides pour ${antibody.id}`, validation.error.details);
        }
        const docRef = this.collection.doc(antibody.id || uuidv4());
        batch.set(docRef, toFirestore(antibody));
      });
      await batch.commit();
      logger.info(`${antibodies.length} anticorps créés en lot`);
    } catch (error) {
      logger.error('Erreur lors de la création du lot d\'anticorps', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la création du lot d\'anticorps');
    }
  }

  /**
   * Met en cache un anticorps.
   * @param {string} antibodyId - ID de l'anticorps.
   * @param {Object} antibodyData - Données de l'anticorps.
   * @returns {Promise<void>}
   */
  async cacheAntibody(antibodyId, antibodyData) {
    try {
      await this.cacheCollection.doc(antibodyId).set({
        ...toFirestore(antibodyData),
        cachedAt: formatTimestamp()
      });
      logger.info(`Anticorps ${antibodyId} mis en cache`);
    } catch (error) {
      logger.error('Erreur lors de la mise en cache de l\'anticorps', { error });
      throw new AppError(500, 'Erreur serveur lors de la mise en cache de l\'anticorps');
    }
  }

  /**
   * Récupère un anticorps en cache.
   * @param {string} antibodyId - ID de l'anticorps.
   * @returns {Promise<Object|null>} Anticorps ou null.
   */
  async getCachedAntibody(antibodyId) {
    try {
      const doc = await this.cacheCollection.doc(antibodyId).get();
      if (!doc.exists) return null;
      return fromFirestore(doc.data());
    } catch (error) {
      logger.error('Erreur lors de la récupération de l\'anticorps en cache', { error });
      throw new AppError(500, 'Erreur serveur lors de la récupération de l\'anticorps en cache');
    }
  }

  /**
   * Supprime tous les anticorps en cache.
   * @returns {Promise<void>}
   */
  async clearCachedAntibodies() {
    try {
      const snapshot = await this.cacheCollection.get();
      const batch = admin.firestore().batch();
      snapshot.docs.forEach(doc => batch.delete(doc.ref));
      await batch.commit();
      logger.info('Tous les anticorps en cache ont été supprimés');
    } catch (error) {
      logger.error('Erreur lors de la suppression des anticorps en cache', { error });
      throw new AppError(500, 'Erreur serveur lors de la suppression des anticorps en cache');
    }
  }
}

module.exports = new AntibodyRepository();
