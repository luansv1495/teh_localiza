import 'package:dartz/dartz.dart';
import 'package:teh_localiza/modules/localization/domain/entities/localization.entity.dart';
import 'package:teh_localiza/modules/localization/domain/entities/localization.validator.dart';
import 'package:teh_localiza/modules/localization/domain/errors/errors.dart';

abstract class LocalizationRepositoryInterface {
  Future<Either<Failure, Localization>> received({
    LocalizationValidator localizationValidator,
  });
  Future<Either<Failure, bool>> send({
    LocalizationValidator localizationValidator,
  });
  Future<Either<Failure, Localization>> get();
  Future<Either<Failure, String>> getClientUid();
}
