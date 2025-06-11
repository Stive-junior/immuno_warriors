const { AppError, NotFoundError } = require('../utils/errorUtils');
const { logger } = require('../utils/logger');
const LeaderboardRepository = require('../repositories/leaderboardRepository');

class LeaderboardService {
  async updateScore(userId, category, score) {
    try {
      await LeaderboardRepository.updateScore(userId, category, score);
      logger.info(`Score ${score} mis à jour pour l'utilisateur ${userId} dans ${category}`);
    } catch (error) {
      logger.error('Erreur lors de la mise à jour du score', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la mise à jour du score');
    }
  }

  async getLeaderboard(category, page = 1, limit = 10) {
    try {
      const leaderboard = await LeaderboardRepository.getLeaderboard(category, page, limit);
      logger.info(`Classement récupéré pour la catégorie ${category}`);
      return leaderboard;
    } catch (error) {
      logger.error('Erreur lors de la récupération du classement', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la récupération du classement');
    }
  }

  async getUserRank(userId, category) {
    try {
      const rank = await LeaderboardRepository.getUserRank(userId, category);
      if (!rank) throw new NotFoundError('Rang non trouvé pour l\'utilisateur');
      logger.info(`Rang ${rank} récupéré pour l'utilisateur ${userId} dans ${category}`);
      return rank;
    } catch (error) {
      logger.error('Erreur lors de la récupération du rang', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la récupération du rang');
    }
  }
}

module.exports = new LeaderboardService();
