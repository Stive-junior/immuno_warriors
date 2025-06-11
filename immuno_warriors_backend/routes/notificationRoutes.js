const express = require('express');
const router = express.Router();
const authenticate = require('../middleware/authMiddleware');
const {
  createNotification,
  getNotifications,
  markAsRead,
  deleteNotification,
} = require('../controllers/notificationController');

router.use(authenticate);

router.post('/', createNotification);
router.get('/', getNotifications);
router.put('/:notificationId/read', markAsRead);
router.delete('/:notificationId', deleteNotification);

module.exports = router;
