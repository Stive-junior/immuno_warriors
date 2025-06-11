const Joi = require('joi');

/**
 * Schéma pour un pathogène dans Firestore et les réponses API.
 * @typedef {Object} Pathogen
 * @property {string} id - Identifiant unique.
 * @property {string} type - Type (VIRAL, BACTERIAL, FUNGAL).
 * @property {string} name - Nom du pathogène.
 * @property {number} health - Points de vie.
 * @property {number} attack - Points d'attaque.
 * @property {string} attackType - Type d'attaque (MELEE, RANGED, SUPPORT).
 * @property {string} resistanceType - Type de résistance.
 * @property {string} rarity - Rareté (COMMON, RARE, EPIC).
 * @property {number} mutationRate - Taux de mutation (0 à 1).
 * @property {string[]} [abilities] - Capacités spéciales.
 */
const pathogenSchema = Joi.object({
  id: Joi.string().uuid().required(),
  type: Joi.string().valid('VIRAL', 'BACTERIAL', 'FUNGAL').required(),
  name: Joi.string().required(),
  health: Joi.number().integer().min(0).required(),
  attack: Joi.number().integer().min(0).required(),
  attackType: Joi.string().valid('MELEE', 'RANGED', 'SUPPORT').required(),
  resistanceType: Joi.string().required(),
  rarity: Joi.string().valid('COMMON', 'RARE', 'EPIC').required(),
  mutationRate: Joi.number().min(0).max(1).required(),
  abilities: Joi.array().items(Joi.string()).optional()
});

/**
 * Valide les données du pathogène.
 * @param {Object} data - Données à valider.
 * @returns {Object} Résultat de la validation Joi.
 */
const validatePathogen = (data) => pathogenSchema.validate(data, { abortEarly: false });

/**
 * Convertit un pathogène Firestore en format API.
 * @param {Object} doc - Document Firestore.
 * @returns {Object} Pathogène formaté.
 */
const fromFirestore = (doc) => ({
  id: doc.id,
  type: doc.type,
  name: doc.name,
  health: doc.health,
  attack: doc.attack,
  attackType: doc.attackType,
  resistanceType: doc.resistanceType,
  rarity: doc.rarity,
  mutationRate: doc.mutationRate,
  abilities: doc.abilities || []
});

/**
 * Convertit un pathogène API en format Firestore.
 * @param {Object} pathogen - Pathogène API.
 * @returns {Object} Données Firestore.
 */
const toFirestore = (pathogen) => ({
  id: pathogen.id,
  type: pathogen.type,
  name: pathogen.name,
  health: pathogen.health,
  attack: pathogen.attack,
  attackType: pathogen.attackType,
  resistanceType: pathogen.resistanceType,
  rarity: pathogen.rarity,
  mutationRate: pathogen.mutationRate,
  abilities: pathogen.abilities
});

module.exports = {
  pathogenSchema,
  validatePathogen,
  fromFirestore,
  toFirestore
};
