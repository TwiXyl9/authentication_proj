import 'package:authentication_proj/helpers/navigation_helper.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator(){
  locator.registerLazySingleton(() => NavigationHelper());
}