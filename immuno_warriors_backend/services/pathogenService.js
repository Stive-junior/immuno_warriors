const { v4: uuidv4 } = require('uuid');
const { AppError } = require('../utils/errorUtils');
const  logger  = require('../utils/logger');
const PathogenRepository = require('../repositories/pathogenRepository');

class PathogenService {
  async createPathogen(pathogenData) {
    try {
      const pathogenId = uuidv4();
      const pathogen = { id: pathogenId, ...pathogenData };
      await PathogenRepository.createPathogen(pathogen);
      await PathogenRepository.cachePathogen(pathogenId, pathogen);
      logger.info(`Pathogène ${pathogenId} créé`);
      return pathogen;
    } catch (error) {
      logger.error('Erreur lors de la création du pathogène', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la création du pathogène');
    }
  }

  async getPathogensByType(type) {
    try {
      const pathogens = await PathogenRepository.getPathogensByType(type);
      logger.info(`Pathogènes récupérés pour le type ${type}`);
      return pathogens;
    } catch (error) {
      logger.error('Erreur lors de la récupération des pathogènes par type', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la récupération des pathogènes');
    }
  }

  async getPathogensByRarity(rarity) {
    try {
      const pathogens = await PathogenRepository.getPathogensByRarity(rarity);
      logger.info(`Pathogènes récupérés pour la rareté ${rarity}`);
      return pathogens;
    } catch (error) {
      logger.error('Erreur lors de la récupération des pathogènes par rareté', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la récupération des pathogènes');
    }
  }

  async updatePathogenStats(pathogenId, stats) {
    try {
      await PathogenRepository.updatePathogenStats(pathogenId, stats);
      const pathogen = await PathogenRepository.getPathogenById(pathogenId);
      await PathogenRepository.cachePathogen(pathogenId, pathogen);
      logger.info(`Statistiques du pathogène ${pathogenId} mises à jour`);
    } catch (error) {
      logger.error('Erreur lors de la mise à jour des statistiques du pathogène', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la mise à jour des statistiques');
    }
  }
}

module.exports = new PathogenService();
