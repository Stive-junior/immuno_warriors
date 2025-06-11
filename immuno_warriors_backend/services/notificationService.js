const { v4: uuidv4 } = require('uuid');
const { AppError } = require('../utils/errorUtils');
const  logger  = require('../utils/logger');
const NotificationRepository = require('../repositories/notificationRepository');

class NotificationService {
  async createNotification(userId, notificationData) {
    try {
      const notificationId = uuidv4();
      const notification = {
        id: notificationId,
        userId,
        createdAt: new Date().toISOString(),
        isRead: false,
        ...notificationData
      };
      await NotificationRepository.createNotification(notification);
      await NotificationRepository.cacheNotification(notificationId, notification);
      logger.info(`Notification ${notificationId} créée pour l'utilisateur ${userId}`);
      return notification;
    } catch (error) {
      logger.error('Erreur lors de la création de la notification', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la création de la notification');
    }
  }

  async getNotifications(userId) {
    try {
      const notifications = await NotificationRepository.getNotifications(userId);
      logger.info(`Notifications récupérées pour l'utilisateur ${userId}`);
      return notifications;
    } catch (error) {
      logger.error('Erreur lors de la récupération des notifications', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la récupération des notifications');
    }
  }

  async markAsRead(notificationId) {
    try {
      await NotificationRepository.markNotificationAsRead(notificationId);
      logger.info(`Notification ${notificationId} marquée comme lue`);
    } catch (error) {
      logger.error('Erreur lors du marquage de la notification comme lue', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors du marquage de la notification');
    }
  }

  async deleteNotification(notificationId) {
    try {
      await NotificationRepository.deleteNotification(notificationId);
      logger.info(`Notification ${notificationId} supprimée`);
    } catch (error) {
      logger.error('Erreur lors de la suppression de la notification', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la suppression de la notification');
    }
  }
}

module.exports = new NotificationService();
