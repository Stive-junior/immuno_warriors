const { AppError, NotFoundError } = require('../utils/errorUtils');
const  logger  = require('../utils/logger');
const UserRepository = require('../repositories/userRepository');

class UserService {
  async getUserProfile(userId) {
    try {
      const user = await UserRepository.getCurrentUser(userId);
      if (!user) throw new NotFoundError('Utilisateur non trouvé');
      logger.info(`Profil de l'utilisateur ${userId} récupéré`);
      return user;
    } catch (error) {
      logger.error('Erreur lors de la récupération du profil', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la récupération du profil');
    }
  }

  async updateUserProfile(userId, profile) {
    try {
      await UserRepository.updateUserProfile(userId, profile);
      await UserRepository.cacheCurrentUser(userId, { ...await UserRepository.getCurrentUser(userId), ...profile });
      logger.info(`Profil de l'utilisateur ${userId} mis à jour`);
    } catch (error) {
      logger.error('Erreur lors de la mise à jour du profil', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la mise à jour du profil');
    }
  }

  async addResources(userId, resources) {
    try {
      const currentResources = await UserRepository.getUserResources(userId);
      const updatedResources = {
        credits: (currentResources.credits || 0) + (resources.credits || 0),
        energy: (currentResources.energy || 0) + (resources.energy || 0)
      };
      await UserRepository.updateUserResources(userId, updatedResources);
      await UserRepository.cacheCurrentUser(userId, { ...await UserRepository.getCurrentUser(userId), resources: updatedResources });
      logger.info(`Ressources ajoutées pour l'utilisateur ${userId}`);
    } catch (error) {
      logger.error('Erreur lors de l\'ajout de ressources', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de l\'ajout de ressources');
    }
  }

  async getUserResources(userId) {
    try {
      const resources = await UserRepository.getUserResources(userId);
      logger.info(`Ressources de l'utilisateur ${userId} récupérées`);
      return resources;
    } catch (error) {
      logger.error('Erreur lors de la récupération des ressources', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la récupération des ressources');
    }
  }

  async addInventoryItem(userId, item) {
    try {
      await UserRepository.addItemToInventory(userId, item);
      const user = await UserRepository.getCurrentUser(userId);
      await UserRepository.cacheCurrentUser(userId, user);
      logger.info(`Élément ajouté à l'inventaire de l'utilisateur ${userId}`);
    } catch (error) {
      logger.error('Erreur lors de l\'ajout à l\'inventaire', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de l\'ajout à l\'inventaire');
    }
  }

  async removeInventoryItem(userId, item) {
    try {
      await UserRepository.removeItemFromInventory(userId, item);
      const user = await UserRepository.getCurrentUser(userId);
      await UserRepository.cacheCurrentUser(userId, user);
      logger.info(`Élément supprimé de l'inventaire de l'utilisateur ${userId}`);
    } catch (error) {
      logger.error('Erreur lors de la suppression de l\'inventaire', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la suppression de l\'inventaire');
    }
  }

  async getUserInventory(userId) {
    try {
      const inventory = await UserRepository.getUserInventory(userId);
      logger.info(`Inventaire de l'utilisateur ${userId} récupéré`);
      return inventory;
    } catch (error) {
      logger.error('Erreur lors de la récupération de l\'inventaire', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la récupération de l\'inventaire');
    }
  }

  async updateUserSettings(userId, settings) {
    try {
      await UserRepository.updateUserSettings(userId, settings);
      const user = await UserRepository.getCurrentUser(userId);
      await UserRepository.cacheCurrentUser(userId, user);
      logger.info(`Paramètres de l'utilisateur ${userId} mis à jour`);
    } catch (error) {
      logger.error('Erreur lors de la mise à jour des paramètres', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la mise à jour des paramètres');
    }
  }

  async getUserSettings(userId) {
    try {
      const settings = await UserRepository.getUserSettings(userId);
      logger.info(`Paramètres de l'utilisateur ${userId} récupérés`);
      return settings;
    } catch (error) {
      logger.error('Erreur lors de la récupération des paramètres', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la récupération des paramètres');
    }
  }

  async updateUserProgression(userId, progression) {
    try {
      await UserRepository.updateUserProgression(userId, progression);
      const user = await UserRepository.getCurrentUser(userId);
      await UserRepository.cacheCurrentUser(userId, user);
      logger.info(`Progression de l'utilisateur ${userId} mise à jour`);
    } catch (error) {
      logger.error('Erreur lors de la mise à jour de la progression', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la mise à jour de la progression');
    }
  }

  async getUserProgression(userId) {
    try {
      const progression = await UserRepository.getUserProgression(userId);
      logger.info(`Progression de l'utilisateur ${userId} récupérée`);
      return progression;
    } catch (error) {
      logger.error('Erreur lors de la récupération de la progression', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la récupération de la progression');
    }
  }

  async updateUserAchievements(userId, achievements) {
    try {
      await UserRepository.updateUserAchievements(userId, achievements);
      const user = await UserRepository.getCurrentUser(userId);
      await UserRepository.cacheCurrentUser(userId, user);
      logger.info(`Succès de l'utilisateur ${userId} mis à jour`);
    } catch (error) {
      logger.error('Erreur lors de la mise à jour des succès', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la mise à jour des succès');
    }
  }

  async getUserAchievements(userId) {
    try {
      const achievements = await UserRepository.getUserAchievements(userId);
      logger.info(`Succès de l'utilisateur ${userId} récupérés`);
      return achievements;
    } catch (error) {
      logger.error('Erreur lors de la récupération des succès', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la récupération des succès');
    }
  }

  async deleteUser(userId) {
    try {
      await UserRepository.clearUser(userId);
      await UserRepository.clearCurrentUserCache(userId);
      logger.info(`Utilisateur ${userId} supprimé`);
    } catch (error) {
      logger.error('Erreur lors de la suppression de l\'utilisateur', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la suppression de l\'utilisateur');
    }
  }
}

module.exports = new UserService();
