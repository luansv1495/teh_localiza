import 'package:dartz/dartz.dart';
import 'package:teh_localiza/modules/localization/domain/errors/errors.dart';
import 'package:teh_localiza/modules/localization/domain/repositories/localization.repository.interface.dart';

mixin GetClientUidUseCase {
  Future<Either<Failure, String>> call();
}

class GetClientUidUseCaseImpl implements GetClientUidUseCase {
  final LocalizationRepositoryInterface repository;

  GetClientUidUseCaseImpl({this.repository});

  @override
  Future<Either<Failure, String>> call() async {
    return await repository.getClientUid();
  }
}
