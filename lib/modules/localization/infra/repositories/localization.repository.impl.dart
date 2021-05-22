import 'package:dartz/dartz.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:teh_localiza/modules/localization/domain/entities/localization.entity.dart';
import 'package:teh_localiza/modules/localization/domain/entities/localization.validator.dart';
import 'package:teh_localiza/modules/localization/domain/errors/errors.dart';
import 'package:teh_localiza/modules/localization/domain/repositories/localization.repository.interface.dart';
import 'package:teh_localiza/modules/localization/infra/datasources/localization.datasource.interface.dart';

class LocalizationRepositoryImpl implements LocalizationRepositoryInterface {
  final LocalizationDataSourceInterface localizationDataSourceInterface;

  LocalizationRepositoryImpl({this.localizationDataSourceInterface});

  @override
  Future<Either<Failure, Localization>> received({
    LocalizationValidator localizationValidator,
  }) async {
    try {
      Localization localization =
          await localizationDataSourceInterface.received(
        localizationValidator: localizationValidator,
      );
      return Right(localization);
    } catch (e) {
      return Left(ReceivedError(message: "Erro ao receber localização $e"));
    }
  }

  @override
  Future<Either<Failure, bool>> send({
    LocalizationValidator localizationValidator,
  }) async {
    try {
      bool sended = await localizationDataSourceInterface.send(
        localizationValidator: localizationValidator,
      );
      return Right(sended);
    } on ConnectionException catch (e) {
      return Left(SendError(message: "Erro ao enviar localização por mqtt $e"));
    } catch (e) {
      return Left(SendError(message: "Erro ao enviar localização $e"));
    }
  }

  @override
  Future<Either<Failure, Localization>> get() async {
    try {
      Localization localization = await localizationDataSourceInterface.get();
      return Right(localization);
    } catch (e) {
      return Left(GetError(message: "Erro ao pegar localização $e"));
    }
  }

  @override
  Future<Either<Failure, String>> getClientUid() async {
    try {
      String clientUid = await localizationDataSourceInterface.getClientUid();
      return Right(clientUid);
    } catch (e) {
      return Left(
          GetClientUidError(message: "Erro ao pegar uuid do cliente $e"));
    }
  }
}
