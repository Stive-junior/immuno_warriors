const Joi = require('joi');
const validate = require('../middleware/validationMiddleware');
const { AppError } = require('../utils/errorUtils');
const AuthService = require('../services/authService');

/**
 * Schéma pour l'utilisateur dans Firestore et les réponses API.
 * @typedef {Object} User
 * @property {string} id - Identifiant unique de l'utilisateur (UUID).
 * @property {string} email - Adresse e-mail de l'utilisateur.
 * @property {string} [username] - Nom de d'utilisateur (optionnel).
 * @property {string} [avatar] - URL de l'avatar (optionnel).
 * @property {string} [createdAt] - Date de création (ISO 8601).
 * @property {string} [lastLogin] - Date de dernière connexion (ISO 8601).
 * @property {Object} [resources] - Ressources de l'utilisateur (ex. { energy: 100 }).
 * @property {Object} [progression] - Progression (ex. { level: 1, xp: 500 }).
 * @property {Object} [achievements] - Succès (ex. { firstCombat: true }).
 * @property {Array} [inventory] - Inventaire (liste d'objets).
 */

const signUpSchema = Joi.object({
  email: Joi.string().email().required(),
  password: Joi.string().min(6).required(),
  username: Joi.string().min(3).max(30).required(),
});

const signInSchema = Joi.object({
  email: Joi.string().email().required(),
  password: Joi.string().required(),
});

const refreshTokenSchema = Joi.object({
  token: Joi.string().required(),
});

class AuthController {
  /**
   * Inscrit un nouvel utilisateur.
   * @param {Object} req - Requête HTTP avec les données d'inscription.
   * @param {Object} res - Réponse HTTP.
   * @returns {Promise<void>} Réponse JSON avec l'utilisateur et le token.
   */
  async signUp(req, res) {
    const { email, password, username } = req.body;
    try {
      const { user, token } = await AuthService.signUp({ email, password, username });
      res.status(201).json({ user, token });
    } catch (error) {
      throw error;
    }
  }

  /**
   * Connecte un utilisateur existant.
   * @param {Object} req - Requête HTTP avec les données de connexion.
   * @param {Object} res - Réponse HTTP.
   * @returns {Promise<void>} Réponse JSON avec l'utilisateur et le token.
   */
  async signIn(req, res) {
    const { email, password } = req.body;
    try {
      const { user, token } = await AuthService.signIn({ email, password });
      res.status(200).json({ user, token });
    } catch (error) {
      throw error;
    }
  }

  /**
   * Rafraîchit le token de l'utilisateur.
   * @param {Object} req - Requête HTTP avec le token.
   * @param {Object} res - Réponse HTTP.
   * @returns {Promise<void>} Réponse JSON avec le nouveau token.
   */
  async refreshToken(req, res) {
    const { token } = req.body;
    if (!token) throw new AppError(400, 'Token manquant');
    try {
      const newToken = await AuthService.refreshToken(token);
      res.status(200).json({ token: newToken });
    } catch (error) {
      throw error;
    }
  }

  /**
   * Déconnecte l'utilisateur.
   * @param {Object} req - Requête HTTP avec le token.
   * @param {Object} res - Réponse HTTP.
   * @returns {Promise<void>} Réponse JSON confirmant la déconnexion.
   */
  async signOut(req, res) {
    const authHeader = req.headers.authorization;
    const token = authHeader && authHeader.split(' ')[1];
    try {
      await AuthService.signOut(token);
      res.status(200).json({ message: 'Déconnexion réussie' });
    } catch (error) {
      throw error;
    }
  }

  /**
   * Vérifie la validité d'un token.
   * @param {Object} req - Requête HTTP avec le token.
   * @param {Object} res - Réponse HTTP.
   * @returns {Promise<void>} Réponse JSON avec le résultat.
   */
  async verifyToken(req, res) {
    const authHeader = req.headers.authorization;
    const token = authHeader && authHeader.split(' ')[1];
    try {
      const result = await AuthService.verifyToken(token);
      res.status(200).json(result);
    } catch (error) {
      throw error;
    }
  }
}

const controller = new AuthController();
module.exports = {
  signUp: [validate(signUpSchema), controller.signUp.bind(controller)],
  signIn: [validate(signInSchema), controller.signIn.bind(controller)],
  refreshToken: [validate(refreshTokenSchema), controller.refreshToken.bind(controller)],
  signOut: controller.signOut.bind(controller),
  verifyToken: controller.verifyToken.bind(controller),
};
