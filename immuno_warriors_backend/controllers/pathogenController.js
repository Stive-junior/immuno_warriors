const Joi = require('joi');
const validate = require('../middleware/validationMiddleware');
const PathogenService = require('../services/pathogenService');

const createPathogenSchema = Joi.object({
  type: Joi.string().required(),
  rarity: Joi.string().optional(),
  stats: Joi.object().required(),
});

class PathogenController {
  async createPathogen(req, res) {
    const pathogenData = req.body;
    try {
      const pathogen = await PathogenService.createPathogen(pathogenData);
      res.status(201).json(pathogen);
    } catch (error) {
      throw error;
    }
  }

  async getPathogensByType(req, res) {
    const { type } = req.params;
    try {
      const pathogens = await PathogenService.getPathogensByType(type);
      res.status(200).json(pathogens);
    } catch (error) {
      throw error;
    }
  }

  async getPathogensByRarity(req, res) {
    const { rarity } = req.params;
    try {
      const pathogens = await PathogenService.getPathogensByRarity(rarity);
      res.status(200).json(pathogens);
    } catch (error) {
      throw error;
    }
  }

  async updatePathogenStats(req, res) {
    const { pathogenId } = req.params;
    const stats = req.body;
    try {
      await PathogenService.updatePathogenStats(pathogenId, stats);
      res.status(200).json({ message: 'Statistiques mises à jour' });
    } catch (error) {
      throw error;
    }
  }
}

const controller = new PathogenController();
module.exports = {
  createPathogen: [validate(createPathogenSchema), controller.createPathogen.bind(controller)],
  getPathogensByType: controller.getPathogensByType.bind(controller),
  getPathogensByRarity: controller.getPathogensByRarity.bind(controller),
  updatePathogenStats: controller.updatePathogenStats.bind(controller),
};
