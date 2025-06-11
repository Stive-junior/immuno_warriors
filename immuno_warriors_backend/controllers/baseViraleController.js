const Joi = require('joi');
const validate = require('../middleware/validationMiddleware');
const BaseViraleService = require('../services/baseViraleService');

const createBaseSchema = Joi.object({
  name: Joi.string().optional(),
  defenses: Joi.array().items(Joi.object()).optional(),
});

const addPathogenSchema = Joi.object({
  pathogenId: Joi.string().required(),
});

class BaseViraleController {
  async createBase(req, res) {
    const { userId } = req.user;
    const baseData = req.body;
    try {
      const base = await BaseViraleService.createBase(userId, baseData);
      res.status(201).json(base);
    } catch (error) {
      throw error;
    }
  }

  async updateBase(req, res) {
    const { baseId } = req.params;
    const updates = req.body;
    try {
      await BaseViraleService.updateBase(baseId, updates);
      res.status(200).json({ message: 'Base mise à jour' });
    } catch (error) {
      throw error;
    }
  }

  async addPathogen(req, res) {
    const { baseId } = req.params;
    const { pathogenId } = req.body;
    try {
      await BaseViraleService.addPathogen(baseId, pathogenId);
      res.status(200).json({ message: 'Pathogène ajouté' });
    } catch (error) {
      throw error;
    }
  }

  async levelUpBase(req, res) {
    const { baseId } = req.params;
    try {
      await BaseViraleService.levelUpBase(baseId);
      res.status(200).json({ message: 'Base améliorée' });
    } catch (error) {
      throw error;
    }
  }

  async getPlayerBases(req, res) {
    const { userId } = req.user;
    try {
      const bases = await BaseViraleService.getPlayerBases(userId);
      res.status(200).json(bases);
    } catch (error) {
      throw error;
    }
  }
}

const controller = new BaseViraleController();
module.exports = {
  createBase: [validate(createBaseSchema), controller.createBase.bind(controller)],
  updateBase: controller.updateBase.bind(controller),
  addPathogen: [validate(addPathogenSchema), controller.addPathogen.bind(controller)],
  levelUpBase: controller.levelUpBase.bind(controller),
  getPlayerBases: controller.getPlayerBases.bind(controller),
};
