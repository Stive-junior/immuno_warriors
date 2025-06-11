const Joi = require('joi');
const validate = require('../middleware/validationMiddleware');
const AchievementService = require('../services/achievementService');

const updateAchievementSchema = Joi.object({
  name: Joi.string().required(),
  description: Joi.string().optional(),
  progress: Joi.number().min(0).optional(),
});

class AchievementController {
  async getAchievement(req, res) {
    const { achievementId } = req.params;
    try {
      const achievement = await AchievementService.getAchievement(achievementId);
      res.status(200).json(achievement);
    } catch (error) {
      throw error;
    }
  }

  async updateAchievement(req, res) {
    const achievementData = req.body;
    try {
      const achievement = await AchievementService.updateAchievement(achievementData);
      res.status(200).json(achievement);
    } catch (error) {
      throw error;
    }
  }
}

const controller = new AchievementController();
module.exports = {
  getAchievement: controller.getAchievement.bind(controller),
  updateAchievement: [validate(updateAchievementSchema), controller.updateAchievement.bind(controller)],
};
