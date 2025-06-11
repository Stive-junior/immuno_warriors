const Joi = require('joi');
const validate = require('../middleware/validationMiddleware');
const MemoryService = require('../services/memoryService');

const addMemorySignatureSchema = Joi.object({
  signature: Joi.string().required(),
  expiresAt: Joi.date().optional(),
});

class MemoryController {
  async addMemorySignature(req, res) {
    const { userId } = req.user;
    const signatureData = req.body;
    try {
      const signature = await MemoryService.addMemorySignature(userId, signatureData);
      res.status(201).json(signature);
    } catch (error) {
      throw error;
    }
  }

  async validateMemorySignature(req, res) {
    const { signatureId } = req.params;
    try {
      const isValid = await MemoryService.validateMemorySignature(signatureId);
      res.status(200).json({ isValid });
    } catch (error) {
      throw error;
    }
  }

  async clearExpiredSignatures(req, res) {
    try {
      await MemoryService.clearExpiredSignatures();
      res.status(200).json({ message: 'Signatures expirées supprimées' });
    } catch (error) {
      throw error;
    }
  }
}

const controller = new MemoryController();
module.exports = {
  addMemorySignature: [validate(addMemorySignatureSchema), controller.addMemorySignature.bind(controller)],
  validateMemorySignature: controller.validateMemorySignature.bind(controller),
  clearExpiredSignatures: controller.clearExpiredSignatures.bind(controller),
};
