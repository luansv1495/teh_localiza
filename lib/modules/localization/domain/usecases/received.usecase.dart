import 'package:dartz/dartz.dart';
import 'package:teh_localiza/modules/localization/domain/entities/localization.entity.dart';
import 'package:teh_localiza/modules/localization/domain/entities/localization.validator.dart';
import 'package:teh_localiza/modules/localization/domain/errors/errors.dart';
import 'package:teh_localiza/modules/localization/domain/repositories/localization.repository.interface.dart';

mixin ReceivedUseCase {
  Future<Either<Failure, Localization>> call({
    LocalizationValidator localizationValidator,
  });
}

class ReceivedUseCaseImpl implements ReceivedUseCase {
  final LocalizationRepositoryInterface repository;

  ReceivedUseCaseImpl({this.repository});

  @override
  Future<Either<Failure, Localization>> call({
    LocalizationValidator localizationValidator,
  }) async {
    if (!localizationValidator.isValidLatitude) {
      return Left(
        ReceivedError(message: "Latitude inválida."),
      );
    }

    if (!localizationValidator.isValidLongitude) {
      return Left(
        ReceivedError(message: "Longitude inválida."),
      );
    }

    if (!localizationValidator.isValidCreatedAt) {
      return Left(
        ReceivedError(message: "Data de criação inválida."),
      );
    }

    if (!localizationValidator.isValidclientUid) {
      return Left(
        ReceivedError(message: "Client uuid inválido."),
      );
    }

    return await repository.received(
      localizationValidator: localizationValidator,
    );
  }
}
