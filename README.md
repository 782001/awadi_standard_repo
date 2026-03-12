# Flutter Utilities Boilerplate

This is a **ready-to-use Flutter utilities setup** that simplifies common tasks such as:


- Localization (translations)
- SharedPreferences management
- Dio setup for APIs
- Navigation without context
- App-wide constants
- flutter_launcher_icons
It’s modular and can be copied into any Flutter project.

---
**Usage anywhere:**

```dart
final cashHelper = sl<CashHelper>();
final dio = sl<DioClient>();
final navigator = sl<NavigatorService>();
------------Navigation--------
  nav().pushNamed(Routes.authWelcomeScreen);
------------Translation----------
AppStrings.login.tr()
```

## 1️⃣ NavigatorService

✅✅A singleton service to handle **navigation from anywhere** in the app, without needing `BuildContext`.
it added to getIt in injectionContainer.dart
```dart
import 'package:flutter/material.dart';
NavigatorService nav() => sl<NavigatorService>();
class NavigatorService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  BuildContext get context => navigatorKey.currentContext!;
}

final navigator = NavigatorService();
```

**Usage:**

```dart
  nav().pushNamed(Routes.authWelcomeScreen);

// Or use helper for context
navigator.navigatorKey.currentState!.pushNamed(Routes.authWelcomeScreen);
// Or use helper for context
navigator.context;
```

---

## 2️⃣ CashHelper (SharedPreferences)
✅✅  it added to getIt in injectionContainer.dart
Wrapper around SharedPreferences for easy access and consistent use.

```dart
import 'package:shared_preferences/shared_preferences.dart';

class CashHelper {
  final SharedPreferences sharedPreferences;

  CashHelper(this.sharedPreferences);

  dynamic getData({required String key}) => sharedPreferences.get(key);
  bool? getBoolData({required String key}) => sharedPreferences.getBool(key);
  Future<bool> saveData({required String key, required dynamic value}) async {
 if (value is String) {
      if (key == 'token') {
       **--- i do this to make token saved in ApiConstance.userToken **  
**Usage:**
can access it  ApiConstance.userToken;

        ApiConstance.userToken = value as String? ?? '';

      }
      return await sharedPreferences.setString(key, value);
    }    if (value is int) return sharedPreferences.setInt(key, value);
    if (value is bool) return sharedPreferences.setBool(key, value);
    if (value is double) return sharedPreferences.setDouble(key, value);
    throw UnsupportedError('Unsupported type');
  }

  Future<bool> removeData({required String key}) => sharedPreferences.remove(key);
  Future<bool> clearAll() => sharedPreferences.clear();
}
```

**Usage:**

```dart
final token = sl<CashHelper>().getData(key: 'token');
await sl<CashHelper>().saveData(key: 'token', value: 'abc123');
```

---

## 3️⃣ Dio Setup

Centralized network client for API requests.

```dart
import 'package:dio/dio.dart';

class DioClient {
  DioClient(this._dio) {
    _dio
      ..options.baseUrl = Endpoint.apiBaseUrl
      ..options.connectTimeout = Endpoint.connectionTimeout
      ..options.receiveTimeout = Endpoint.receiveTimeout
      ..options.responseType = ResponseType.json;

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.headers[ApiKeys.contentType] = 'application/json';
          options.headers[ApiKeys.accept] = 'application/json';
          كمان بتبعت اللغه & التوكين تلقائي مع الريكويست
          يعني مش محتاج ابعتهم مع  الريكويست كل مره
     final lang =
              sl<CashHelper>().getData(key: AppStrings.locale) ??
              AppStrings.currentLang;
          options.headers[ApiKeys.acceptLanguage] = lang;

          final token = AppStrings.userToken;
          options.headers[ApiKeys.authorization] = 'Bearer $token';
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (error, handler) {
          return handler.next(error);
        },
      ),
    );
    // 🐛 Logger
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
      ),
    );
  }




 
```

**Usage:**


1️⃣1️⃣**Usage:**1️⃣1️⃣:
```dart
 Directly from GetIt
final dio = sl<DioClient>();
final response = await dio.get('/users');
```

2️⃣2️⃣**Usage:**2️2️
او ممكن نخلي الكونستراكتور ياخدها لما نستدعي الريموت داتا سورس جوه  الinjection_container.dart

 Passing Dio to Remote Data Source via Injection Container
```dart
class AddToCartRemoteDataSource extends AddToCartBaseRemoteDataSource {
  final DioClient dio;


  AddToCartRemoteDataSource(this.dio);


  Future<void> addItem(Map<String, dynamic> data) async {
    final response = await dio.post('/cart/add', data: data);
    // handle response
  }
}


// In injection_container.dart
sl.registerLazySingleton(() => AddToCartRemoteDataSource(sl<DioClient>()));

✅ Now every request automatically includes the user's language and token headers without manually setting them each time.

```

---

## 4️⃣ GetIt Dependency Injection

All services are registered with **GetIt** for easy access anywhere.

```dart
final sl = GetIt.instance;

Future<void> init() async {
  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
  sl.registerLazySingleton<CashHelper>(
    () => CashHelper(sl<SharedPreferences>()),
  );
  sl.registerLazySingleton<DioClient>(() => DioClient(Dio()));
  sl.registerLazySingleton(() => NavigatorService());
}
```



---

## ✅ Advantages

- Centralized navigation, storage, API, and translation
- Shortcut methods for cleaner code
- Reusable in any Flutter project
- Hot Restart Friendly
- Easy to maintain constants in `AppStrings`

---

## 6️⃣ Recommended Folder Structure

```
lang/
  ├─ ar.json
  ├─ en.json
lib/
├─ core/
│  ├─ dio_client/
│  │  ├─ dio_client.dart
│  ├─ storage/
│  │  ├─ cashhelper.dart
│  ├─ services/
│  │  ├─ injection_container.dart
│  │  ├─ navigator_service.dart
├─ config/
│  ├─ services/
│  │  ├─ injection_container.dart
│  │  ├─ navigator_service.dart

```

-----

## to handle app icon 
run in terminal 
=>  dart run flutter_launcher_icons
-----
This setup allows you to copy the folder structure and utilities into any Flutter project and get started immediately.


---

## 7️⃣ SecurityService

✅✅ A service to protect the application by checking for insecure device environments (rooted/jailbroken or developer mode).

```dart
class SecurityService {
  /// Configuration to enable or disable the security service
  static bool isEnabled = true;

  /// Check if the device is jailbroken or rooted
  static Future<bool> isJailbroken();

  /// Check if developer mode / ADB is enabled (Android only)
  static Future<bool> isDeveloperModeEnabled();

  /// Main security check logic - navigates to warning screen if insecure
  static Future<void> checkSecurity();
}
```

**Usage in SplashScreen:**

```dart
void _navigateToNext() async {
  await SecurityService.checkSecurity();
  // continue navigation...
}
```

**Features:**
- Responsive warning screen using `ScreenUtil`.
- Automatic navigation to `SecurityWarningScreen` if conditions are met.
- Follows the app's standard design system and typography.

---

## 8️⃣ AppLogger (handleLogs)

✅✅ A utility to manage logging safely, ensuring logs only appear during development.

```dart
import 'package:new_standred/core/utils/app_logger.dart';

// Use this anywhere in the app
AppLogger.handleLogs("User logged in with ID: 123");
```

- **Debug Mode**: Logs are printed to the console.
- **Release Mode**: Logs are completely silenced, preventing sensitive information leaks.

---

## 9️⃣ Secure Data Handling & Obfuscation

✅✅ Guidelines and tools for protecting sensitive information.

### Secure Storage (Tokens)
Always use `SecureStorageHelper` for sensitive data like authentication tokens instead of `SharedPreferences`.

```dart
final secureStorage = sl<SecureStorageHelper>();
await secureStorage.saveData(key: 'token', value: 'my_secret_token');
```

### Data Obfuscation
The `SecurityService` provides a toggle to obfuscate sensitive data in the UI or logs.

```dart
// Enable/Disable globally
SecurityService.isObfuscationEnabled = true;

// Usage
String sensitiveEmail = "user@example.com";
String safeEmail = SecurityService.obfuscateData(sensitiveEmail); // us****om
```

---

## 🔟 API Key Management (.env)

✅✅ Manage sensitive environment variables using `.env` files properly.

1.  **Create a `.env` file** in the root directory:
    ```env
    API_BASE_URL=https://api.example.com
    API_KEY=your_secret_api_key_here
    ```
2.  **Add it to `.gitignore`** to prevent leaking keys:
    ```
    .env*
    ```
3.  **Access variables** in code:
    ```dart
    import 'package:flutter_dotenv/flutter_dotenv.dart';
    
    String baseUrl = dotenv.env['API_BASE_URL'] ?? 'fallback_url';
    ```

---

## 1️⃣1️⃣ Global Error Handling (ErrorScreen)

✅✅ Captures all Flutter framework and building errors, showing a user-friendly UI instead of a red screen or terminal logs.

- **Responsive**: Adapts to all screen sizes.
- **Informative**: Shows error details in a scrollable, selectable container.
- **Themed**: Matches the app's primary colors and typography.
- **Production Ready**: Prevents users from seeing raw code crashes.

