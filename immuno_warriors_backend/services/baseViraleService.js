const { v4: uuidv4 } = require('uuid');
const { AppError, NotFoundError } = require('../utils/errorUtils');
const  logger  = require('../utils/logger');
const BaseViraleRepository = require('../repositories/baseViraleRepository');
const PathogenRepository = require('../repositories/pathogenRepository');

class BaseViraleService {
  async createBase(userId, baseData) {
    try {
      const baseId = uuidv4();
      const base = {
        id: baseId,
        playerId: userId,
        level: 1,
        pathogens: [],
        defenses: [],
        createdAt: new Date().toISOString(),
        ...baseData
      };
      await BaseViraleRepository.createBaseVirale(base);
      await BaseViraleRepository.cacheBaseVirale(baseId, base);
      logger.info(`Base virale ${baseId} créée pour l'utilisateur ${userId}`);
      return base;
    } catch (error) {
      logger.error('Erreur lors de la création de la base virale', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la création de la base');
    }
  }

  async updateBase(baseId, updates) {
    try {
      await BaseViraleRepository.updateBaseVirale(baseId, updates);
      const base = await BaseViraleRepository.getBaseViraleById(baseId);
      await BaseViraleRepository.cacheBaseVirale(baseId, base);
      logger.info(`Base virale ${baseId} mise à jour`);
    } catch (error) {
      logger.error('Erreur lors de la mise à jour de la base virale', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la mise à jour de la base');
    }
  }

  async addPathogen(baseId, pathogenId) {
    try {
      const pathogen = await PathogenRepository.getPathogenById(pathogenId);
      if (!pathogen) throw new NotFoundError('Pathogène non trouvé');

      await BaseViraleRepository.addPathogenToBase(baseId, pathogen);
      const base = await BaseViraleRepository.getBaseViraleById(baseId);
      await BaseViraleRepository.cacheBaseVirale(baseId, base);
      logger.info(`Pathogène ${pathogenId} ajouté à la base ${baseId}`);
    } catch (error) {
      logger.error('Erreur lors de l\'ajout du pathogène à la base', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de l\'ajout du pathogène');
    }
  }

  async levelUpBase(baseId) {
    try {
      await BaseViraleRepository.levelUpBase(baseId);
      const base = await BaseViraleRepository.getBaseViraleById(baseId);
      await BaseViraleRepository.cacheBaseVirale(baseId, base);
      logger.info(`Base virale ${baseId} améliorée`);
    } catch (error) {
      logger.error('Erreur lors de l\'amélioration de la base', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de l\'amélioration de la base');
    }
  }

  async validateForCombat(baseId) {
    try {
      const isValid = await BaseViraleRepository.validateBaseForCombat(baseId);
      logger.info(`Validation de la base ${baseId} pour combat : ${isValid}`);
      return isValid;
    } catch (error) {
      logger.error('Erreur lors de la validation de la base pour combat', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la validation de la base');
    }
  }

  async getPlayerBases(userId) {
    try {
      const bases = await BaseViraleRepository.getBaseViralesForPlayer(userId);
      logger.info(`Bases virales récupérées pour l'utilisateur ${userId}`);
      return bases;
    } catch (error) {
      logger.error('Erreur lors de la récupération des bases du joueur', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la récupération des bases');
    }
  }
}

module.exports = new BaseViraleService();
