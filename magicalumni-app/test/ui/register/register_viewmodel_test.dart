import 'package:flutter_test/flutter_test.dart';
import 'package:magic_alumni/ui/views/signup/signup_viewmodel.dart';

import '../../mocks.dart';


void main(){
  late SignupViewmodel viewmodel;
  // late MockApiService apiService;
  setUpAll(() {
    registerServices();
    viewmodel = SignupViewmodel();
  },);

  test("Initial Registration test", () {
    expect(viewmodel.collegesList.length, 0);
    expect(viewmodel.isCollegNameValid, false);
    expect(viewmodel.isLoading, false);
    expect(viewmodel.isUserNameValid, false);
    expect(viewmodel.isdepNameValid, false);
    expect(viewmodel.isYearValid, false);
    expect(viewmodel.isLinkedInUrlValid, false);
    expect(viewmodel.isCurrentYearStudent, false);
    expect(viewmodel.isFormValid, false);
    expect(viewmodel.selectedCollege, null);
    expect(viewmodel.selectedDepartment, null);
  },);

}