import 'package:flutter_test/flutter_test.dart';
import 'package:magic_alumni/service/api_service.dart';
import 'package:magic_alumni/ui/views/app-view/app_viewmodel.dart';


import 'package:mockito/mockito.dart';

import '../../mocks.dart';

class MockApiService extends Mock implements ApiService {}

void main(){
  late AppViewModel appViewModel;

  setUp((){
    registerServices();
    appViewModel = AppViewModel();
  });

  test("Tapped Index 2", () {
    appViewModel.onTapped(2);
    expect(appViewModel.index, 2);
  },);
}