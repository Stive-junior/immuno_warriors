const { AppError } = require('../utils/errorUtils');
const  logger  = require('../utils/logger');
const SyncRepository = require('../repositories/syncRepository');

class SyncService {
  async syncUserData(userId, localData, lastSyncTimestamp) {
    try {
      const delta = await SyncRepository.synchronizeUserData(userId, localData, lastSyncTimestamp);
      logger.info(`Données utilisateur ${userId} synchronisées`);
      return delta;
    } catch (error) {
      logger.error('Erreur lors de la synchronisation des données utilisateur', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la synchronisation des données utilisateur');
    }
  }

  async syncInventory(userId, localItems, lastSyncTimestamp) {
    try {
      const delta = await SyncRepository.synchronizeInventory(userId, localItems, lastSyncTimestamp);
      logger.info(`Inventaire de l'utilisateur ${userId} synchronisé`);
      return delta;
    } catch (error) {
      logger.error('Erreur lors de la synchronisation de l\'inventaire', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la synchronisation de l\'inventaire');
    }
  }

  async syncThreats(localThreats, lastSyncTimestamp) {
    try {
      const delta = await SyncRepository.synchronizeThreats(localThreats, lastSyncTimestamp);
      logger.info('Menaces synchronisées');
      return delta;
    } catch (error) {
      logger.error('Erreur lors de la synchronisation des menaces', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la synchronisation des menaces');
    }
  }

  async syncMemorySignatures(userId, localSignatures, lastSyncTimestamp) {
    try {
      const delta = await SyncRepository.synchronizeMemorySignatures(userId, localSignatures, lastSyncTimestamp);
      logger.info(`Signatures mémoire de l'utilisateur ${userId} synchronisées`);
      return delta;
    } catch (error) {
      logger.error('Erreur lors de la synchronisation des signatures mémoire', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la synchronisation des signatures mémoire');
    }
  }

  async syncMultiplayerSessions(userId, localSessions, lastSyncTimestamp) {
    try {
      const delta = await SyncRepository.synchronizeMultiplayerSessions(userId, localSessions, lastSyncTimestamp);
      logger.info(`Sessions multijoueurs de l'utilisateur ${userId} synchronisées`);
      return delta;
    } catch (error) {
      logger.error('Erreur lors de la synchronisation des sessions multijoueurs', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la synchronisation des sessions multijoueurs');
    }
  }

  async syncNotifications(userId, localNotifications, lastSyncTimestamp) {
    try {
      const delta = await SyncRepository.synchronizeNotifications(userId, localNotifications, lastSyncTimestamp);
      logger.info(`Notifications de l'utilisateur ${userId} synchronisées`);
      return delta;
    } catch (error) {
      logger.error('Erreur lors de la synchronisation des notifications', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la synchronisation des notifications');
    }
  }

  async syncPathogens(localPathogens, lastSyncTimestamp) {
    try {
      const delta = await SyncRepository.synchronizePathogens(localPathogens, lastSyncTimestamp);
      logger.info('Pathogènes synchronisés');
      return delta;
    } catch (error) {
      logger.error('Erreur lors de la synchronisation des pathogènes', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la synchronisation des pathogènes');
    }
  }

  async syncResearches(userId, localResearches, lastSyncTimestamp) {
    try {
      const delta = await SyncRepository.synchronizeResearches(userId, localResearches, lastSyncTimestamp);
      logger.info(`Recherches de l'utilisateur ${userId} synchronisées`);
      return delta;
    } catch (error) {
      logger.error('Erreur lors de la synchronisation des recherches', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la synchronisation des recherches');
    }
  }
}

module.exports = new SyncService();
