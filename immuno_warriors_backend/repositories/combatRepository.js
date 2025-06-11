const admin = require('firebase-admin');
const { v4: uuidv4 } = require('uuid');
const { combatReportSchema, validateCombatReport, fromFirestore, toFirestore } = require('../models/combatReportModel');
const { AppError, NotFoundError } = require('../utils/errorUtils');
const { logger } = require('../utils/logger');
const { formatTimestamp } = require('../utils/dateUtils');

/**
 * Repository pour gérer les opérations CRUD des combats dans Firestore.
 */
class CombatRepository {
  constructor() {
    this.collection = admin.firestore().collection('combatReports');
    this.cacheCollection = admin.firestore().collection('combatCache');
  }

  /**
   * Sauvegarde un résultat de combat.
   * @param {Object} combatResult - Résultat du combat.
   * @returns {Promise<void>}
   */
  async saveCombatResult(combatResult) {
    const validation = validateCombatReport(combatResult);
    if (validation.error) {
      throw new AppError(400, 'Données de combat invalides', validation.error.details);
    }

    try {
      await this.collection.doc(combatResult.combatId).set(toFirestore(combatResult));
      logger.info(`Rapport de combat ${combatResult.combatId} sauvegardé`);
    } catch (error) {
      logger.error('Erreur lors de la sauvegarde du combat', { error });
      throw new AppError(500, 'Erreur serveur lors de la sauvegarde du combat');
    }
  }

  /**
   * Récupère l'historique des combats avec pagination.
   * @param {number} page - Numéro de page.
   * @param {number} limit - Limite par page.
   * @returns {Promise<Array>} Liste des rapports.
   */
  async getPaginatedCombatHistory(page = 1, limit = 10) {
    try {
      const snapshot = await this.collection
        .orderBy('date', 'desc')
        .offset((page - 1) * limit)
        .limit(limit)
        .get();
      return snapshot.docs.map(doc => fromFirestore(doc.data()));
    } catch (error) {
      logger.error('Erreur lors de la récupération de l\'historique des combats', { error });
      throw new AppError(500, 'Erreur serveur lors de la récupération de l\'historique');
    }
  }

  /**
   * Simule un combat entre pathogènes et anticorps.
   * @param {Array} pathogens - Liste des pathogènes.
   * @param {Array} antibodies - Liste des anticorps.
   * @returns {Promise<Object>} Résultat du combat.
   */
  async simulateCombat(pathogens, antibodies) {
    try {
      const combatId = uuidv4();
      let pathogenHealth = pathogens.reduce((sum, p) => sum + (p.health || 100), 0);
      let antibodyHealth = antibodies.reduce((sum, a) => sum + (a.health || 100), 0);

      // Simulation simple : chaque entité attaque à tour de rôle
      const rounds = [];
      let round = 1;
      while (pathogenHealth > 0 && antibodyHealth > 0 && round <= 10) {
        // Attaque des anticorps
        const antibodyDamage = antibodies.reduce((sum, a) => sum + (a.attack || 10), 0);
        pathogenHealth = Math.max(0, pathogenHealth - antibodyDamage);

        // Attaque des pathogènes
        const pathogenDamage = pathogens.reduce((sum, p) => sum + (p.attack || 10), 0);
        antibodyHealth = Math.max(0, antibodyHealth - pathogenDamage);

        rounds.push({
          round,
          pathogenHealth,
          antibodyHealth,
          antibodyDamage,
          pathogenDamage
        });
        round++;
      }

      const outcome = pathogenHealth <= 0 ? 'AntibodiesWin' : antibodyHealth <= 0 ? 'PathogensWin' : 'Draw';
      const combatResult = {
        combatId,
        date: formatTimestamp(),
        pathogens,
        antibodies,
        rounds,
        outcome
      };

      await this.saveCombatResult(combatResult);
      logger.info(`Combat simulé : ${combatId}, résultat : ${outcome}`);
      return combatResult;
    } catch (error) {
      logger.error('Erreur lors de la simulation du combat', { error });
      throw new AppError(500, 'Erreur serveur lors de la simulation du combat');
    }
  }

  /**
   * Génère une chronique narrative du combat.
   * @param {string} combatId - ID du combat.
   * @returns {Promise<string>} Chronique narrative.
   */
  async generateCombatChronicle(combatId) {
    try {
      const combat = await this.collection.doc(combatId).get();
      if (!combat.exists) throw new NotFoundError('Combat non trouvé');

      const data = fromFirestore(combat.data());
      let chronicle = `Combat ${combatId} - ${data.date}\n`;
      chronicle += `Les pathogènes (${data.pathogens.length}) affrontent les anticorps (${data.antibodies.length}).\n`;

      data.rounds.forEach(round => {
        chronicle += `Tour ${round.round}: Les anticorps infligent ${round.antibodyDamage} dégâts, ` +
          `les pathogènes ripostent avec ${round.pathogenDamage} dégâts.\n`;
      });

      chronicle += `Résultat : ${data.outcome === 'AntibodiesWin' ? 'Victoire des anticorps !' : 
        data.outcome === 'PathogensWin' ? 'Victoire des pathogènes !' : 'Match nul.'}`;
      
      logger.info(`Chronique générée pour le combat ${combatId}`);
      return chronicle;
    } catch (error) {
      logger.error('Erreur lors de la génération de la chronique', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la génération de la chronique');
    }
  }

  /**
   * Fournit des conseils tactiques basés sur un combat.
   * @param {string} combatId - ID du combat.
   * @returns {Promise<Array>} Liste de conseils.
   */
  async getCombatTacticalAdvice(combatId) {
    try {
      const combat = await this.collection.doc(combatId).get();
      if (!combat.exists) throw new NotFoundError('Combat non trouvé');

      const data = fromFirestore(combat.data());
      const advice = [];


      const totalPathogenAttack = data.pathogens.reduce((sum, p) => sum + (p.attack || 10), 0);
      const totalAntibodyAttack = data.antibodies.reduce((sum, a) => sum + (a.attack || 10), 0);

      if (totalPathogenAttack > totalAntibodyAttack) {
        advice.push('Renforcez vos anticorps avec des unités à plus forte attaque pour contrer les pathogènes.');
      } else {
        advice.push('Vos anticorps ont une bonne attaque, concentrez-vous sur l\'amélioration de leur santé.');
      }

      if (data.rounds.length >= 10) {
        advice.push('Le combat a duré longtemps, envisagez des unités avec des capacités spéciales pour accélérer les victoires.');
      }

      logger.info(`Conseils tactiques générés pour le combat ${combatId}`);
      return advice;
    } catch (error) {
      logger.error('Erreur lors de la génération des conseils tactiques', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la génération des conseils');
    }
  }

  /**
   * Démarre un combat en temps réel (simulé ici).
   * @param {string} userId - ID de l'utilisateur.
   * @param {Object} combatConfig - Configuration du combat.
   * @returns {Promise<string>} ID du combat.
   */
  async startRealTimeCombat(userId, combatConfig) {
    try {
      const combatId = uuidv4();
      const combatData = {
        combatId,
        userId,
        date: formatTimestamp(),
        status: 'InProgress',
        config: combatConfig
      };

      await this.collection.doc(combatId).set(toFirestore(combatData));
      logger.info(`Combat en temps réel démarré : ${combatId} pour l'utilisateur ${userId}`);
      return combatId;
    } catch (error) {
      logger.error('Erreur lors du démarrage du combat en temps réel', { error });
      throw new AppError(500, 'Erreur serveur lors du démarrage du combat en temps réel');
    }
  }

  /**
   * Met en cache un rapport de combat.
   * @param {string} combatId - ID du combat.
   * @param {Object} combatData - Données du combat.
   * @returns {Promise<void>}
   */
  async cacheCombatReport(combatId, combatData) {
    try {
      await this.cacheCollection.doc(combatId).set({
        ...toFirestore(combatData),
        cachedAt: formatTimestamp()
      });
      logger.info(`Rapport de combat ${combatId} mis en cache`);
    } catch (error) {
      logger.error('Erreur lors de la mise en cache du rapport', { error });
      throw new AppError(500, 'Erreur serveur lors de la mise en cache du rapport');
    }
  }

  /**
   * Récupère un rapport de combat en cache.
   * @param {string} combatId - ID du combat.
   * @returns {Promise<Object|null>} Rapport ou null.
   */
  async getCachedCombatReport(combatId) {
    try {
      const doc = await this.cacheCollection.doc(combatId).get();
      if (!doc.exists) return null;
      return fromFirestore(doc.data());
    } catch (error) {
      logger.error('Erreur lors de la récupération du rapport en cache', { error });
      throw new AppError(500, 'Erreur serveur lors de la récupération du rapport en cache');
    }
  }

  /**
   * Supprime tous les rapports de combat en cache.
   * @returns {Promise<void>}
   */
  async clearCachedCombatReports() {
    try {
      const snapshot = await this.cacheCollection.get();
      const batch = admin.firestore().batch();
      snapshot.docs.forEach(doc => batch.delete(doc.ref));
      await batch.commit();
      logger.info('Tous les rapports de combat en cache ont été supprimés');
    } catch (error) {
      logger.error('Erreur lors de la suppression des rapports en cache', { error });
      throw new AppError(500, 'Erreur serveur lors de la suppression des rapports en cache');
    }
  }
}

module.exports = new CombatRepository();
