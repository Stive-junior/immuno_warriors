const express = require('express');
const router = express.Router();
const authenticate = require('../middleware/authMiddleware');
const {
  chat,
  generateCombatChronicle,
  getTacticalAdvice,
  generateResearchDescription,
  generateBaseDescription,
  getStoredResponses,
} = require('../controllers/geminiController');

router.use(authenticate);

router.post('/chat', chat);
router.post('/combat-chronicle/:combatId', generateCombatChronicle);
router.post('/tactical-advice/:combatId', getTacticalAdvice);
router.post('/research-description/:researchId', generateResearchDescription);
router.post('/base-description/:baseId', generateBaseDescription);
router.get('/stored-responses', getStoredResponses);

module.exports = router;
