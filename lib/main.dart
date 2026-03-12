import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_standred/core/config/locale/app_localizations_setup.dart';
import 'package:new_standred/core/services/injection_container.dart';
import 'package:new_standred/core/services/injection_container.dart' as di;
import 'package:new_standred/core/services/navigator_service.dart';
import 'package:new_standred/core/utils/app_constants.dart';
import 'package:new_standred/features/error/presentation/screens/error_screen.dart';
import 'package:new_standred/features/localization/presentation/cubit/locale_cubit.dart';
import 'package:new_standred/no-internet/no_internet.dart';
import 'package:new_standred/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    // Handle missing .env file gracefully in development
    if (kDebugMode) print("Warning: .env file not found");
  }

  await initDependencies();
  // SecurityService.isEnabled = false;
  // Global Error Handling for UI
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return ErrorScreen(errorDetails: details);
  };

  // Global Error Handling for Framework
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    // Add custom logging here if needed (e.g. Sentry)
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<LocaleCubit>()..getSavedLang()),
        BlocProvider(create: (context) => ConnectivityCubit()),
      ],
      child: BlocBuilder<LocaleCubit, LocaleState>(
        buildWhen: (previousState, currentState) {
          return previousState != currentState;
        },
        builder: (context, state) {
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp(
                navigatorKey: sl<NavigatorService>().navigatorKey,
                debugShowCheckedModeBanner: false,
                title: 'Standard Repo',
                locale: state.locale,
                supportedLocales: AppLocalizationsSetup.supportedLocales,
                localeResolutionCallback:
                    AppLocalizationsSetup.localeResolutionCallback,
                localizationsDelegates:
                    AppLocalizationsSetup.localizationsDelegates,
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                  fontFamily: AppConstants.fontFamily,
                ),
                initialRoute: AppRoutes.splash,
                onGenerateRoute: AppRoutes.generateRoute,
                builder: (context, child) {
                  return NoInternetHandler(child: child!);
                },
              );
            },
          );
        },
      ),
    );
  }
}
