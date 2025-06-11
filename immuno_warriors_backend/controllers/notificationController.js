const Joi = require('joi');
const validate = require('../middleware/validationMiddleware');
const { AppError } = require('../utils/errorUtils');
const NotificationService = require('../services/notificationService');

const createNotificationSchema = Joi.object({
  message: Joi.string().required(),
  type: Joi.string().required(),
});

class NotificationController {
  async createNotification(req, res) {
    const { userId } = req.user;
    const notificationData = req.body;
    try {
      const notification = await NotificationService.createNotification(userId, notificationData);
      res.status(201).json(notification);
    } catch (error) {
      throw error;
    }
  }

  async getNotifications(req, res) {
    const { userId } = req.user;
    try {
      const notifications = await NotificationService.getNotifications(userId);
      res.status(200).json(notifications);
    } catch (error) {
      throw error;
    }
  }

  async markAsRead(req, res) {
    const { notificationId } = req.params;
    try {
      await NotificationService.markAsRead(notificationId);
      res.status(200).json({ message: 'Notification marquée comme lue' });
    } catch (error) {
      throw error;
    }
  }

  async deleteNotification(req, res) {
    const { notificationId } = req.params;
    try {
      await NotificationService.deleteNotification(notificationId);
      res.status(200).json({ message: 'Notification supprimée' });
    } catch (error) {
      throw error;
    }
  }
}

const controller = new NotificationController();
module.exports = {
  createNotification: [validate(createNotificationSchema), controller.createNotification.bind(controller)],
  getNotifications: controller.getNotifications.bind(controller),
  markAsRead: controller.markAsRead.bind(controller),
  deleteNotification: controller.deleteNotification.bind(controller),
};
