const { db, auth } = require('../services/firebaseService');
const { v4: uuidv4 } = require('uuid');
const jwt = require('jsonwebtoken');
const { validateUser, fromFirestore, toFirestore } = require('../models/userModel');
const { AppError, NotFoundError, UnauthorizedError } = require('../utils/errorUtils');
const logger = require('../utils/logger');
const { formatTimestamp, isExpired } = require('../utils/dateUtils');

/**
 * Repository pour gérer les opérations CRUD des utilisateurs dans Firestore.
 */
class UserRepository {
  constructor() {
    this.collection = db.collection('users');
    this.sessionCollection = db.collection('sessions');
    this.cacheCollection = db.collection('userCache');
    this.jwtSecret = process.env.JWT_SECRET || 'immuno_warriors_secret';
  }

  /**
   * Crée un nouvel utilisateur avec Firebase Auth
   * @param {Object} userData - Données de l'utilisateur incluant email et password
   * @returns {Promise<Object>} Utilisateur créé avec son ID
   */
  async createUser(userData) {
    const { email, password, ...userProfile } = userData;
    const validation = validateUser(userProfile);
    if (validation.error) {
      throw new AppError(400, 'Données utilisateur invalides', validation.error.details);
    }

    try {
      const userRecord = await auth.createUser({
        email,
        password,
        emailVerified: false,
        disabled: false,
      });

      const user = {
        ...userProfile,
        id: userRecord.uid,
        email,
        createdAt: formatTimestamp(),
        resources: {},
        inventory: [],
        settings: {},
        progression: {},
        achievements: {}
      };

      await this.collection.doc(userRecord.uid).set(toFirestore(user));
      logger.info(`Utilisateur créé avec succès: ${userRecord.uid}`);
      return { id: userRecord.uid, ...fromFirestore(user) };
    } catch (error) {
      logger.error('Erreur lors de la création de l\'utilisateur', { error });
      throw new AppError(500, 'Erreur serveur lors de la création de l\'utilisateur');
    }
  }

  /**
   * Authentifie un utilisateur avec email et mot de passe
   * @param {string} email - Email de l'utilisateur
   * @param {string} password - Mot de passe
   * @returns {Promise<Object>} Utilisateur authentifié avec token
   */
  async authenticateUser(email, password) {
    try {
      const userRecord = await auth.getUserByEmail(email);
      const userDoc = await this.collection.doc(userRecord.uid).get();

      if (!userDoc.exists) {
        throw new UnauthorizedError('Utilisateur non trouvé');
      }

      const user = fromFirestore(userDoc.data());
      const token = await this.fetchSessionToken(user.id);
      logger.info(`Utilisateur ${user.id} authentifié`);
      return { ...user, token };
    } catch (error) {
      logger.error('Erreur lors de l\'authentification', { error });
      throw error instanceof AppError ? error : new UnauthorizedError('Email ou mot de passe incorrect');
    }
  }

  /**
   * Récupère l'utilisateur actuel par ID.
   * @param {string} userId - ID de l'utilisateur.
   * @returns {Promise<Object|null>} Utilisateur ou null.
   */
  async getCurrentUser(userId) {
    try {
      const doc = await this.collection.doc(userId).get();
      if (!doc.exists) return null;
      return fromFirestore(doc.data());
    } catch (error) {
      logger.error('Erreur lors de la récupération de l\'utilisateur', { error });
      throw new AppError(500, 'Erreur serveur lors de la récupération de l\'utilisateur');
    }
  }

  /**
   * Sauvegarde ou met à jour un utilisateur.
   * @param {Object} user - Données de l'utilisateur.
   * @returns {Promise<void>}
   */
  async saveUser(user) {
    const validation = validateUser(user);
    if (validation.error) {
      throw new AppError(400, 'Données utilisateur invalides', validation.error.details);
    }

    try {
      await this.collection.doc(user.id).set(toFirestore(user));
      logger.info(`Utilisateur ${user.id} sauvegardé`);
    } catch (error) {
      logger.error('Erreur lors de la sauvegarde de l\'utilisateur', { error });
      throw new AppError(500, 'Erreur serveur lors de la sauvegarde de l\'utilisateur');
    }
  }

  /**
   * Récupère les ressources de l'utilisateur.
   * @param {string} userId - ID de l'utilisateur.
   * @returns {Promise<Object>} Ressources.
   */
  async getUserResources(userId) {
    const user = await this.getCurrentUser(userId);
    if (!user) throw new NotFoundError('Utilisateur non trouvé');
    return user.resources || {};
  }

  /**
   * Met à jour les ressources de l'utilisateur.
   * @param {string} userId - ID de l'utilisateur.
   * @param {Object} resources - Nouvelles ressources.
   * @returns {Promise<void>}
   */
  async updateUserResources(userId, resources) {
    try {
      await this.collection.doc(userId).update({ resources });
      logger.info(`Ressources de l'utilisateur ${userId} mises à jour`);
    } catch (error) {
      logger.error('Erreur lors de la mise à jour des ressources', { error });
      throw new AppError(500, 'Erreur serveur lors de la mise à jour des ressources');
    }
  }

  /**
   * Récupère l'inventaire de l'utilisateur.
   * @param {string} userId - ID de l'utilisateur.
   * @returns {Promise<Array>} Inventaire.
   */
  async getUserInventory(userId) {
    const user = await this.getCurrentUser(userId);
    if (!user) throw new NotFoundError('Utilisateur non trouvé');
    return user.inventory || [];
  }

  /**
   * Ajoute un élément à l'inventaire.
   * @param {string} userId - ID de l'utilisateur.
   * @param {Object} item - Élément à ajouter.
   * @returns {Promise<void>}
   */
  async addItemToInventory(userId, item) {
    try {
      await this.collection.doc(userId).update({
        inventory: db.FieldValue.arrayUnion(item)
      });
      logger.info(`Élément ajouté à l'inventaire de ${userId}`);
    } catch (error) {
      logger.error('Erreur lors de l\'ajout à l\'inventaire', { error });
      throw new AppError(500, 'Erreur serveur lors de l\'ajout à l\'inventaire');
    }
  }

  /**
   * Supprime un élément de l'inventaire.
   * @param {string} userId - ID de l'utilisateur.
   * @param {Object} item - Élément à supprimer.
   * @returns {Promise<void>}
   */
  async removeItemFromInventory(userId, item) {
    try {
      await this.collection.doc(userId).update({
        inventory: db.FieldValue.arrayRemove(item)
      });
      logger.info(`Élément supprimé de l'inventaire de ${userId}`);
    } catch (error) {
      logger.error('Erreur lors de la suppression de l\'inventaire', { error });
      throw new AppError(500, 'Erreur serveur lors de la suppression de l\'inventaire');
    }
  }

  /**
   * Met à jour l'inventaire entier.
   * @param {string} userId - ID de l'utilisateur.
   * @param {Array} inventory - Nouvel inventaire.
   * @returns {Promise<void>}
   */
  async updateUserInventory(userId, inventory) {
    try {
      await this.collection.doc(userId).update({ inventory });
      logger.info(`Inventaire de l'utilisateur ${userId} mis à jour`);
    } catch (error) {
      logger.error('Erreur lors de la mise à jour de l\'inventaire', { error });
      throw new AppError(500, 'Erreur serveur lors de la mise à jour de l\'inventaire');
    }
  }

  /**
   * Supprime un utilisateur de Firestore et Firebase Auth.
   * @param {string} userId - ID de l'utilisateur.
   * @returns {Promise<void>}
   */
  async clearUser(userId) {
    try {
      await this.collection.doc(userId).delete();
      await this.sessionCollection.where('userId', '==', userId).get()
        .then(snapshot => Promise.all(snapshot.docs.map(doc => doc.ref.delete())));
      await this.cacheCollection.doc(userId).delete();
      await auth.deleteUser(userId);
      logger.info(`Utilisateur ${userId} supprimé`);
    } catch (error) {
      logger.error('Erreur lors de la suppression de l\'utilisateur', { error });
      throw new AppError(500, 'Erreur serveur lors de la suppression de l\'utilisateur');
    }
  }

  /**
   * Récupère les paramètres de l'utilisateur.
   * @param {string} userId - ID de l'utilisateur.
   * @returns {Promise<Object>} Paramètres.
   */
  async getUserSettings(userId) {
    const user = await this.getCurrentUser(userId);
    if (!user) throw new NotFoundError('Utilisateur non trouvé');
    return user.settings || {};
  }

  /**
   * Met à jour les paramètres de l'utilisateur.
   * @param {string} userId - ID de l'utilisateur.
   * @param {Object} settings - Nouveaux paramètres.
   * @returns {Promise<void>}
   */
  async updateUserSettings(userId, settings) {
    try {
      await this.collection.doc(userId).update({ settings });
      logger.info(`Paramètres de l'utilisateur ${userId} mis à jour`);
    } catch (error) {
      logger.error('Erreur lors de la mise à jour des paramètres', { error });
      throw new AppError(500, 'Erreur serveur lors de la mise à jour des paramètres');
    }
  }

  /**
   * Récupère la progression de l'utilisateur.
   * @param {string} userId - ID de l'utilisateur.
   * @returns {Promise<Object>} Progression.
   */
  async getUserProgression(userId) {
    const user = await this.getCurrentUser(userId);
    if (!user) throw new NotFoundError('Utilisateur non trouvé');
    return user.progression || {};
  }

  /**
   * Met à jour la progression de l'utilisateur.
   * @param {string} userId - ID de l'utilisateur.
   * @param {Object} progression - Nouvelle progression.
   * @returns {Promise<void>}
   */
  async updateUserProgression(userId, progression) {
    try {
      await this.collection.doc(userId).update({ progression });
      logger.info(`Progression de l'utilisateur ${userId} mise à jour`);
    } catch (error) {
      logger.error('Erreur lors de la mise à jour de la progression', { error });
      throw new AppError(500, 'Erreur serveur lors de la mise à jour de la progression');
    }
  }

  /**
   * Récupère les succès de l'utilisateur.
   * @param {string} userId - ID de l'utilisateur.
   * @returns {Promise<Object>} Succès.
   */
  async getUserAchievements(userId) {
    const user = await this.getCurrentUser(userId);
    if (!user) throw new NotFoundError('Utilisateur non trouvé');
    return user.achievements || {};
  }

  /**
   * Met à jour les succès de l'utilisateur.
   * @param {string} userId - ID de l'utilisateur.
   * @param {Object} achievements - Nouveaux succès.
   * @returns {Promise<void>}
   */
  async updateUserAchievements(userId, achievements) {
    try {
      await this.collection.doc(userId).update({ achievements });
      logger.info(`Succès de l'utilisateur ${userId} mis à jour`);
    } catch (error) {
      logger.error('Erreur lors de la mise à jour des succès', { error });
      throw new AppError(500, 'Erreur serveur lors de la mise à jour des succès');
    }
  }

  /**
   * Récupère tous les utilisateurs.
   * @returns {Promise<Array>} Liste des utilisateurs.
   */
  async getUsers() {
    try {
      const snapshot = await this.collection.get();
      return snapshot.docs.map(doc => fromFirestore(doc.data()));
    } catch (error) {
      logger.error('Erreur lors de la récupération des utilisateurs', { error });
      throw new AppError(500, 'Erreur serveur lors de la récupération des utilisateurs');
    }
  }

  /**
   * Récupère un utilisateur par ID (alias de getCurrentUser).
   * @param {string} userId - ID de l'utilisateur.
   * @returns {Promise<Object|null>} Utilisateur ou null.
   */
  async getUserById(userId) {
    return this.getCurrentUser(userId);
  }

  /**
   * Vérifie la validité d'une session.
   * @param {string} sessionId - ID de la session.
   * @returns {Promise<boolean>} True si valide, false sinon.
   */
  async checkSessionValidity(sessionId) {
    try {
      const doc = await this.sessionCollection.doc(sessionId).get();
      if (!doc.exists) return false;
      const session = doc.data();
      return !isExpired(session.expiresAt, 0);
    } catch (error) {
      logger.error('Erreur lors de la vérification de la session', { error });
      throw new AppError(500, 'Erreur serveur lors de la vérification de la session');
    }
  }

  /**
   * Récupère un token de session.
   * @param {string} userId - ID de l'utilisateur.
   * @returns {Promise<string>} Token JWT.
   */
  async fetchSessionToken(userId) {
    try {
      const sessionId = uuidv4();
      const expiresAt = new Date();
      expiresAt.setHours(expiresAt.getHours() + 24);
      const token = jwt.sign({ userId, sessionId }, this.jwtSecret, { expiresIn: '24h' });
      await this.sessionCollection.doc(sessionId).set({
        userId,
        token,
        expiresAt: formatTimestamp(expiresAt),
        createdAt: formatTimestamp()
      });
      logger.info(`Token de session généré pour l'utilisateur ${userId}`);
      return token;
    } catch (error) {
      logger.error('Erreur lors de la génération du token', { error });
      throw new AppError(500, 'Erreur serveur lors de la génération du token');
    }
  }

  /**
   * Vérifie si une session est valide (alias de checkSessionValidity).
   * @param {string} sessionId - ID de la session.
   * @returns {Promise<boolean>} True si valide.
   */
  async isSessionValid(sessionId) {
    return this.checkSessionValidity(sessionId);
  }

  /**
   * Met en cache une session utilisateur.
   * @param {string} userId - ID de l'utilisateur.
   * @param {Object} session - Données de la session.
   * @returns {Promise<void>}
   */
  async cacheUserSession(userId, session) {
    try {
      await this.sessionCollection.doc(session.sessionId).set({
        ...session,
        userId,
        cachedAt: formatTimestamp()
      });
      logger.info(`Session de l'utilisateur ${userId} mise en cache`);
    } catch (error) {
      logger.error('Erreur lors de la mise en cache de la session', { error });
      throw new AppError(500, 'Erreur serveur lors de la mise en cache de la session');
    }
  }

  /**
   * Récupère une session en cache.
   * @param {string} sessionId - ID de la session.
   * @returns {Promise<Object|null>} Session ou null.
   */
  async getCachedSession(sessionId) {
    try {
      const doc = await this.sessionCollection.doc(sessionId).get();
      if (!doc.exists) return null;
      return doc.data();
    } catch (error) {
      logger.error('Erreur lors de la récupération de la session en cache', { error });
      throw new AppError(500, 'Erreur serveur lors de la récupération de la session en cache');
    }
  }

  /**
   * Supprime une session en cache.
   * @param {string} sessionId - ID de la session.
   * @returns {Promise<void>}
   */
  async clearCachedSession(sessionId) {
    try {
      await this.sessionCollection.doc(sessionId).delete();
      logger.info(`Session ${sessionId} supprimée du cache`);
    } catch (error) {
      logger.error('Erreur lors de la suppression de la session en cache', { error });
      throw new AppError(500, 'Erreur serveur lors de la suppression de la session en cache');
    }
  }

  /**
   * Met en cache les données de l'utilisateur actuel.
   * @param {string} userId - ID de l'utilisateur.
   * @param {Object} userData - Données de l'utilisateur.
   * @returns {Promise<void>}
   */
  async cacheCurrentUser(userId, userData) {
    try {
      await this.cacheCollection.doc(userId).set({
        ...userData,
        cachedAt: formatTimestamp()
      });
      logger.info(`Utilisateur ${userId} mis en cache`);
    } catch (error) {
      logger.error('Erreur lors de la mise en cache de l\'utilisateur', { error });
      throw new AppError(500, 'Erreur serveur lors de la mise en cache de l\'utilisateur');
    }
  }

  /**
   * Supprime les données de l'utilisateur du cache.
   * @param {string} userId - ID de l'utilisateur.
   * @returns {Promise<void>}
   */
  async clearCurrentUserCache(userId) {
    try {
      await this.cacheCollection.doc(userId).delete();
      logger.info(`Cache de l'utilisateur ${userId} supprimé`);
    } catch (error) {
      logger.error('Erreur lors de la suppression du cache utilisateur', { error });
      throw new AppError(500, 'Erreur serveur lors de la suppression du cache utilisateur');
    }
  }

  /**
   * Met à jour le profil de l'utilisateur.
   * @param {string} userId - ID de l'utilisateur.
   * @param {Object} profile - Données du profil (ex. username, avatar).
   * @returns {Promise<void>}
   */
  async updateUserProfile(userId, profile) {
    try {
      const { username, avatar } = profile;
      await this.collection.doc(userId).update({ username, avatar });
      logger.info(`Profil de l'utilisateur ${userId} mis à jour`);
    } catch (error) {
      logger.error('Erreur lors de la mise à jour du profil', { error });
      throw new AppError(500, 'Erreur serveur lors de la mise à jour du profil');
    }
  }

  /**
   * Récupère les utilisateurs avec pagination.
   * @param {number} page - Numéro de page.
   * @param {number} limit - Limite par page.
   * @returns {Promise<Array>} Liste des utilisateurs.
   */
  async getPaginatedUsers(page = 1, limit = 10) {
    try {
      const snapshot = await this.collection
        .orderBy('createdAt', 'desc')
        .offset((page - 1) * limit)
        .limit(limit)
        .get();
      return snapshot.docs.map(doc => fromFirestore(doc.data()));
    } catch (error) {
      logger.error('Erreur lors de la récupération des utilisateurs paginés', { error });
      throw new AppError(500, 'Erreur serveur lors de la récupération des utilisateurs paginés');
    }
  }

  /**
   * Rafraîchit un token de session.
   * @param {string} oldToken - Ancien token JWT.
   * @returns {Promise<string>} Nouveau token.
   */
  async refreshSessionToken(oldToken) {
    try {
      const decoded = jwt.verify(oldToken, this.jwtSecret);
      const sessionId = decoded.sessionId;
      const userId = decoded.userId;

      const sessionDoc = await this.sessionCollection.doc(sessionId).get();
      if (!sessionDoc.exists) throw new UnauthorizedError('Session invalide');

      const newSessionId = uuidv4();
      const expiresAt = new Date();
      expiresAt.setHours(expiresAt.getHours() + 24);
      const newToken = jwt.sign({ userId, sessionId: newSessionId }, this.jwtSecret, { expiresIn: '24h' });

      await this.sessionCollection.doc(newSessionId).set({
        userId,
        token: newToken,
        expiresAt: formatTimestamp(expiresAt),
        createdAt: formatTimestamp()
      });

      await this.sessionCollection.doc(sessionId).delete();
      logger.info(`Token de session rafraîchi pour l'utilisateur ${userId}`);
      return newToken;
    } catch (error) {
      logger.error('Erreur lors du rafraîchissement du token', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors du rafraîchissement du token');
    }
  }
}

module.exports = new UserRepository();
