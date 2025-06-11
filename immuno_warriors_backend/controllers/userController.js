const Joi = require('joi');
const validate = require('../middleware/validationMiddleware');
const UserService = require('../services/userService');

const updateProfileSchema = Joi.object({
  username: Joi.string().min(3).max(30).optional(),
  settings: Joi.object().optional(),
});

const addResourcesSchema = Joi.object({
  credits: Joi.number().integer().min(0).optional(),
  energy: Joi.number().integer().min(0).optional(),
});

const addInventoryItemSchema = Joi.object({
  itemId: Joi.string().required(),
  type: Joi.string().required(),
  quantity: Joi.number().integer().min(1).default(1),
});

class UserController {
  async getProfile(req, res) {
    const { userId } = req.user;
    try {
      const profile = await UserService.getUserProfile(userId);
      res.status(200).json(profile);
    } catch (error) {
      throw error;
    }
  }

  async updateProfile(req, res) {
    const { userId } = req.user;
    const profile = req.body;
    try {
      await UserService.updateUserProfile(userId, profile);
      res.status(200).json({ message: 'Profil mis à jour' });
    } catch (error) {
      throw error;
    }
  }

  async addResources(req, res) {
    const { userId } = req.user;
    const resources = req.body;
    try {
      await UserService.addResources(userId, resources);
      res.status(200).json({ message: 'Ressources ajoutées' });
    } catch (error) {
      throw error;
    }
  }

  async getResources(req, res) {
    const { userId } = req.user;
    try {
      const resources = await UserService.getUserResources(userId);
      res.status(200).json(resources);
    } catch (error) {
      throw error;
    }
  }

  async addInventoryItem(req, res) {
    const { userId } = req.user;
    const item = req.body;
    try {
      await UserService.addInventoryItem(userId, item);
      res.status(200).json({ message: 'Élément ajouté à l\'inventaire' });
    } catch (error) {
      throw error;
    }
  }

  async removeInventoryItem(req, res) {
    const { userId } = req.user;
    const { itemId } = req.params;
    try {
      await UserService.removeInventoryItem(userId, { itemId });
      res.status(200).json({ message: 'Élément supprimé de l\'inventaire' });
    } catch (error) {
      throw error;
    }
  }

  async getInventory(req, res) {
    const { userId } = req.user;
    try {
      const inventory = await UserService.getUserInventory(userId);
      res.status(200).json(inventory);
    } catch (error) {
      throw error;
    }
  }

  async updateSettings(req, res) {
    const { userId } = req.user;
    const settings = req.body;
    try {
      await UserService.updateUserSettings(userId, settings);
      res.status(200).json({ message: 'Paramètres mis à jour' });
    } catch (error) {
      throw error;
    }
  }

  async getSettings(req, res) {
    const { userId } = req.user;
    try {
      const settings = await UserService.getUserSettings(userId);
      res.status(200).json(settings);
    } catch (error) {
      throw error;
    }
  }

  async deleteUser(req, res) {
    const { userId } = req.user;
    try {
      await UserService.deleteUser(userId);
      res.status(200).json({ message: 'Utilisateur supprimé' });
    } catch (error) {
      throw error;
    }
  }
}

const controller = new UserController();
module.exports = {
  getProfile: controller.getProfile.bind(controller),
  updateProfile: [validate(updateProfileSchema), controller.updateProfile.bind(controller)],
  addResources: [validate(addResourcesSchema), controller.addResources.bind(controller)],
  getResources: controller.getResources.bind(controller),
  addInventoryItem: [validate(addInventoryItemSchema), controller.addInventoryItem.bind(controller)],
  removeInventoryItem: controller.removeInventoryItem.bind(controller),
  getInventory: controller.getInventory.bind(controller),
  updateSettings: controller.updateSettings.bind(controller),
  getSettings: controller.getSettings.bind(controller),
  deleteUser: controller.deleteUser.bind(controller),
};
