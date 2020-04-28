import 'package:autofystore_app/core/services/WooCommerceService.dart';
import 'package:autofystore_app/core/viewmodels/AppBarModel.dart';
import 'package:autofystore_app/core/viewmodels/CategoriesModel.dart';
import 'package:autofystore_app/core/viewmodels/ProductsByAttributeModel.dart';
import 'package:autofystore_app/core/viewmodels/SearchModel.dart';
import 'package:get_it/get_it.dart';

import 'core/services/SearchService.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
    locator.registerLazySingleton(()=> WooCommerceService());
    locator.registerLazySingleton(()=> SearchService());
    locator.registerFactory(() => ProductsByAttributeModel());
    locator.registerFactory(() => CategoriesModel());
    locator.registerFactory(() => AppBarModel());
    locator.registerFactory(() => SearchModel());
}