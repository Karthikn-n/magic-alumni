import 'package:flutter/material.dart';
import 'package:magic_alumni/app/app.locator.dart';
import 'package:magic_alumni/app/app.router.dart';
import 'package:magic_alumni/service/dio_service.dart';
import 'package:magic_alumni/service/snackbar_service.dart';
import 'package:magic_alumni/ui/theme/app_theme.dart';
import 'package:stacked_services/stacked_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Make sure initialize the locator here for navigation routes
  setupLocator();
  await DioService().init();
  CustomSnackbarService.registerSnackbarService();
  runApp(const MagicAlunmiMobileApp());
}



class MagicAlunmiMobileApp extends StatelessWidget {
  const MagicAlunmiMobileApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'magicalumni',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      navigatorKey: StackedService.navigatorKey,
      /// This will generate the route for the application from [stack_router.dart]
      onGenerateRoute: StackedRouter().onGenerateRoute,
    );
  }
}
/// View -> class that hold the UI view of the app like StatelssWidget or StatefulWidget
/// ViewModel -> class that hold the statechanges and logic of the app
/// Model - class that hold the data of the app
/// Services -> Class that hold the API calls and other services like dialog service, navigation, etc
/// To generate the laucher_icon file run the following command in the terminal `dart run flutter_launcher_icons`