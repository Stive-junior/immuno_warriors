const Joi = require('joi');
const validate = require('../middleware/validationMiddleware');
const ProgressionService = require('../services/progressionService');

const addXPSchema = Joi.object({
  xp: Joi.number().integer().min(0).required(),
});

class ProgressionController {
  async getProgression(req, res) {
    const { userId } = req.user;
    try {
      const progression = await ProgressionService.getProgression(userId);
      res.status(200).json(progression);
    } catch (error) {
      throw error;
    }
  }

  async addXP(req, res) {
    const { userId } = req.user;
    const { xp } = req.body;
    try {
      const progression = await ProgressionService.addXP(userId, xp);
      res.status(200).json(progression);
    } catch (error) {
      throw error;
    }
  }

  async completeMission(req, res) {
    const { userId } = req.user;
    const { missionId } = req.params;
    try {
      await ProgressionService.completeMission(userId, missionId);
      res.status(200).json({ message: 'Mission complétée' });
    } catch (error) {
      throw error;
    }
  }
}

const controller = new ProgressionController();
module.exports = {
  getProgression: controller.getProgression.bind(controller),
  addXP: [validate(addXPSchema), controller.addXP.bind(controller)],
  completeMission: controller.completeMission.bind(controller),
};
