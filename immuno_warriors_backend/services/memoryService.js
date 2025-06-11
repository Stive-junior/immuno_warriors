const { v4: uuidv4 } = require('uuid');
const { AppError } = require('../utils/errorUtils');
const  logger  = require('../utils/logger');
const MemoryRepository = require('../repositories/memoryRepository');

class MemoryService {
  async addMemorySignature(userId, signatureData) {
    try {
      const signatureId = uuidv4();
      const signature = { id: signatureId, ...signatureData };
      await MemoryRepository.addMemorySignature(userId, signature);
      await MemoryRepository.cacheMemorySignature(signatureId, signature);
      logger.info(`Signature mémoire ${signatureId} ajoutée pour l'utilisateur ${userId}`);
      return signature;
    } catch (error) {
      logger.error('Erreur lors de l\'ajout de la signature mémoire', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de l\'ajout de la signature mémoire');
    }
  }

  async validateMemorySignature(signatureId) {
    try {
      const isValid = await MemoryRepository.validateMemorySignature(signatureId);
      logger.info(`Signature mémoire ${signatureId} validée : ${isValid}`);
      return isValid;
    } catch (error) {
      logger.error('Erreur lors de la validation de la signature mémoire', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la validation de la signature mémoire');
    }
  }

  async clearExpiredSignatures() {
    try {
      await MemoryRepository.clearExpiredMemorySignatures();
      logger.info('Signatures mémoire expirées supprimées');
    } catch (error) {
      logger.error('Erreur lors de la suppression des signatures expirées', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la suppression des signatures expirées');
    }
  }
}

module.exports = new MemoryService();
