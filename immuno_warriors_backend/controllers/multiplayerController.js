const Joi = require('joi');
const validate = require('../middleware/validationMiddleware');
const { AppError } = require('../utils/errorUtils');
const MultiplayerService = require('../services/multiplayerService');

const createSessionSchema = Joi.object({
  maxPlayers: Joi.number().integer().min(2).max(10).optional(),
  mode: Joi.string().optional(),
});

class MultiplayerController {
  async createSession(req, res) {
    const { userId } = req.user;
    const sessionData = req.body;
    try {
      const session = await MultiplayerService.createSession(userId, sessionData);
      res.status(201).json(session);
    } catch (error) {
      throw error;
    }
  }

  async joinSession(req, res) {
    const { userId } = req.user;
    const { sessionId } = req.params;
    try {
      const session = await MultiplayerService.joinSession(sessionId, userId);
      res.status(200).json(session);
    } catch (error) {
      throw error;
    }
  }

  async getSessionStatus(req, res) {
    const { sessionId } = req.params;
    try {
      const session = await MultiplayerService.getSessionStatus(sessionId);
      res.status(200).json(session);
    } catch (error) {
      throw error;
    }
  }
}

const controller = new MultiplayerController();
module.exports = {
  createSession: [validate(createSessionSchema), controller.createSession.bind(controller)],
  joinSession: controller.joinSession.bind(controller),
  getSessionStatus: controller.getSessionStatus.bind(controller),
};
