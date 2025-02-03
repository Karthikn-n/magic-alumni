
import 'package:magic_alumni/service/api_service.dart';
import 'package:magic_alumni/service/authenticate_service.dart';
import 'package:magic_alumni/service/dio_service.dart';
import 'package:magic_alumni/service/encrption_service.dart';
import 'package:magic_alumni/service/onesignal_service.dart';
import 'package:magic_alumni/ui/views/app-view/app_view.dart';
import 'package:magic_alumni/ui/views/events/create-event/create_event_view.dart';
import 'package:magic_alumni/ui/views/events/event_detail.dart';
import 'package:magic_alumni/ui/views/jobs/jobs_view.dart';
import 'package:magic_alumni/ui/views/news/news_detail_view.dart';
import 'package:magic_alumni/ui/views/notifications/notification_view.dart';
import 'package:magic_alumni/ui/views/payment/payment_view.dart';
import 'package:magic_alumni/ui/views/signup/signup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import '../ui/views/jobs/create-job/create_job_view.dart';
import '../ui/views/login/login_view.dart';
/// Create a sample class the serves no purpose to the app besides housing the annotation 
/// That help to generate the required functinalities for the app
/// First and everytime updating this file, run the command: dart run build_runner build --delete-conflicting-outputs
/// this will get updated route files
@StackedApp(
  // Put all the routes for the app here (views class)
  routes: [
    MaterialRoute(page: SignupView),
    MaterialRoute(page: AppView),
    MaterialRoute(page: LoginView, initial: true),
    MaterialRoute(page: CreateEventView),
    MaterialRoute(page: CreateJobView),
    MaterialRoute(page: EventsDetailView),
    MaterialRoute(page: JobsView),
    MaterialRoute(page: NewsDetailView),
    MaterialRoute(page: NotificationsView),
    MaterialRoute(page: PaymentView),
  ],
  dependencies: [
    // Built-In Services
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    // Custom Services
    LazySingleton(classType: DioService),
    LazySingleton(classType: EncryptionService),
    LazySingleton(classType: AuthenticateService),
    LazySingleton(classType: ApiService),
    LazySingleton(classType: OnesignalService),
  ],
  logger: StackedLogger(),
)
class AppSetup{
  /** 
    This class has no puporse besides housing the 
    annotation that generates the required functionality 
  **/
}
// View for the UI 
// View model for the functionalities for the UI changes