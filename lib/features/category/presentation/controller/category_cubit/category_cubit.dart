import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/entities/get_category_by_id_entity.dart';
import '../../../domain/usecases/get_category_by_id_usecase.dart';
import 'category_states.dart';
import '../../../domain/entities/get_categories_entity.dart';
import '../../../domain/usecases/get_categories_usecase.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final GetCategoryByIdUseCase kGetCategoryByIdUseCase;

  final GetCategoriesUseCase kGetCategoriesUseCase;

  CategoryCubit({
    required this.kGetCategoryByIdUseCase,
    required this.kGetCategoriesUseCase,
  }) : super(CategoryInitialState());

  static CategoryCubit get(context) => BlocProvider.of<CategoryCubit>(context);
  GetCategoryByIdResponseEntity? getCategoryByIdResponseEntity;
  void getCategoryByIdMethod({required String categoryId}) async {
    emit(GetCategoryByIdLoadingState());

    final response = await kGetCategoryByIdUseCase(
      GetCategoryByIdParameters(categoryId: categoryId),
    );

    response.fold(
      (failure) {
        debugPrint('Failure: GetCategoryByIdErrorState');
        emit(GetCategoryByIdErrorState());
      },
      (r) {
        getCategoryByIdResponseEntity = r;
        debugPrint('Success: ${r.message}');
        emit(GetCategoryByIdSucssesState(message: r.message!));
      },
    );
  }

  GetCategoriesResponseEntity? getCategoriesResponseEntity;
  void getCategoriesMethod() async {
    emit(GetCategoriesLoadingState());

    final response = await kGetCategoriesUseCase(GetCategoriesParameters());

    response.fold(
      (failure) {
        debugPrint('Failure: GetCategoriesErrorState');
        emit(GetCategoriesErrorState());
      },
      (r) {
        getCategoriesResponseEntity = r;
        debugPrint('Success: ${r.message}');
        emit(GetCategoriesSucssesState(message: r.message ?? ''));
      },
    );
  }
}
