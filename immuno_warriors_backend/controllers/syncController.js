const Joi = require('joi');
const validate = require('../middleware/validationMiddleware');
const { AppError } = require('../utils/errorUtils');
const SyncService = require('../services/syncService');

const syncDataSchema = Joi.object({
  localData: Joi.object().required(),
  lastSyncTimestamp: Joi.date().iso().optional(),
});

class SyncController {
  async syncUserData(req, res) {
    const { userId } = req.user;
    const { localData, lastSyncTimestamp } = req.body;
    try {
      const delta = await SyncService.syncUserData(userId, localData, lastSyncTimestamp);
      res.status(200).json(delta);
    } catch (error) {
      throw error;
    }
  }

  async syncInventory(req, res) {
    const { userId } = req.user;
    const { localItems, lastSyncTimestamp } = req.body;
    try {
      const delta = await SyncService.syncInventory(userId, localItems, lastSyncTimestamp);
      res.status(200).json(delta);
    } catch (error) {
      throw error;
    }
  }

  async syncThreats(req, res) {
    const { localThreats, lastSyncTimestamp } = req.body;
    try {
      const delta = await SyncService.syncThreats(localThreats, lastSyncTimestamp);
      res.status(200).json(delta);
    } catch (error) {
      throw error;
    }
  }

  async syncMemorySignatures(req, res) {
    const { userId } = req.user;
    const { localSignatures, lastSyncTimestamp } = req.body;
    try {
      const delta = await SyncService.syncMemorySignatures(userId, localSignatures, lastSyncTimestamp);
      res.status(200).json(delta);
    } catch (error) {
      throw error;
    }
  }

  async syncMultiplayerSessions(req, res) {
    const { userId } = req.user;
    const { localSessions, lastSyncTimestamp } = req.body;
    try {
      const delta = await SyncService.syncMultiplayerSessions(userId, localSessions, lastSyncTimestamp);
      res.status(200).json(delta);
    } catch (error) {
      throw error;
    }
  }

  async syncNotifications(req, res) {
    const { userId } = req.user;
    const { localNotifications, lastSyncTimestamp } = req.body;
    try {
      const delta = await SyncService.syncNotifications(userId, localNotifications, lastSyncTimestamp);
      res.status(200).json(delta);
    } catch (error) {
      throw error;
    }
  }

  async syncPathogens(req, res) {
    const { localPathogens, lastSyncTimestamp } = req.body;
    try {
      const delta = await SyncService.syncPathogens(localPathogens, lastSyncTimestamp);
      res.status(200).json(delta);
    } catch (error) {
      throw error;
    }
  }

  async syncResearches(req, res) {
    const { userId } = req.user;
    const { localResearches, lastSyncTimestamp } = req.body;
    try {
      const delta = await SyncService.syncResearches(userId, localResearches, lastSyncTimestamp);
      res.status(200).json(delta);
    } catch (error) {
      throw error;
    }
  }
}

const controller = new SyncController();
module.exports = {
  syncUserData: [validate(syncDataSchema), controller.syncUserData.bind(controller)],
  syncInventory: controller.syncInventory.bind(controller),
  syncThreats: controller.syncThreats.bind(controller),
  syncMemorySignatures: controller.syncMemorySignatures.bind(controller),
  syncMultiplayerSessions: controller.syncMultiplayerSessions.bind(controller),
  syncNotifications: controller.syncNotifications.bind(controller),
  syncPathogens: controller.syncPathogens.bind(controller),
  syncResearches: controller.syncResearches.bind(controller),
};
