const express = require('express');
const router = express.Router();
const authenticate = require('../middleware/authMiddleware');
const {
  addInventoryItem,
  getInventoryItem,
  updateInventoryItem,
  deleteInventoryItem,
} = require('../controllers/inventoryController');

router.use(authenticate);

router.post('/', addInventoryItem);
router.get('/:itemId', getInventoryItem);
router.put('/:itemId', updateInventoryItem);
router.delete('/:itemId', deleteInventoryItem);

module.exports = router;
