const { UnauthorizedError } = require('../utils/errorUtils');
const { logger } = require('../utils/logger');
const AuthService = require('../services/authService');

const authenticate = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      throw new UnauthorizedError('Token manquant ou invalide');
    }

    const token = authHeader.split(' ')[1];
    const { userId } = await AuthService.verifyToken(token);
    req.user = { userId };
    logger.info(`Utilisateur ${userId} authentifié avec succès`);
    next();
  } catch (error) {
    logger.error('Erreur d\'authentification', { error: error.message });
    res.status(error.statusCode || 401).json({ error: error.message });
  }
};

module.exports = authenticate;
