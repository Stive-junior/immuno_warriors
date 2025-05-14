import 'package:immuno_warriors/domain/repositories/user_repository.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';

class RegenerateResourcesUseCase {
  final UserRepository _userRepository;

  RegenerateResourcesUseCase(this._userRepository);

  Future<void> execute(Map<String, int> regenerationRates, int deltaTime) async {
    try {
      final currentResources = await _userRepository.getUserResources();
      final updatedResources = Map<String, int>.from(currentResources);

      regenerationRates.forEach((resource, rate) {
        if (updatedResources.containsKey(resource)) {
          updatedResources[resource] = (updatedResources[resource]! + (rate * deltaTime)).clamp(0, 99999999);
        }
      });

      await _userRepository.updateUserResources(updatedResources);
    } catch (e) {
      AppLogger.error('Error regenerating resources: $e');
      rethrow;
    }
  }
}