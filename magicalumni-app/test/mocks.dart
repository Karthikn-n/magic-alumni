import 'package:magic_alumni/app/app.locator.dart';
import 'package:magic_alumni/service/api_service.dart';
import 'package:mockito/annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import 'mocks.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<NavigationService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<SnackbarService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<DialogService>(onMissingStub: OnMissingStub.returnDefault),
])
void registerServices(){
  getAndRegisterNavigationService();
  getAndRegisterSnackbarService();
  getAndRegisterDialogService();
  getAndResgiterApiService();
}


MockNavigationService getAndRegisterNavigationService() {
  _removeRegistrationIfExists<NavigationService>();
  final service = MockNavigationService();
  locator.registerSingleton<NavigationService>(service);
  return service;
}

MockSnackbarService getAndRegisterSnackbarService() {
  _removeRegistrationIfExists<NavigationService>();
  final service = MockSnackbarService();
  locator.registerSingleton<SnackbarService>(service);
  return service;
}

MockDialogService getAndRegisterDialogService() {
  _removeRegistrationIfExists<NavigationService>();
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

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}