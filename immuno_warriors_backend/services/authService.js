const jwt = require('jsonwebtoken');
const { v4: uuidv4 } = require('uuid');
const { validateUser } = require('../models/userModel');
const { AppError, UnauthorizedError } = require('../utils/errorUtils');
const { logger } = require('../utils/logger');
const UserRepository = require('../repositories/userRepository');

class AuthService {
  async signUp(userData) {
    const { email, password, username } = userData;
    const validation = validateUser(userData);
    if (validation.error) {
      throw new AppError(400, 'Données utilisateur invalides', validation.error.details);
    }

    try {
      const existingUser = await UserRepository.getUserById(email);
      if (existingUser) {
        throw new AppError(409, 'Email déjà utilisé');
      }

      const userId = uuidv4();
      const user = {
        id: userId,
        email,
        password,
        username,
        resources: { credits: 100, energy: 50 },
        inventory: [],
        settings: {},
        progression: { level: 1, xp: 0 },
        achievements: [],
        createdAt: new Date().toISOString()
      };

      await UserRepository.saveUser(user);
      const token = await UserRepository.fetchSessionToken(userId);
      await UserRepository.cacheCurrentUser(userId, user);
      logger.info(`Utilisateur ${userId} inscrit avec succès`);
      return { user, token };
    } catch (error) {
      logger.error('Erreur lors de l\'inscription', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de l\'inscription');
    }
  }

  async signIn(credentials) {
    const { email, password } = credentials;
    try {
      const user = await UserRepository.authenticateUser(email, password);
      const token = await UserRepository.fetchSessionToken(user.id);
      await UserRepository.cacheCurrentUser(user.id, user);
      logger.info(`Utilisateur ${user.id} connecté avec succès`);
      return { user, token };
    } catch (error) {
      logger.error('Erreur lors de la connexion', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la connexion');
    }
  }

  async refreshToken(oldToken) {
    try {
      const newToken = await UserRepository.refreshSessionToken(oldToken);
      logger.info('Token rafraîchi avec succès');
      return newToken;
    } catch (error) {
      logger.error('Erreur lors du rafraîchissement du token', { error });
      throw error instanceof AppError ? error : new AppError(401, 'Token invalide ou expiré');
    }
  }

  async signOut(token) {
    try {
      const decoded = jwt.verify(token, process.env.JWT_SECRET);
      await UserRepository.clearCachedSession(decoded.sessionId);
      logger.info(`Utilisateur ${decoded.userId} déconnecté`);
    } catch (error) {
      logger.error('Erreur lors de la déconnexion', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la déconnexion');
    }
  }

  async verifyToken(token) {
    try {
      const decoded = jwt.verify(token, process.env.JWT_SECRET);
      const isValid = await UserRepository.isSessionValid(decoded.sessionId);
      if (!isValid) throw new UnauthorizedError('Session invalide');
      logger.info(`Token vérifié pour l'utilisateur ${decoded.userId}`);
      return { userId: decoded.userId, sessionId: decoded.sessionId };
    } catch (error) {
      logger.error('Erreur lors de la vérification du token', { error });
      throw error instanceof AppError ? error : new AppError(401, 'Token invalide');
    }
  }
}

module.exports = new AuthService();
