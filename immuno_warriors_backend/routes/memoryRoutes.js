const express = require('express');
const router = express.Router();
const authenticate = require('../middleware/authMiddleware');
const {
  addMemorySignature,
  validateMemorySignature,
  clearExpiredSignatures,
} = require('../controllers/memoryController');

router.use(authenticate);

router.post('/', addMemorySignature);
router.get('/:signatureId/validate', validateMemorySignature);
router.delete('/expire', clearExpiredSignatures);

module.exports = router;
