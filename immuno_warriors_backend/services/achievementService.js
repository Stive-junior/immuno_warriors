const { v4: uuidv4 } = require('uuid');
const { AppError, NotFoundError } = require('../utils/errorUtils');
const { logger } = require('../utils/logger');
const AchievementRepository = require('../repositories/achievementRepository');

class AchievementService {
  async getAchievement(achievementId) {
    try {
      const achievement = await AchievementRepository.getAchievement(achievementId);
      if (!achievement) throw new NotFoundError('Succès non trouvé');
      logger.info(`Succès ${achievementId} récupéré`);
      return achievement;
    } catch (error) {
      logger.error('Erreur lors de la récupération du succès', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la récupération du succès');
    }
  }

  async updateAchievement(achievementData) {
    try {
      const achievementId = achievementData.id || uuidv4();
      const achievement = { id: achievementId, ...achievementData };
      await AchievementRepository.updateAchievement(achievement);
      await AchievementRepository.cacheAchievement(achievementId, achievement);
      logger.info(`Succès ${achievementId} mis à jour`);
      return achievement;
    } catch (error) {
      logger.error('Erreur lors de la mise à jour du succès', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la mise à jour du succès');
    }
  }
}

module.exports = new AchievementService();
