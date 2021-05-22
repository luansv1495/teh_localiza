import 'package:teh_localiza/modules/localization/domain/entities/localization.validator.dart';
import 'package:teh_localiza/modules/localization/infra/models/localization.model.dart';

abstract class LocalizationDataSourceInterface {
  Future<LocalizationModel> received({
    LocalizationValidator localizationValidator,
  });
  Future<bool> send({
    LocalizationValidator localizationValidator,
  });
  Future<LocalizationModel> get();
  Future<String> getClientUid();
}
