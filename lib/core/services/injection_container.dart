import 'package:dio/dio.dart';
import 'package:vault_kit/vault_kit.dart';
import 'package:get_it/get_it.dart';
import '../../core/dio_client/dio_client.dart';
import '../../core/services/navigator_service.dart';
import '../../core/storage/cashhelper.dart';
import '../../core/storage/secure_storage_helper.dart';
import '../../features/standard_features/localization/data/datasources/lang_local_data_source.dart';
import '../../features/standard_features/localization/data/repositories/lang_repository_impl.dart';
import '../../features/standard_features/localization/domain/repositories/lang_repository.dart';
import '../../features/standard_features/localization/domain/usecases/change_lang.dart';
import '../../features/standard_features/localization/domain/usecases/get_saved_lang.dart';
import '../../features/standard_features/localization/presentation/cubit/locale_cubit.dart';
import '../../features/standard_features/theme/presentation/cubit/theme_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/category/presentation/controller/category_cubit/category_cubit.dart';
import '../../features/category/domain/usecases/get_categories_usecase.dart';
import '../../features/category/domain/repositories/get_categories_repo_base.dart';
import '../../features/category/data/repositories/get_categories_repo_impl.dart';
import '../../features/category/data/data_sources/get_categories_remote_ds.dart';
import '../../features/category/domain/usecases/get_category_by_id_usecase.dart';
import '../../features/category/domain/repositories/get_category_by_id_repo_base.dart';
import '../../features/category/data/repositories/get_category_by_id_repo_impl.dart';
import '../../features/category/data/data_sources/get_category_by_id_remote_ds.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  //! Features

  // Category
  /// -----CategoryCubit------
  sl.registerFactory<CategoryCubit>(
    () => CategoryCubit(
      kGetCategoryByIdUseCase: sl(),
      kGetCategoriesUseCase: sl(),
    ),
  );

  /// --------useCases----------
  sl.registerLazySingleton<GetCategoryByIdUseCase>(
    () => GetCategoryByIdUseCase(baseRepository: sl()),
  );
  sl.registerLazySingleton<GetCategoriesUseCase>(
    () => GetCategoriesUseCase(baseRepository: sl()),
  );

  /// --------Repository--------
  sl.registerLazySingleton<GetCategoryByIdBaseRepository>(
    () => GetCategoryByIdRepository(sl()),
  );
  sl.registerLazySingleton<GetCategoriesBaseRepository>(
    () => GetCategoriesRepository(sl()),
  );

  /// --------DataSource--------
  sl.registerLazySingleton<GetCategoryByIdBaseRemoteDataSource>(
    () => GetCategoryByIdRemoteDataSource(sl<DioClient>()),
  );
  sl.registerLazySingleton<GetCategoriesBaseRemoteDataSource>(
    () => GetCategoriesRemoteDataSource(sl<DioClient>()),
  );

  // localization
  /// -----localizationCubit------
  sl.registerFactory<LocaleCubit>(
    () => LocaleCubit(getSavedLangUseCase: sl(), changeLangUseCase: sl()),
  );

  // theme
  sl.registerFactory<ThemeCubit>(() => ThemeCubit(cashHelper: sl()));

  /// --------useCases----------
  sl.registerLazySingleton<ChangeLangUseCase>(
    () => ChangeLangUseCase(langRepository: sl()),
  );
  sl.registerLazySingleton<GetSavedLangUseCase>(
    () => GetSavedLangUseCase(langRepository: sl()),
  );

  /// --------Repository--------
  sl.registerLazySingleton<LangRepository>(
    () => LangRepositoryImpl(langLocalDataSource: sl()),
  );

  /// --------DataSource--------
  sl.registerLazySingleton<LangLocalDataSource>(
    () => LangLocalDataSourceImpl(),
  );
  // cart
  /// -----CartCubit------
  ///
  // sl.registerFactory<CartCubit>(
  //   () => CartCubit(
  //     kGetCartItemsUseCase: sl(),
  //     kAddToCartUseCase: sl(),
  //     kDeleteCartItemUseCase: sl(),
  //   ),
  // );

  /// --------useCases----------
  // sl.registerLazySingleton<AddToCartUseCase>(
  //   () => AddToCartUseCase(baseRepository: sl()),
  // );
  // sl.registerLazySingleton<DeleteCartItemUseCase>(
  //   () => DeleteCartItemUseCase(baseRepository: sl()),
  // );

  /// --------Repository--------
  // sl.registerLazySingleton<AddToCartBaseRepository>(
  //   () => AddToCartRepository(sl()),
  // );
  // sl.registerLazySingleton<DeleteCartItemBaseRepository>(
  //   () => DeleteCartItemRepository(sl()),
  // );

  /// --------DataSource--------
  // sl.registerLazySingleton<AddToCartBaseRemoteDataSource>(
  //   () => AddToCartRemoteDataSource(),
  // );
  // sl.registerLazySingleton<DeleteCartItemBaseRemoteDataSource>(
  //   () => DeleteCartItemRemoteDataSource(),
  // );

  //! Core

  /// --------------------------
  /// External
  /// --------------------------

  /// --------------------------
  /// Local Storage
  /// --------------------------

  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
  sl.registerLazySingleton<CashHelper>(
    () => CashHelper(sl<SharedPreferences>()),
  );

  final vault = VaultKit();
  sl.registerLazySingleton<SecureStorageHelper>(
    () => SecureStorageHelper(vault),
  );

  /// --------------------------
  /// Network (Dio)
  /// --------------------------
  sl.registerLazySingleton<DioClient>(() => DioClient(Dio()));

  // Register NavigatorService as singleton
  sl.registerLazySingleton<NavigatorService>(() => NavigatorService());
}
