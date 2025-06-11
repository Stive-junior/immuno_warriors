const { v4: uuidv4 } = require('uuid');
const { AppError, NotFoundError } = require('../utils/errorUtils');
const  logger  = require('../utils/logger');
const InventoryRepository = require('../repositories/inventoryRepository');

class InventoryService {
  async addInventoryItem(userId, itemData) {
    try {
      const itemId = uuidv4();
      const item = { id: itemId, userId, ...itemData };
      await InventoryRepository.addInventoryItem(item);
      await InventoryRepository.cacheInventoryItem(itemId, item);
      logger.info(`Élément ${itemId} ajouté à l'inventaire de l'utilisateur ${userId}`);
      return item;
    } catch (error) {
      logger.error('Erreur lors de l\'ajout à l\'inventaire', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de l\'ajout à l\'inventaire');
    }
  }

  async getInventoryItem(itemId) {
    try {
      const item = await InventoryRepository.getInventoryItem(itemId);
      if (!item) throw new NotFoundError('Élément d\'inventaire non trouvé');
      logger.info(`Élément d'inventaire ${itemId} récupéré`);
      return item;
    } catch (error) {
      logger.error('Erreur lors de la récupération de l\'élément d\'inventaire', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la récupération de l\'élément');
    }
  }

  async updateInventoryItem(itemId, updates) {
    try {
      await InventoryRepository.updateInventoryItem(itemId, updates);
      const item = await InventoryRepository.getInventoryItem(itemId);
      await InventoryRepository.cacheInventoryItem(itemId, item);
      logger.info(`Élément d'inventaire ${itemId} mis à jour`);
    } catch (error) {
      logger.error('Erreur lors de la mise à jour de l\'élément d\'inventaire', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la mise à jour de l\'élément');
    }
  }

  async deleteInventoryItem(itemId) {
    try {
      await InventoryRepository.deleteInventoryItem(itemId);
      logger.info(`Élément d'inventaire ${itemId} supprimé`);
    } catch (error) {
      logger.error('Erreur lors de la suppression de l\'élément d\'inventaire', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la suppression de l\'élément');
    }
  }
}

module.exports = new InventoryService();
