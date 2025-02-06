import 'package:flutter_test/flutter_test.dart';
import 'package:magic_alumni/ui/views/login/login_viewmodel.dart';
import '../../mocks.dart'; 

void main() {
  late LoginViewmodel viewModel;

  setUpAll(() {
    registerServices();

    // Create ViewModel with mocked dependencies
    viewModel = LoginViewmodel()
      ..init();

    // Inject mock dependencies (if using get_it, register them here)
  });

  test("Initial values should be correct", () {
    expect(viewModel.isAccountVerified, false);
    expect(viewModel.isOTPVerified, false);
    expect(viewModel.isLoading, false);
    expect(viewModel.isMobileAdded, false);
    expect(viewModel.isOtpAdded, false);
  });

  test("Mobile number validation should update `isMobileAdded`", () {
    viewModel.mobileController.text = "1234567890";
    viewModel.init();
    expect(viewModel.isMobileAdded, true);
  });

  test("OTP validation should update `isOtpAdded`", () {
    viewModel.otpController.text = "123456"; 
    viewModel.init();
    expect(viewModel.isOtpAdded, true);
  });

  test("Account verification should update state", () {
    viewModel.verifyAccount();
    expect(viewModel.isAccountVerified, true);
  });

  test("OTP verification should update state", () {
    viewModel.verifiedOTP();
    expect(viewModel.isOTPVerified, true);
  });


  test("Timer should decrease time", () {
    viewModel.startTimer();
    expect(viewModel.isResendClicked, true);

    Future.delayed(Duration(seconds: 1), () {
      expect(viewModel.time, lessThan(30));
    });
  });

}
