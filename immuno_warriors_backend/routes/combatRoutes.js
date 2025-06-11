const express = require('express');
const router = express.Router();
const authenticate = require('../middleware/authMiddleware');
const {
  startCombat,
  endCombat,
  getCombatReport,
  getCombatHistory,
  generateChronicle,
  getTacticalAdvice,
} = require('../controllers/combatController');

router.use(authenticate);

router.post('/', startCombat);
router.post('/:combatId/end', endCombat);
router.get('/:combatId/report', getCombatReport);
router.get('/history', getCombatHistory);
router.get('/:combatId/chronicle', generateChronicle);
router.get('/:combatId/tactical-advice', getTacticalAdvice);

module.exports = router;
