import 'package:chapa_tu_bus_app/account_management/api/auth_api.dart';
import 'package:chapa_tu_bus_app/account_management/application/auth_facade_service.dart';
import 'package:chapa_tu_bus_app/account_management/domain/interfaces/i_auth_repository.dart';
import 'package:chapa_tu_bus_app/account_management/domain/logic/get_current_user.dart';
import 'package:chapa_tu_bus_app/account_management/domain/logic/get_user_profile.dart';
import 'package:chapa_tu_bus_app/account_management/domain/logic/login_backend.dart';
import 'package:chapa_tu_bus_app/account_management/domain/logic/register_backend.dart';
import 'package:chapa_tu_bus_app/account_management/domain/logic/reset_password.dart';
import 'package:chapa_tu_bus_app/account_management/domain/logic/sign_in_with_email_and_password.dart';
import 'package:chapa_tu_bus_app/account_management/domain/logic/sign_in_with_google.dart';
import 'package:chapa_tu_bus_app/account_management/domain/logic/sign_out.dart';
import 'package:chapa_tu_bus_app/account_management/domain/logic/sign_out_backend.dart';
import 'package:chapa_tu_bus_app/account_management/domain/logic/sign_up_with_email_and_password.dart';
import 'package:chapa_tu_bus_app/account_management/domain/logic/update_user_profile.dart';
import 'package:chapa_tu_bus_app/account_management/infrastructure/data/local_database_datasource.dart';
import 'package:chapa_tu_bus_app/account_management/infrastructure/data_sources/backend_auth_datasource.dart';
import 'package:chapa_tu_bus_app/account_management/infrastructure/data_sources/firebase_auth_datasource.dart';
import 'package:chapa_tu_bus_app/account_management/infrastructure/repositories/auth_repository_impl.dart';
import 'package:chapa_tu_bus_app/account_management/presentation/blocs/auth/auth_bloc.dart';
import 'package:chapa_tu_bus_app/account_management/presentation/blocs/profile/profile_bloc.dart';
import 'package:chapa_tu_bus_app/account_management/presentation/blocs/settings/settings_bloc.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/presentation/blocs/gps/gps_bloc.dart';
import 'package:chapa_tu_bus_app/subscriptions/infrastructure/services/payment_service.dart';
import 'package:chapa_tu_bus_app/subscriptions/infrastructure/services/subscription_service.dart';
import 'package:chapa_tu_bus_app/subscriptions/presentation/blocs/subscription/subscription_bloc.dart'; 
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {

  // Account Management
  serviceLocator.registerLazySingleton(() => FirebaseAuthDatasource());
  serviceLocator.registerLazySingleton(() => LocalDatabaseDatasource.instance);
  serviceLocator.registerLazySingleton(() => BackendAuthDatasource());

  // Domain Logic (Use Cases)
  serviceLocator.registerLazySingleton(() => SignInWithEmailAndPassword(authRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(() => SignInWithGoogle(authRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(() => SignUpWithEmailAndPassword(authRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(() => SignOut(authRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(() => ResetPassword(authRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetCurrentUser(authRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(() => UpdateUserProfile(authRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(() => SignOutBackend(authRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(() => LoginBackend(authRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(() => RegisterBackend(authRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetUserProfile(authRepository: serviceLocator()));

  

  // Repository
  serviceLocator.registerLazySingleton<IAuthRepository>(
      () => AuthRepositoryImpl(
            firebaseAuthDatasource: serviceLocator(),
            localDatabaseDatasource: serviceLocator(), 
            backendAuthDatasource: serviceLocator(),
          ));

  // Application Layer
  serviceLocator.registerLazySingleton(
    () => AuthFacadeService(
      authRepository: serviceLocator(),
      signInWithEmailAndPassword: serviceLocator(),
      signInWithGoogle: serviceLocator(),
      signUpWithEmailAndPassword: serviceLocator(),
      signOut: serviceLocator(),
      resetPassword: serviceLocator(),
      getCurrentUser: serviceLocator(), 
      updateUserProfile: serviceLocator(), 
      signOutBackend: serviceLocator(), 
      loginBackend: serviceLocator(), 
      registerBackend: serviceLocator(), 
      getUserProfile: serviceLocator(),

    ),
  );

  // API (Facade)
  serviceLocator.registerLazySingleton(() => AuthApi());

  // BLoC
  serviceLocator.registerFactory(() => AuthBloc(authFacadeService: serviceLocator()));

  serviceLocator.registerFactory(() => ProfileBloc(authApi: serviceLocator()));

  serviceLocator.registerFactory(() => SettingsBloc(authFacadeService: serviceLocator()));

  serviceLocator.registerFactory(() => SubscriptionBloc(subscriptionService: serviceLocator()));

  // Execution Monitoring

  // BLoC
  serviceLocator.registerFactory(() => GpsBloc());

  serviceLocator.registerFactory(() => PaymentService());

  serviceLocator.registerFactory(() => SubscriptionService());


}