import 'package:flutter_test/flutter_test.dart';
import 'package:magic_alumni/ui/views/profile/profile_viewmodel.dart';
import '../../mocks.dart';

void main(){
  TestWidgetsFlutterBinding.ensureInitialized();
  late ProfileViewmodel viewmodel;
  setUpAll(() {
    registerServices();
    viewmodel = ProfileViewmodel();
  },);

  group("Profile viewmodel initial test", () {
      test("Profile properties", () {
        expect(viewmodel.collegesList.length, 0);
        expect(viewmodel.isCollegNameValid, false);
        expect(viewmodel.isUserNameValid, false);
        expect(viewmodel.isdepNameValid, false);
        expect(viewmodel.isYearValid, false);
        expect(viewmodel.isLinkedInUrlValid, false);
        expect(viewmodel.isCurrentYearStudent, false);
        expect(viewmodel.isFormValid, false);
        expect(viewmodel.selectedCollege, null);
        expect(viewmodel.selectedDepartment, null);
        expect(viewmodel.alumni, null);
    },);

    test("Test field properties", () {
      expect(viewmodel.userNameController.text, "");
      expect(viewmodel.collegeNameController.text, "");
      expect(viewmodel.depNameController.text, "");
      expect(viewmodel.currentOrCcyController.text, "");
      expect(viewmodel.linkedUrlController.text, "");
      expect(viewmodel.mobileController.text, "");
      expect(viewmodel.emailController.text, "");       
      expect(viewmodel.designationController.text, "");

      viewmodel.init();

      expect(viewmodel.userNameController.text, "Raj kumar");
      expect(viewmodel.collegeNameController.text, "ABC College");
      expect(viewmodel.depNameController.text, "Computer Science");
      expect(viewmodel.currentOrCcyController.text, "2024");
      expect(viewmodel.linkedUrlController.text, "https://linkedin.com/in/rajkumar");
      expect(viewmodel.mobileController.text, "8957859299");
      expect(viewmodel.emailController.text, "rajkumar@gmail.com");       
      expect(viewmodel.designationController.text, "Software Developer");
    },);
  },);

}