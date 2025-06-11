const express = require('express');
const router = express.Router();
const authenticate = require('../middleware/authMiddleware');
const {
  getAchievement,
  updateAchievement,
} = require('../controllers/achievementController');

router.use(authenticate);

router.get('/:achievementId', getAchievement);
router.put('/', updateAchievement);

module.exports = router;
