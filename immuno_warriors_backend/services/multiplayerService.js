const { v4: uuidv4 } = require('uuid');
const { AppError, NotFoundError } = require('../utils/errorUtils');
const  logger  = require('../utils/logger');
const MultiplayerRepository = require('../repositories/multiplayerRepository');

class MultiplayerService {
  async createSession(userId, sessionData) {
    try {
      const sessionId = uuidv4();
      const session = {
        sessionId,
        players: [userId],
        status: 'open',
        createdAt: new Date().toISOString(),
        ...sessionData
      };
      await MultiplayerRepository.createMultiplayerSession(session);
      await MultiplayerRepository.cacheMultiplayerSession(sessionId, session);
      logger.info(`Session multijoueur ${sessionId} créée par l'utilisateur ${userId}`);
      return session;
    } catch (error) {
      logger.error('Erreur lors de la création de la session multijoueur', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la création de la session');
    }
  }

  async joinSession(sessionId, userId) {
    try {
      const session = await MultiplayerRepository.getMultiplayerSessionId(sessionId);
      if (!session) throw new NotFoundError('Session multijoueur non trouvée');
      if (session.status !== 'open') throw new AppError(400, 'Session non ouverte');

      await MultiplayerRepository.updateMultiplayerSession(sessionId, {
        players: [...session.players, userId]
      });
      const updatedSession = await MultiplayerRepository.getMultiplayerSessionId(sessionId);
      await MultiplayerRepository.cacheMultiplayerSession(sessionId, updatedSession);
      logger.info(`Utilisateur ${userId} a rejoint la session ${sessionId}`);
      return updatedSession;
    } catch (error) {
      logger.error('Erreur lors de la jointure de la session multijoueur', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la jointure de la session');
    }
  }

  async getSessionStatus(sessionId) {
    try {
      const session = await MultiplayerRepository.getMultiplayerSessionId(sessionId);
      if (!session) throw new NotFoundError('Session multijoueur non trouvée');
      logger.info(`Statut de la session ${sessionId} récupéré`);
      return session;
    } catch (error) {
      logger.error('Erreur lors de la récupération du statut de la session', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la récupération du statut');
    }
  }
}

module.exports = new MultiplayerService();
