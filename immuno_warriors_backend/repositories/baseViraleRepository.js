const admin = require('firebase-admin');
const { validateBaseVirale, fromFirestore, toFirestore } = require('../models/baseViraleModel');
const { AppError, NotFoundError } = require('../utils/errorUtils');
const  logger  = require('../utils/logger');
const { formatTimestamp } = require('../utils/dateUtils');

/**
 * Repository pour gérer les opérations CRUD des bases virales dans Firestore.
 */
class BaseViraleRepository {
  constructor() {
    this.collection = admin.firestore().collection('baseVirales');
    this.cacheCollection = admin.firestore().collection('baseViraleCache');
  }

  /**
   * Récupère une base virale par ID.
   * @param {string} id - ID de la base.
   * @returns {Promise<Object|null>} Base ou null.
   */
  async getBaseViraleById(id) {
    try {
      const doc = await this.collection.doc(id).get();
      if (!doc.exists) return null;
      return fromFirestore(doc.data());
    } catch (error) {
      logger.error('Erreur lors de la récupération de la base virale', { error });
      throw new AppError(500, 'Erreur serveur lors de la récupération de la base virale');
    }
  }

  /**
   * Crée une nouvelle base virale.
   * @param {Object} baseVirale - Données de la base.
   * @returns {Promise<void>}
   */
  async createBaseVirale(baseVirale) {
    const validation = validateBaseVirale(baseVirale);
    if (validation.error) {
      throw new AppError(400, 'Données de base virale invalides', validation.error.details);
    }

    try {
      await this.collection.doc(baseVirale.id).set(toFirestore(baseVirale));
      logger.info(`Base virale ${baseVirale.id} créée`);
    } catch (error) {
      logger.error('Erreur lors de la création de la base virale', { error });
      throw new AppError(500, 'Erreur serveur lors de la création de la base virale');
    }
  }

  /**
   * Met à jour une base virale.
   * @param {string} id - ID de la base.
   * @param {Object} updates - Données à mettre à jour.
   * @returns {Promise<void>}
   */
  async updateBaseVirale(id, updates) {
    try {
      await this.collection.doc(id).update(toFirestore(updates));
      logger.info(`Base virale ${id} mise à jour`);
    } catch (error) {
      logger.error('Erreur lors de la mise à jour de la base virale', { error });
      throw new AppError(500, 'Erreur serveur lors de la mise à jour de la base virale');
    }
  }

  /**
   * Récupère les bases virales d'un joueur.
   * @param {string} playerId - ID du joueur.
   * @returns {Promise<Array>} Liste des bases.
   */
  async getBaseViralesForPlayer(playerId) {
    try {
      const snapshot = await this.collection.where('playerId', '==', playerId).get();
      return snapshot.docs.map(doc => fromFirestore(doc.data()));
    } catch (error) {
      logger.error('Erreur lors de la récupération des bases virales du joueur', { error });
      throw new AppError(500, 'Erreur serveur lors de la récupération des bases virales');
    }
  }

  /**
   * Récupère toutes les bases virales.
   * @returns {Promise<Array>} Liste des bases.
   */
  async getAllBases() {
    try {
      const snapshot = await this.collection.get();
      return snapshot.docs.map(doc => fromFirestore(doc.data()));
    } catch (error) {
      logger.error('Erreur lors de la récupération de toutes les bases', { error });
      throw new AppError(500, 'Erreur serveur lors de la récupération de toutes les bases');
    }
  }

  /**
   * Supprime une base virale.
   * @param {string} id - ID de la base.
   * @returns {Promise<void>}
   */
  async deleteBaseVirale(id) {
    try {
      await this.collection.doc(id).delete();
      await this.cacheCollection.doc(id).delete();
      logger.info(`Base virale ${id} supprimée`);
    } catch (error) {
      logger.error('Erreur lors de la suppression de la base virale', { error });
      throw new AppError(500, 'Erreur serveur lors de la suppression de la base virale');
    }
  }

  /**
   * Ajoute un pathogène à une base virale.
   * @param {string} baseId - ID de la base.
   * @param {Object} pathogen - Pathogène à ajouter.
   * @returns {Promise<void>}
   */
  async addPathogenToBase(baseId, pathogen) {
    try {
      await this.collection.doc(baseId).update({
        pathogens: admin.firestore.FieldValue.arrayUnion(pathogen)
      });
      logger.info(`Pathogène ajouté à la base virale ${baseId}`);
    } catch (error) {
      logger.error('Erreur lors de l\'ajout du pathogène', { error });
      throw new AppError(500, 'Erreur serveur lors de l\'ajout du pathogène');
    }
  }

  /**
   * Supprime un pathogène d'une base virale.
   * @param {string} baseId - ID de la base.
   * @param {Object} pathogen - Pathogène à supprimer.
   * @returns {Promise<void>}
   */
  async removePathogenFromBase(baseId, pathogen) {
    try {
      await this.collection.doc(baseId).update({
        pathogens: admin.firestore.FieldValue.arrayRemove(pathogen)
      });
      logger.info(`Pathogène supprimé de la base virale ${baseId}`);
    } catch (error) {
      logger.error('Erreur lors de la suppression du pathogène', { error });
      throw new AppError(500, 'Erreur serveur lors de la suppression du pathogène');
    }
  }

  /**
   * Met à jour les défenses d'une base virale.
   * @param {string} baseId - ID de la base.
   * @param {Array} defenses - Nouvelles défenses.
   * @returns {Promise<void>}
   */
  async updateBaseDefenses(baseId, defenses) {
    try {
      await this.collection.doc(baseId).update({ defenses });
      logger.info(`Défenses de la base virale ${baseId} mises à jour`);
    } catch (error) {
      logger.error('Erreur lors de la mise à jour des défenses', { error });
      throw new AppError(500, 'Erreur serveur lors de la mise à jour des défenses');
    }
  }

  /**
   * Améliore le niveau d'une base virale.
   * @param {string} baseId - ID de la base.
   * @returns {Promise<void>}
   */
  async levelUpBase(baseId) {
    try {
      const base = await this.getBaseViraleById(baseId);
      if (!base) throw new NotFoundError('Base virale non trouvée');

      await this.collection.doc(baseId).update({
        level: (base.level || 1) + 1,
        lastUpgraded: formatTimestamp()
      });
      logger.info(`Base virale ${baseId} améliorée au niveau ${base.level + 1}`);
    } catch (error) {
      logger.error('Erreur lors de l\'amélioration de la base', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de l\'amélioration de la base');
    }
  }

  /**
   * Valide une base virale pour un combat.
   * @param {string} baseId - ID de la base.
   * @returns {Promise<boolean>} True si valide.
   */
  async validateBaseForCombat(baseId) {
    try {
      const base = await this.getBaseViraleById(baseId);
      if (!base) throw new NotFoundError('Base virale non trouvée');

      const hasPathogens = base.pathogens && base.pathogens.length > 0;
      const hasDefenses = base.defenses && base.defenses.length > 0;
      const isValid = hasPathogens && hasDefenses && base.level >= 1;

      logger.info(`Validation de la base ${baseId} pour combat : ${isValid}`);
      return isValid;
    } catch (error) {
      logger.error('Erreur lors de la validation de la base', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la validation de la base');
    }
  }

  /**
   * Met en cache une base virale.
   * @param {string} baseId - ID de la base.
   * @param {Object} baseData - Données de la base.
   * @returns {Promise<void>}
   */
  async cacheBaseVirale(baseId, baseData) {
    try {
      await this.cacheCollection.doc(baseId).set({
        ...toFirestore(baseData),
        cachedAt: formatTimestamp()
      });
      logger.info(`Base virale ${baseId} mise en cache`);
    } catch (error) {
      logger.error('Erreur lors de la mise en cache de la base', { error });
      throw new AppError(500, 'Erreur serveur lors de la mise en cache de la base');
    }
  }

  /**
   * Récupère une base virale en cache.
   * @param {string} baseId - ID de la base.
   * @returns {Promise<Object|null>} Base ou null.
   */
  async getCachedBaseVirale(baseId) {
    try {
      const doc = await this.cacheCollection.doc(baseId).get();
      if (!doc.exists) return null;
      return fromFirestore(doc.data());
    } catch (error) {
      logger.error('Erreur lors de la récupération de la base en cache', { error });
      throw new AppError(500, 'Erreur serveur lors de la récupération de la base en cache');
    }
  }

  /**
   * Supprime toutes les bases virales en cache.
   * @returns {Promise<void>}
   */
  async clearCachedBases() {
    try {
      const snapshot = await this.cacheCollection.get();
      const batch = admin.firestore().batch();
      snapshot.docs.forEach(doc => batch.delete(doc.ref));
      await batch.commit();
      logger.info('Toutes les bases virales en cache ont été supprimées');
    } catch (error) {
      logger.error('Erreur lors de la suppression des bases en cache', { error });
      throw new AppError(500, 'Erreur serveur lors de la suppression des bases en cache');
    }
  }
}

module.exports = new BaseViraleRepository();