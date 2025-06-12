const express = require('express');
const router = express.Router();
const {
  signUp,
  signIn,
  refreshToken,
  signOut,
  verifyToken,
} = require('../controllers/authController');

router.get('/', (req, res) => res.json({ message: 'API Auth' }));
router.post('/sign-up', signUp);
router.post('/sign-in', signIn);
router.post('/refresh-token', refreshToken);
router.post('/sign-out', signOut);
router.get('/verify-token', verifyToken);

module.exports = router;
