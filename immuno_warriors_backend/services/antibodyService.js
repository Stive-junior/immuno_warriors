const { v4: uuidv4 } = require('uuid');
const { AppError } = require('../utils/errorUtils');
const  logger  = require('../utils/logger');
const AntibodyRepository = require('../repositories/antibodyRepository');

class AntibodyService {
  async createAntibody(antibodyData) {
    try {
      const antibodyId = uuidv4();
      const antibody = { id: antibodyId, ...antibodyData };
      await AntibodyRepository.createAntibody(antibody);
      await AntibodyRepository.cacheAntibody(antibodyId, antibody);
      logger.info(`Anticorps ${antibodyId} créé`);
      return antibody;
    } catch (error) {
      logger.error('Erreur lors de la création de l\'anticorps', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la création de l\'anticorps');
    }
  }

  async getAntibodiesByType(type) {
    try {
      const antibodies = await AntibodyRepository.getAntibodiesByType(type);
      logger.info(`Anticorps récupérés pour le type ${type}`);
      return antibodies;
    } catch (error) {
      logger.error('Erreur lors de la récupération des anticorps par type', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la récupération des anticorps');
    }
  }

  async getAntibodiesByAttackType(attackType) {
    try {
      const antibodies = await AntibodyRepository.getAntibodiesByAttackType(attackType);
      logger.info(`Anticorps récupérés pour le type d\'attaque ${attackType}`);
      return antibodies;
    } catch (error) {
      logger.error('Erreur lors de la récupération des anticorps par type d\'attaque', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la récupération des anticorps');
    }
  }

  async updateAntibody(antibodyId, updates) {
    try {
      await AntibodyRepository.updateAntibody(antibodyId, updates);
      const antibody = await AntibodyRepository.getAntibodyById(antibodyId);
      await AntibodyRepository.cacheAntibody(antibodyId, antibody);
      logger.info(`Anticorps ${antibodyId} mis à jour`);
    } catch (error) {
      logger.error('Erreur lors de la mise à jour de l\'anticorps', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la mise à jour de l\'anticorps');
    }
  }
}

module.exports = new AntibodyService();
