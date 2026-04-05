import 'package:new_standred/core/utils/app_logger.dart';
import 'package:new_standred/core/utils/app_strings.dart';
import 'package:new_standred/features/standard_features/localization/domain/usecases/change_lang.dart';
import 'package:new_standred/features/standard_features/localization/domain/usecases/get_saved_lang.dart';
import 'package:new_standred/core/config/locale/app_localizations.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_standred/features/standard_features/localization/domain/usecases/no_parameter.dart';

part 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  final GetSavedLangUseCase getSavedLangUseCase;
  final ChangeLangUseCase changeLangUseCase;
  LocaleCubit({
    required this.getSavedLangUseCase,
    required this.changeLangUseCase,
  }) : super(const ChangeLocaleState(Locale(AppStrings.englishCode)));

  String currentLangCode = AppStrings.englishCode;

  Future<void> getSavedLang() async {
    final response = await getSavedLangUseCase.call(NoParemeters());
    response.fold((failure) => AppLogger.handleLogs(AppStrings.cacheFailure), (
      value,
    ) async {
      currentLangCode = value;
      AppStrings.currentLang = value;
      final locale = Locale(currentLangCode);
      await AppLocalizations.init(locale);
      emit(ChangeLocaleState(locale));
    });
  }

  Future<void> _changeLang(String langCode) async {
    final response = await changeLangUseCase.call(langCode);
    response.fold((failure) => AppLogger.handleLogs(AppStrings.cacheFailure), (
      value,
    ) {
      currentLangCode = langCode;
      AppStrings.currentLang = langCode;

      emit(ChangeLocaleState(Locale(currentLangCode)));
    });
  }

  void toEnglish() => _changeLang(AppStrings.englishCode);

  void toArabic() => _changeLang(AppStrings.arabicCode);
}
