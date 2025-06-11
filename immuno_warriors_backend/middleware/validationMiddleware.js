//const Joi = require('joi');
const { AppError } = require('../utils/errorUtils');
const { logger } = require('../utils/logger');

const validate = (schema) => (req, res, next) => {
  const { error } = schema.validate(req.body, { abortEarly: false });
  if (error) {
    logger.warn('Erreur de validation', { details: error.details });
    throw new AppError(400, 'Données invalides', error.details);
  }
  next();
};

module.exports = validate;
