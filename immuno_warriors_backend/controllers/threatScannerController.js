const Joi = require('joi');
const validate = require('../middleware/validationMiddleware');
const { AppError } = require('../utils/errorUtils');
const ThreatScannerService = require('../services/threatScannerService');

const addThreatSchema = Joi.object({
  type: Joi.string().required(),
  severity: Joi.number().min(1).max(10).required(),
});

class ThreatScannerController {
  async addThreat(req, res) {
    const threatData = req.body;
    try {
      const threat = await ThreatScannerService.addThreat(threatData);
      res.status(201).json(threat);
    } catch (error) {
      throw error;
    }
  }

  async getThreat(req, res) {
    const { threatId } = req.params;
    try {
      const threat = await ThreatScannerService.getThreat(threatId);
      res.status(200).json(threat);
    } catch (error) {
      throw error;
    }
  }

  async scanThreat(req, res) {
    const { targetId } = req.params;
    try {
      const threat = await ThreatScannerService.scanThreat(targetId);
      res.status(200).json(threat);
    } catch (error) {
      throw error;
    }
  }
}

const controller = new ThreatScannerController();
module.exports = {
  addThreat: [validate(addThreatSchema), controller.addThreat.bind(controller)],
  getThreat: controller.getThreat.bind(controller),
  scanThreat: controller.scanThreat.bind(controller),
};
