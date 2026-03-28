# Flutter Core Extensions Guide

This project includes a robust set of reusable Dart extensions under the `lib/core/extensions` directory to help boost developer productivity and maintain Clean Code principles. Instead of writing utilities functions inside a helper class, these extensions supercharge existing Dart and Flutter classes natively.

## How to Import
You only need to import the barrel file to access all extensions across your project:
```dart
import 'package:<your_project>/core/extensions/extensions.dart';
```

---

## 🏗 Available Extensions & Examples

### 1. `ContextExtensions` (`context_extensions.dart`)
Reduce boilerplate when accessing media queries, themes, or navigation.

```dart
// Before
MediaQuery.of(context).size.width
Theme.of(context).primaryColor
Navigator.of(context).push(MaterialPageRoute(builder: (_) => MyScreen()))

// After
context.screenWidth
context.theme.primaryColor
context.push(MyScreen())
```

### 2. `StringExtensions` (`string_extensions.dart`)
Utility functions to parse and validate strings cleanly.

```dart
// Check valid email
bool isValid = 'abdullah@example.com'.isValidEmail();

// Parse parsing concisely
int? age = '25'.toIntOrNull();

// Capitalization
String title = 'hello world'.capitalizeAll(); // "Hello World"
```

### 3. `ListExtensions` (`list_extensions.dart`)
Easily work with lists and widgets.

```dart
// Safely get first element
final List<String>? names = [];
final first = names.firstOrNull; // null

// Separate widgets (great for Columns/Rows)
Column(
  children: [
    Text('Item 1'),
    Text('Item 2'),
  ].separatedBy(const SizedBox(height: 10)), /* Adds a 10px spacing between widgets */
)
```

### 4. `DateTimeExtensions` (`date_time_extensions.dart`)
Format dates quickly using `intl`.

```dart
final now = DateTime.now();

// Formats
print(now.toShortDate()); // "20/05/2024"
print(now.format('yyyy MMM dd')); 

// Semantic checks
if (now.isToday) { ... }
```

### 5. `NumberExtensions` & `DurationExtensions` (`number_extensions.dart`, `duration_extensions.dart`)
Handle numbers, currency formatting, and easy asynchronous delays.

```dart
// Format Currency
print(1500.5.toCurrency()); // "$1,500.50"

// Readable Delays instead of Future.delayed
await 2.delay(); // wait 2 seconds
await 500.delayMilliseconds(); // wait 500 milliseconds
await const Duration(seconds: 2).delay(); // Same thing
```

### 6. `WidgetExtensions` (`widget_extensions.dart`)
A declarative way to wrap widgets without burying them in nested trees.

```dart
// Before
Padding(
  padding: const EdgeInsets.all(16.0),
  child: Center(
    child: Text('Hello'),
  ),
)

// After
Text('Hello')
  .center()
  .paddingAll(16.0)

// Easy conditional visibility
Text('Conditional Text').visible(isTrue)
```

### 7. `NullableObjectExtensions` (`nullable_extensions.dart`)
Generic null-safety functions.

```dart
User? currentUser;

// Instead of if (currentUser != null) { doSomething(currentUser) }
currentUser?.let((user) => print(user.name));
```

---

## 🌟 Real-World Example Screen

Here is an example of a simple profile screen utilizing several of these extensions at once. Notice how clean the widget tree looks.

```dart
import 'package:flutter/material.dart';
import 'package:<your_project>/core/extensions/extensions.dart'; // IMPORTANT: Import barrel file

class ProfileScreen extends StatelessWidget {
  final String? userName;
  final DateTime memberSince;

  const ProfileScreen({Key? key, this.userName, required this.memberSince}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile').center(), // WidgetExtension
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // StringExtension & Nullable checking
          Text(
            'Welcome, ${userName?.capitalize() ?? 'Guest'}', 
            style: context.textTheme.headlineMedium, // ContextExtension
          ),
          
          // NumberExtension 
          Text(
            'Balance: ${2500.50.toCurrency()}',
          ),
          
          // DateTimeExtension
          Text('Member since: ${memberSince.toShortDate()}'),
          
          // ContextExtension
          ElevatedButton(
            onPressed: () => context.showSnackBar('Settings opened!'), 
            child: const Text('Settings'),
          ).visible(userName.isNotNull), // WidgetExtension & NullableExtension
          
        ].separatedBy(const SizedBox(height: 16)), // ListExtension (adds spacing between all children)
      ).paddingAll(20), // WidgetExtension
    );
  }
}
```

## How to Create Your Own
To add more extensions in the future:
1. Create a new file under `lib/core/extensions/` (e.g., `async_extensions.dart`).
2. Use the `extension <Name> on <Type>` syntax.
3. Export it in `lib/core/extensions/extensions.dart` so all imports remain central and clean.
