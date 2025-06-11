const { GoogleGenerativeAI } = require('@google/generative-ai');
const { v4: uuidv4 } = require('uuid');
const admin = require('firebase-admin');
const config = require('../config');
const { AppError, NotFoundError } = require('../utils/errorUtils');
const  logger  = require('../utils/logger');
const { formatTimestamp } = require('../utils/dateUtils');
const CombatRepository = require('../repositories/combatRepository');
const UserRepository = require('../repositories/userRepository');
const ResearchRepository = require('../repositories/researchRepository');
const BaseViraleRepository = require('../repositories/baseViraleRepository');

if (!config.geminiApiKey) {
  logger.error('Clé API Gemini (GEMINI_API_KEY) non configurée dans .env');
  process.exit(1);
}

const genAI = new GoogleGenerativeAI(config.geminiApiKey);
const model = genAI.getGenerativeModel({ model: 'gemini-pro' });

class GeminiService {
  constructor() {
    this.responseCollection = admin.firestore().collection('geminiResponses');
  }

  /**
   * Génère une chronique narrative pour un combat donné.
   * @param {string} combatId - ID du combat.
   * @returns {Promise<string>} Chronique narrative.
   */
  async generateCombatChronicle(combatId) {
    try {
      const combat = await CombatRepository.getCachedCombatReport(combatId) || 
        (await this.responseCollection.doc(combatId).get()).data();
      if (!combat) throw new NotFoundError('Combat non trouvé');

      const prompt = `Génère une chronique narrative immersive pour un combat dans le jeu Immuno Warriors. Voici les détails :
      - Combat ID : ${combat.combatId}
      - Date : ${combat.date}
      - Pathogènes : ${JSON.stringify(combat.pathogens, null, 2)}
      - Anticorps : ${JSON.stringify(combat.antibodies, null, 2)}
      - Tours : ${JSON.stringify(combat.rounds, null, 2)}
      - Résultat : ${combat.outcome}
      Raconte l'histoire comme une bataille épique entre des pathogènes envahissants et des anticorps défendant le corps humain, avec un style narratif captivant.`;

      const chronicle = await this._generateContent(prompt);
      await this._storeResponse(combatId, 'combat_chronicle', chronicle);
      logger.info(`Chronique générée pour le combat ${combatId}`);
      return chronicle;
    } catch (error) {
      logger.error('Erreur lors de la génération de la chronique de combat', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la génération de la chronique');
    }
  }

  /**
   * Fournit des conseils tactiques basés sur un combat.
   * @param {string} combatId - ID du combat.
   * @returns {Promise<Array>} Liste de conseils.
   */
  async getTacticalAdvice(combatId) {
    try {
      const combat = await CombatRepository.getCachedCombatReport(combatId) || 
        (await this.responseCollection.doc(combatId).get()).data();
      if (!combat) throw new NotFoundError('Combat non trouvé');

      const prompt = `Analyse les données suivantes d'un combat dans Immuno Warriors et fournis 3 à 5 conseils tactiques spécifiques pour améliorer les performances futures :
      - Pathogènes : ${JSON.stringify(combat.pathogens, null, 2)}
      - Anticorps : ${JSON.stringify(combat.antibodies, null, 2)}
      - Tours : ${JSON.stringify(combat.rounds, null, 2)}
      - Résultat : ${combat.outcome}
      Les conseils doivent être précis, en lien avec les statistiques (attaque, santé, etc.) et adaptés au contexte du jeu.`;

      const adviceText = await this._generateContent(prompt);
      const advice = adviceText.split('\n').filter(line => line.trim().startsWith('-')).map(line => line.trim().slice(2));
      await this._storeResponse(combatId, 'tactical_advice', advice);
      logger.info(`Conseils tactiques générés pour le combat ${combatId}`);
      return advice;
    } catch (error) {
      logger.error('Erreur lors de la génération des conseils tactiques', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la génération des conseils tactiques');
    }
  }

  /**
   * Génère une description narrative pour une recherche.
   * @param {string} researchId - ID de la recherche.
   * @returns {Promise<string>} Description narrative.
   */
  async generateResearchDescription(researchId) {
    try {
      const research = await ResearchRepository.getCachedResearchItem(researchId) || 
        await ResearchRepository.getResearchItem(researchId);
      if (!research) throw new NotFoundError('Recherche non trouvée');

      const prompt = `Crée une description narrative immersive pour une recherche scientifique dans Immuno Warriors. Voici les détails :
      - ID : ${research.id}
      - Nom : ${research.name || 'Recherche sans nom'}
      - Description : ${research.description || 'Aucune description'}
      - Progression : ${JSON.stringify(research.progression || {}, null, 2)}
      La description doit capturer l'importance de cette recherche dans la lutte contre les pathogènes, avec un ton scientifique mais engageant.`;

      const description = await this._generateContent(prompt);
      await this._storeResponse(researchId, 'research_description', description);
      logger.info(`Description générée pour la recherche ${researchId}`);
      return description;
    } catch (error) {
      logger.error('Erreur lors de la génération de la description de recherche', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la génération de la description de recherche');
    }
  }

  /**
   * Génère une description narrative pour une base virale.
   * @param {string} baseId - ID de la base virale.
   * @returns {Promise<string>} Description narrative.
   */
  async generateBaseDescription(baseId) {
    try {
      const base = await BaseViraleRepository.getCachedBaseVirale(baseId) || 
        await BaseViraleRepository.getBaseViraleById(baseId);
      if (!base) throw new NotFoundError('Base virale non trouvée');

      const prompt = `Crée une description narrative immersive pour une base virale dans Immuno Warriors. Voici les détails :
      - ID : ${base.id}
      - Niveau : ${base.level || 1}
      - Pathogènes : ${JSON.stringify(base.pathogens || [], null, 2)}
      - Défenses : ${JSON.stringify(base.defenses || [], null, 2)}
      Décris la base comme un bastion stratégique des pathogènes, avec un ton menaçant mais captivant.`;

      const description = await this._generateContent(prompt);
      await this._storeResponse(baseId, 'base_description', description);
      logger.info(`Description générée pour la base virale ${baseId}`);
      return description;
    } catch (error) {
      logger.error('Erreur lors de la génération de la description de base virale', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la génération de la description de base');
    }
  }

  /**
   * Permet une conversation contextuelle avec Gemini, avec accès aux données utilisateur.
   * @param {string} userId - ID de l'utilisateur.
   * @param {string} message - Message de l'utilisateur.
   * @returns {Promise<string>} Réponse de Gemini.
   */
  async chatWithGemini(userId, message) {
    try {
      const user = await UserRepository.getCurrentUser(userId);
      if (!user) throw new NotFoundError('Utilisateur non trouvé');

      const prompt = `Tu es un assistant IA dans Immuno Warriors, un jeu où les joueurs combattent des pathogènes avec des anticorps. Réponds à la requête suivante en te basant sur les données de l'utilisateur et le contexte du jeu :
      - Utilisateur : ${JSON.stringify({ id: user.id, resources: user.resources, progression: user.progression }, null, 2)}
      - Message : ${message}
      Fournis une réponse engageante, précise, et adaptée au contexte du jeu.`;

      const response = await this._generateContent(prompt);
      await this._storeResponse(userId, 'chat_response', response, true);
      logger.info(`Réponse Gemini générée pour l'utilisateur ${userId}`);
      return response;
    } catch (error) {
      logger.error('Erreur lors de la conversation avec Gemini', { error });
      throw error instanceof AppError ? error : new AppError(500, 'Erreur serveur lors de la conversation avec Gemini');
    }
  }

  /**
   * Récupère les réponses Gemini stockées pour un utilisateur ou un contexte.
   * @param {string} userId - ID de l'utilisateur (optionnel).
   * @param {string} type - Type de réponse (ex. combat_chronicle, tactical_advice).
   * @returns {Promise<Array>} Liste des réponses stockées.
   */
  async getStoredResponses(userId, type) {
    try {
      let query = this.responseCollection;
      if (userId) query = query.where('userId', '==', userId);
      if (type) query = query.where('type', '==', type);

      const snapshot = await query.orderBy('createdAt', 'desc').limit(50).get();
      const responses = snapshot.docs.map(doc => fromFirestore(doc.data()));
      logger.info(`Réponses Gemini récupérées pour userId=${userId || 'tous'}, type=${type || 'tous'}`);
      return responses;
    } catch (error) {
      logger.error('Erreur lors de la récupération des réponses stockées', { error });
      throw new AppError(500, 'Erreur serveur lors de la récupération des réponses stockées');
    }
  }

  /**
   * Génère du contenu avec Gemini.
   * @param {string} prompt - Prompt à envoyer.
   * @returns {Promise<string>} Texte généré.
   */
  async _generateContent(prompt) {
    try {
      const result = await model.generateContent(prompt);
      const response = await result.response;
      return response.text();
    } catch (error) {
      logger.error('Erreur lors de l\'appel à l\'API Gemini', { error });
      throw new AppError(500, 'Échec de la génération de contenu par Gemini');
    }
  }

  /**
   * Stocke une réponse Gemini dans Firestore.
   * @param {string} contextId - ID du contexte (combat, recherche, etc.).
   * @param {string} type - Type de réponse.
   * @param {string|Array} content - Contenu de la réponse.
   * @param {boolean} isUserSpecific - Si lié à un utilisateur.
   * @returns {Promise<void>}
   */
  async _storeResponse(contextId, type, content, isUserSpecific = false) {
    try {
      const responseId = uuidv4();
      await this.responseCollection.doc(responseId).set({
        id: responseId,
        contextId,
        type,
        content,
        userId: isUserSpecific ? contextId : null,
        createdAt: formatTimestamp()
      });
      logger.info(`Réponse Gemini stockée : ${responseId}, type=${type}`);
    } catch (error) {
      logger.error('Erreur lors du stockage de la réponse Gemini', { error });
      throw new AppError(500, 'Erreur serveur lors du stockage de la réponse Gemini');
    }
  }
}

module.exports = new GeminiService();