const Joi = require('joi');
const validate = require('../middleware/validationMiddleware');
const { AppError } = require('../utils/errorUtils');
const LeaderboardService = require('../services/leaderboardService');

const updateScoreSchema = Joi.object({
  category: Joi.string().required(),
  score: Joi.number().integer().min(0).required(),
});

class LeaderboardController {
  async updateScore(req, res) {
    const { userId } = req.user;
    const { category, score } = req.body;
    try {
      await LeaderboardService.updateScore(userId, category, score);
      res.status(200).json({ message: 'Score mis à jour' });
    } catch (error) {
      throw error;
    }
  }

  async getLeaderboard(req, res) {
    const { category } = req.params;
    const { page = 1, limit = 10 } = req.query;
    try {
      const leaderboard = await LeaderboardService.getLeaderboard(category, parseInt(page), parseInt(limit));
      res.status(200).json(leaderboard);
    } catch (error) {
      throw error;
    }
  }

  async getUserRank(req, res) {
    const { userId } = req.user;
    const { category } = req.params;
    try {
      const rank = await LeaderboardService.getUserRank(userId, category);
      res.status(200).json({ rank });
    } catch (error) {
      throw error;
    }
  }
}

const controller = new LeaderboardController();
module.exports = {
  updateScore: [validate(updateScoreSchema), controller.updateScore.bind(controller)],
  getLeaderboard: controller.getLeaderboard.bind(controller),
  getUserRank: controller.getUserRank.bind(controller),
};
