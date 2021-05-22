import 'package:dartz/dartz.dart';
import 'package:teh_localiza/modules/localization/domain/entities/localization.entity.dart';
import 'package:teh_localiza/modules/localization/domain/errors/errors.dart';
import 'package:teh_localiza/modules/localization/domain/repositories/localization.repository.interface.dart';

mixin GetUseCase {
  Future<Either<Failure, Localization>> call();
}

class GetUseCaseImpl implements GetUseCase {
  final LocalizationRepositoryInterface repository;

  GetUseCaseImpl({this.repository});

  @override
  Future<Either<Failure, Localization>> call() async {
    return await repository.get();
  }
}
