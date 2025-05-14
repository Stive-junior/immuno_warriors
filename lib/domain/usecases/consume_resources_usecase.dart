import 'package:immuno_warriors/domain/repositories/user_repository.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

class ConsumeResourcesUseCase {
  final UserRepository _userRepository;

  ConsumeResourcesUseCase(this._userRepository);

  Future<void> execute(Map<String, int> resourcesToConsume) async {
    try {
      final currentResources = await _userRepository.getUserResources();
      final updatedResources = Map<String, int>.from(currentResources);

      resourcesToConsume.forEach((resource, amount) {
        if (updatedResources.containsKey(resource)) {
          updatedResources[resource] = (updatedResources[resource]! - amount).clamp(0, 99999999);
        } else {
          throw ArgumentError('Resource $resource does not exist.');
        }
      });

      await _userRepository.updateUserResources(updatedResources);
    } catch (e) {
      AppLogger.error('Error consuming resources: $e');
      rethrow;
    }
  }
}