import 'package:dartz/dartz.dart';
import 'package:new_standred/core/base_usecase/base_usecase.dart';
import 'package:new_standred/features/standard_features/localization/domain/repositories/lang_repository.dart';


class ChangeLangUseCase implements BaseUseCase<bool, String> {
  final LangRepository langRepository;

  ChangeLangUseCase({required this.langRepository});

  @override
  Future<Either<dynamic, bool>> call(String langCode) async =>
      await langRepository.changeLang(langCode: langCode);
}
