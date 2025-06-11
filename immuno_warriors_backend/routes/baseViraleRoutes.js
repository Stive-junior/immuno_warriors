const express = require('express');
const router = express.Router();
const authenticate = require('../middleware/authMiddleware');
const {
  createBase,
  updateBase,
  addPathogen,
  levelUpBase,
  getPlayerBases,
} = require('../controllers/baseViraleController');

router.use(authenticate);

router.post('/', createBase);
router.put('/:baseId', updateBase);
router.post('/:baseId/pathogens', addPathogen);
router.post('/:baseId/level-up', levelUpBase);
router.get('/', getPlayerBases);

module.exports = router;
