const Joi = require('joi');
const validate = require('../middleware/validationMiddleware');
const AntibodyService = require('../services/antibodyService');

const createAntibodySchema = Joi.object({
  type: Joi.string().required(),
  attackType: Joi.string().required(),
  stats: Joi.object().required(),
});

class AntibodyController {
  async createAntibody(req, res) {
    const antibodyData = req.body;
    try {
      const antibody = await AntibodyService.createAntibody(antibodyData);
      res.status(201).json(antibody);
    } catch (error) {
      throw error;
    }
  }

  async getAntibodiesByType(req, res) {
    const { type } = req.params;
    try {
      const antibodies = await AntibodyService.getAntibodiesByType(type);
      res.status(200).json(antibodies);
    } catch (error) {
      throw error;
    }
  }

  async getAntibodiesByAttackType(req, res) {
    const { attackType } = req.params;
    try {
      const antibodies = await AntibodyService.getAntibodiesByAttackType(attackType);
      res.status(200).json(antibodies);
    } catch (error) {
      throw error;
    }
  }

  async updateAntibody(req, res) {
    const { antibodyId } = req.params;
    const updates = req.body;
    try {
      await AntibodyService.updateAntibody(antibodyId, updates);
      res.status(200).json({ message: 'Anticorps mis à jour' });
    } catch (error) {
      throw error;
    }
  }
}

const controller = new AntibodyController();
module.exports = {
  createAntibody: [validate(createAntibodySchema), controller.createAntibody.bind(controller)],
  getAntibodiesByType: controller.getAntibodiesByType.bind(controller),
  getAntibodiesByAttackType: controller.getAntibodiesByAttackType.bind(controller),
  updateAntibody: controller.updateAntibody.bind(controller),
};
