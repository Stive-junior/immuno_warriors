const Joi = require('joi');

/**
 * Schéma pour la progression dans Firestore et les réponses API.
 * @typedef {Object} Progression
 * @property {string} userId - ID de l'utilisateur.
 * @property {number} level - Niveau actuel.
 * @property {number} xp - Points d'expérience.
 * @property {string} [rank] - Rang (ex. bronze, silver).
 */
const progressionSchema = Joi.object({
  userId: Joi.string().uuid().required(),
  level: Joi.number().integer().min(1).required(),
  xp: Joi.number().integer().min(0).required(),
  rank: Joi.string().optional()
});

/**
 * Valide les données de progression.
 * @param {Object} data - Données à valider.
 * @returns {Object} Résultat de la validation Joi.
 */
const validateProgression = (data) => progressionSchema.validate(data, { abortEarly: false });

/**
 * Convertit une progression Firestore en format API.
 * @param {Object} doc - Document Firestore.
 * @returns {Object} Progression formatée.
 */
const fromFirestore = (doc) => ({
  userId: doc.userId,
  level: doc.level,
  xp: doc.xp,
  rank: doc.rank || null
});

/**
 * Convertit une progression API en format Firestore.
 * @param {Object} progression - Progression API.
 * @returns {Object} Données Firestore.
 */
const toFirestore = (progression) => ({
  userId: progression.userId,
  level: progression.level,
  xp: progression.xp,
  rank: progression.rank
});

module.exports = {
  progressionSchema,
  validateProgression,
  fromFirestore,
  toFirestore
};
