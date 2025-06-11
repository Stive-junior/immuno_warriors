const Joi = require('joi');

/**
 * Schéma pour un élément d'inventaire dans Firestore et les réponses API.
 * @typedef {Object} InventoryItem
 * @property {string} id - Identifiant unique.
 * @property {string} type - Type d'élément (ex. resource, equipment).
 * @property {string} name - Nom de l'élément.
 * @property {number} quantity - Quantité.
 * @property {Object} [properties] - Propriétés supplémentaires.
 */
const inventorySchema = Joi.object({
  id: Joi.string().uuid().required(),
  type: Joi.string().required(),
  name: Joi.string().required(),
  quantity: Joi.number().integer().min(0).required(),
  properties: Joi.object().optional()
});

/**
 * Valide les données d'inventaire.
 * @param {Object} data - Données à valider.
 * @returns {Object} Résultat de la validation Joi.
 */
const validateInventoryItem = (data) => inventorySchema.validate(data, { abortEarly: false });

/**
 * Convertit un élément Firestore en format API.
 * @param {Object} doc - Document Firestore.
 * @returns {Object} Élément formaté.
 */
const fromFirestore = (doc) => ({
  id: doc.id,
  type: doc.type,
  name: doc.name,
  quantity: doc.quantity,
  properties: doc.properties || {}
});

/**
 * Convertit un élément API en format Firestore.
 * @param {Object} item - Élément API.
 * @returns {Object} Données Firestore.
 */
const toFirestore = (item) => ({
  id: item.id,
  type: item.type,
  name: item.name,
  quantity: item.quantity,
  properties: item.properties
});

module.exports = {
  inventorySchema,
  validateInventoryItem,
  fromFirestore,
  toFirestore
};
