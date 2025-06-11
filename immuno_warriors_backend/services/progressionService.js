const { AppError, NotFoundError } = require('../utils/errorUtils');
const  logger  = require('../utils/logger');
const ProgressionRepository = require('../repositories/progressionRepository');

class ProgressionService {
  async getProgression(userId) {
    try {
      const progression = await ProgressionRepository.getProgression(userId);
      if (!progression) throw new NotFoundError('Progression non trouvée');
      logger.info(`Progression récupérée pour l'utilisateur ${userId}`);
      return progression;
    } catch (error) {
      logger.error('Erreur lors de la récupération de la progression', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la récupération de la progression');
    }
  }

  async addXP(userId, xp) {
    try {
      const progression = await ProgressionRepository.addXP(userId, xp);
      logger.info(`XP ${xp} ajouté pour l'utilisateur ${userId}`);
      return progression;
    } catch (error) {
      logger.error('Erreur lors de l\'ajout d\'XP', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de l\'ajout d\'XP');
    }
  }

  async completeMission(userId, missionId) {
    try {
      await ProgressionRepository.completeMission(userId, missionId);
      logger.info(`Mission ${missionId} complétée pour l'utilisateur ${userId}`);
    } catch (error) {
      logger.error('Erreur lors de la complétion de la mission', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la complétion de la mission');
    }
  }
}

module.exports = new ProgressionService();
