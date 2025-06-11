const express = require('express');
const router = express.Router();
const authenticate = require('../middleware/authMiddleware');
const {
  createAntibody,
  getAntibodiesByType,
  getAntibodiesByAttackType,
  updateAntibody,
} = require('../controllers/antibodyController');

router.use(authenticate);

router.post('/', createAntibody);
router.get('/type/:type', getAntibodiesByType);
router.get('/attack-type/:attackType', getAntibodiesByAttackType);
router.put('/:antibodyId', updateAntibody);

module.exports = router;
