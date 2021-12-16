import 'package:get_it/get_it.dart';
import 'package:imagecaptioning/src/prefs/app_prefs.dart';
import 'package:injectable/injectable.dart';

import 'get_it.config.dart';

GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt', // default
  preferRelativeImports: true, // default
  asExtension: false, // default
)
Future<GetIt> configureDependencies() => $initGetIt(getIt);

// @module
// abstract class StackedServicesModule {
//   @lazySingleton
//   NavigationService get navigationService;
//   @lazySingleton
//   DialogService get dialogService;
//   @lazySingleton
//   SnackbarService get snackBarService;
//   @lazySingleton
//   BottomSheetService get bottomSheetService;
// }

//khoi tao app pref trc khi build UI de sau nay goi ko can khoi tao lai
@module
abstract class AppModule {
  @preResolve
  Future<AppPref> get appPrefs => AppPref.instance();
}
