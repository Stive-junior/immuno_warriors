const { GoogleGenerativeAI } = require('@google/generative-ai');
const config = require('../config');


if (!config.geminiApiKey) {
  console.error('ERREUR: La clé API Gemini (GEMINI_API_KEY) n\'est pas configurée dans le fichier .env.');
  process.exit(1);
}

const genAI = new GoogleGenerativeAI(config.geminiApiKey);
const model = genAI.getGenerativeModel({ model: "gemini-pro" });

/**
 * Génère du contenu textuel en utilisant l'API Gemini.
 * @param {string} prompt - Le texte de la requête à envoyer à Gemini.
 * @returns {Promise<string>} Le texte généré par Gemini.
 * @throws {Error} Si l'appel à l'API Gemini échoue.
 */
async function generateContent(prompt) {
  try {
    const result = await model.generateContent(prompt);
    const response = await result.response;
    const text = response.text();
    return text;
  } catch (error) {
    console.error('Erreur lors de l\'appel à l\'API Gemini:', error.message);
    throw new Error('Échec de la génération de contenu par Gemini.');
  }
}

module.exports = { generateContent };
