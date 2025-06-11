const { AppError, NotFoundError } = require('../utils/errorUtils');
const logger= require('../utils/logger');
const CombatRepository = require('../repositories/combatRepository');
const UserRepository = require('../repositories/userRepository');
const BaseViraleRepository = require('../repositories/baseViraleRepository');

class CombatService {
  async startCombat(userId, combatConfig) {
    try {
      const user = await UserRepository.getCurrentUser(userId);
      if (!user) throw new NotFoundError('Utilisateur non trouvé');

      const baseId = combatConfig.baseId;
      if (baseId) {
        const isValid = await BaseViraleRepository.validateBaseForCombat(baseId);
        if (!isValid) throw new AppError(400, 'Base virale non valide pour le combat');
      }

      const combatId = await CombatRepository.startRealTimeCombat(userId, combatConfig);
      logger.info(`Combat ${combatId} démarré pour l'utilisateur ${userId}`);
      return combatId;
    } catch (error) {
      logger.error('Erreur lors du démarrage du combat', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors du démarrage du combat');
    }
  }

  async endCombat(combatId, pathogens, antibodies) {
    try {
      const combatResult = await CombatRepository.simulateCombat(pathogens, antibodies);
      const userId = combatResult.userId;
      if (userId) {
        const rewards = this._calculateRewards(combatResult.outcome);
        await UserRepository.addResources(userId, rewards);
        await UserRepository.updateUserProgression(userId, { battlesFought: (await UserRepository.getUserProgression(userId)).battlesFought + 1 });
      }
      logger.info(`Combat ${combatId} terminé avec résultat ${combatResult.outcome}`);
      return combatResult;
    } catch (error) {
      logger.error('Erreur lors de la fin du combat', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la fin du combat');
    }
  }

  async getCombatReport(combatId) {
    try {
      const report = await CombatRepository.getCachedCombatReport(combatId) || 
        (await CombatRepository.collection.doc(combatId).get()).data();
      if (!report) throw new NotFoundError('Rapport de combat non trouvé');
      logger.info(`Rapport de combat ${combatId} récupéré`);
      return report;
    } catch (error) {
      logger.error('Erreur lors de la récupération du rapport de combat', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la récupération du rapport');
    }
  }

  async getCombatHistory(userId, page = 1, limit = 10) {
    try {
      const history = await CombatRepository.getPaginatedCombatHistory(page, limit);
      logger.info(`Historique des combats récupéré pour l'utilisateur ${userId}`);
      return history;
    } catch (error) {
      logger.error('Erreur lors de la récupération de l\'historique des combats', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la récupération de l\'historique');
    }
  }

  async generateChronicle(combatId) {
    try {
      const chronicle = await CombatRepository.generateCombatChronicle(combatId);
      logger.info(`Chronique générée pour le combat ${combatId}`);
      return chronicle;
    } catch (error) {
      logger.error('Erreur lors de la génération de la chronique', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la génération de la chronique');
    }
  }

  async getTacticalAdvice(combatId) {
    try {
      const advice = await CombatRepository.getCombatTacticalAdvice(combatId);
      logger.info(`Conseils tactiques générés pour le combat ${combatId}`);
      return advice;
    } catch (error) {
      logger.error('Erreur lors de la génération des conseils tactiques', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la génération des conseils');
    }
  }

  _calculateRewards(outcome) {
    const baseRewards = { credits: 50, energy: 20 };
    if (outcome === 'AntibodiesWin') {
      return { credits: baseRewards.credits * 2, energy: baseRewards.energy * 1.5 };
    } else if (outcome === 'PathogensWin') {
      return { credits: baseRewards.credits * 0.5, energy: baseRewards.energy * 0.5 };
    }
    return baseRewards;
  }
}

module.exports = new CombatService();
