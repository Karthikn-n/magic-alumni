import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks.dart';
import '../../mocks.mocks.dart';


void main(){
  late MockAppViewModel appViewModel;

  setUpAll((){
    registerServices();
    appViewModel = MockAppViewModel();
  });

  group("App Viewmodel Test", () {
    test("Tapped Index 2", () {
      when(appViewModel.index).thenReturn(2);
      appViewModel.onTapped(2);
      expect(appViewModel.index, 2);
    },);

    test("Tapped Index 3", () {
      when(appViewModel.index).thenReturn(3);
      appViewModel.onTapped(3);
      expect(appViewModel.index, 3);
    },);
    
  },);
}