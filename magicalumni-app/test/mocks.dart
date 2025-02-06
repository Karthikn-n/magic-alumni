import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:magic_alumni/app/app.locator.dart';
import 'package:magic_alumni/service/api_service.dart';
import 'package:magic_alumni/service/authenticate_service.dart';
import 'package:magic_alumni/ui/views/app-view/app_viewmodel.dart';
import 'package:mockito/annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import 'mocks.mocks.dart';

@GenerateMocks([
  AppViewModel,
  FlutterSecureStorage
], 
customMocks: [
  MockSpec<NavigationService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<SnackbarService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<DialogService>(onMissingStub: OnMissingStub.returnDefault),
])
void registerServices(){
  getAndRegisterNavigationService();
  getAndRegisterSnackbarService();
  getAndRegisterDialogService();
  getAndResgiterApiService();
  getAndResgiterAuthenticateService();
}


MockNavigationService getAndRegisterNavigationService() {
  _removeRegistrationIfExists<NavigationService>();
  final service = MockNavigationService();
  locator.registerSingleton<NavigationService>(service);
  return service;
}

MockSnackbarService getAndRegisterSnackbarService() {
  _removeRegistrationIfExists<SnackbarService>();
  final service = MockSnackbarService();
  locator.registerSingleton<SnackbarService>(service);
  return service;
}

MockDialogService getAndRegisterDialogService() {
  _removeRegistrationIfExists<DialogService>();
  final service = MockDialogService();
  locator.registerSingleton<DialogService>(service);
  return service;
}

ApiService getAndResgiterApiService(){
  _removeRegistrationIfExists<ApiService>();
  final service = ApiService();
  locator.registerSingleton<ApiService>(service);
  return service;
}

AuthenticateService getAndResgiterAuthenticateService(){
  _removeRegistrationIfExists<AuthenticateService>();
  final service = AuthenticateService();
  locator.registerSingleton<AuthenticateService>(service);
  return service;
}

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}