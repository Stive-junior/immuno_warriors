const Joi = require('joi');
const validate = require('../middleware/validationMiddleware');
const InventoryService = require('../services/inventoryService');

const addInventoryItemSchema = Joi.object({
  type: Joi.string().required(),
  quantity: Joi.number().integer().min(1).default(1),
});

class InventoryController {
  async addInventoryItem(req, res) {
    const { userId } = req.user;
    const itemData = req.body;
    try {
      const item = await InventoryService.addInventoryItem(userId, itemData);
      res.status(201).json(item);
    } catch (error) {
      throw error;
    }
  }

  async getInventoryItem(req, res) {
    const { itemId } = req.params;
    try {
      const item = await InventoryService.getInventoryItem(itemId);
      res.status(200).json(item);
    } catch (error) {
      throw error;
    }
  }

  async updateInventoryItem(req, res) {
    const { itemId } = req.params;
    const updates = req.body;
    try {
      await InventoryService.updateInventoryItem(itemId, updates);
      res.status(200).json({ message: 'Élément mis à jour' });
    } catch (error) {
      throw error;
    }
  }

  async deleteInventoryItem(req, res) {
    const { itemId } = req.params;
    try {
      await InventoryService.deleteInventoryItem(itemId);
      res.status(200).json({ message: 'Élément supprimé' });
    } catch (error) {
      throw error;
    }
  }
}

const controller = new InventoryController();
module.exports = {
  addInventoryItem: [validate(addInventoryItemSchema), controller.addInventoryItem.bind(controller)],
  getInventoryItem: controller.getInventoryItem.bind(controller),
  updateInventoryItem: controller.updateInventoryItem.bind(controller),
  deleteInventoryItem: controller.deleteInventoryItem.bind(controller),
};
