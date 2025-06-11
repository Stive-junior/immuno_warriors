const Joi = require('joi');
const validate = require('../middleware/validationMiddleware');
const GeminiService = require('../services/geminiAiService');

const chatSchema = Joi.object({
  message: Joi.string().required(),
});

class GeminiController {
  async chat(req, res) {
    const { userId } = req.user;
    const { message } = req.body;
    try {
      const response = await GeminiService.chatWithGemini(userId, message);
      res.status(200).json({ response });
    } catch (error) {
      throw error;
    }
  }

  async generateCombatChronicle(req, res) {
    const { combatId } = req.params;
    try {
      const chronicle = await GeminiService.generateCombatChronicle(combatId);
      res.status(200).json({ chronicle });
    } catch (error) {
      throw error;
    }
  }

  async getTacticalAdvice(req, res) {
    const { combatId } = req.params;
    try {
      const advice = await GeminiService.getTacticalAdvice(combatId);
      res.status(200).json({ advice });
    } catch (error) {
      throw error;
    }
  }

  async generateResearchDescription(req, res) {
    const { researchId } = req.params;
    try {
      const description = await GeminiService.generateResearchDescription(researchId);
      res.status(200).json({ description });
    } catch (error) {
      throw error;
    }
  }

  async generateBaseDescription(req, res) {
    const { baseId } = req.params;
    try {
      const description = await GeminiService.generateBaseDescription(baseId);
      res.status(200).json({ description });
    } catch (error) {
      throw error;
    }
  }

  async getStoredResponses(req, res) {
    const { userId } = req.user;
    const { type } = req.query;
    try {
      const responses = await GeminiService.getStoredResponses(userId, type);
      res.status(200).json(responses);
    } catch (error) {
      throw error;
    }
  }
}

const controller = new GeminiController();
module.exports = {
  chat: [validate(chatSchema), controller.chat.bind(controller)],
  generateCombatChronicle: controller.generateCombatChronicle.bind(controller),
  getTacticalAdvice: controller.getTacticalAdvice.bind(controller),
  generateResearchDescription: controller.generateResearchDescription.bind(controller),
  generateBaseDescription: controller.generateBaseDescription.bind(controller),
  getStoredResponses: controller.getStoredResponses.bind(controller),
};
