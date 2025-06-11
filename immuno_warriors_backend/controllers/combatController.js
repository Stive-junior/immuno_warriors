const Joi = require('joi');
const validate = require('../middleware/validationMiddleware');
const { AppError } = require('../utils/errorUtils');
const CombatService = require('../services/combatService');

const startCombatSchema = Joi.object({
  baseId: Joi.string().optional(),
  pathogens: Joi.array().items(Joi.object()).optional(),
  antibodies: Joi.array().items(Joi.object()).optional(),
});

class CombatController {
  async startCombat(req, res) {
    const { userId } = req.user;
    const combatConfig = req.body;
    try {
      const combatId = await CombatService.startCombat(userId, combatConfig);
      res.status(201).json({ combatId });
    } catch (error) {
      throw error;
    }
  }

  async endCombat(req, res) {
    const { combatId } = req.params;
    const { pathogens, antibodies } = req.body;
    try {
      const result = await CombatService.endCombat(combatId, pathogens, antibodies);
      res.status(200).json(result);
    } catch (error) {
      throw error;
    }
  }

  async getCombatReport(req, res) {
    const { combatId } = req.params;
    try {
      const report = await CombatService.getCombatReport(combatId);
      res.status(200).json(report);
    } catch (error) {
      throw error;
    }
  }

  async getCombatHistory(req, res) {
    const { userId } = req.user;
    const { page = 1, limit = 10 } = req.query;
    try {
      const history = await CombatService.getCombatHistory(userId, parseInt(page), parseInt(limit));
      res.status(200).json(history);
    } catch (error) {
      throw error;
    }
  }

  async generateChronicle(req, res) {
    const { combatId } = req.params;
    try {
      const chronicle = await CombatService.generateChronicle(combatId);
      res.status(200).json({ chronicle });
    } catch (error) {
      throw error;
    }
  }

  async getTacticalAdvice(req, res) {
    const { combatId } = req.params;
    try {
      const advice = await CombatService.getTacticalAdvice(combatId);
      res.status(200).json({ advice });
    } catch (error) {
      throw error;
    }
  }
}

const controller = new CombatController();
module.exports = {
  startCombat: [validate(startCombatSchema), controller.startCombat.bind(controller)],
  endCombat: controller.endCombat.bind(controller),
  getCombatReport: controller.getCombatReport.bind(controller),
  getCombatHistory: controller.getCombatHistory.bind(controller),
  generateChronicle: controller.generateChronicle.bind(controller),
  getTacticalAdvice: controller.getTacticalAdvice.bind(controller),
};
