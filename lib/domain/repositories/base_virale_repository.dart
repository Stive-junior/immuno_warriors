import 'package:immuno_warriors/domain/entities/base_virale_entity.dart'; // Assurez-vous d'avoir cette entité

abstract class BaseViraleRepository {
  Future<BaseViraleEntity?> getBaseViraleById(String id);

  Future<void> createBaseVirale(BaseViraleEntity baseVirale);

  Future<void> updateBaseVirale(BaseViraleEntity baseVirale);

  Future<List<BaseViraleEntity>> getBaseViralesForPlayer(String playerId);

  Future<List<BaseViraleEntity>> getAllBaseVirales(); // Ajouté pour la complétude

  Future<void> deleteBaseVirale(String id); // Ajouté pour la complétude
}