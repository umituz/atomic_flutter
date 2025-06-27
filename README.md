<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# Atomic Flutter

A modern atomic design system for Flutter applications following umituz.com standards. Built with Flutter 3.16+ and modern Dart patterns.

## Features

- 🎨 **Modern Design Tokens**: Colors, typography, spacing, shadows, borders, and animations
- 🧱 **Atomic Components**: Reusable UI components following atomic design principles
- 🚀 **Performance Optimized**: Built with Flutter best practices for 60fps performance
- 📱 **Responsive**: Mobile-first design with responsive utilities
- 🌈 **Theme Support**: Light/dark mode ready with customizable themes
- ♿ **Accessible**: WCAG 2.1 AA compliant components
- 📝 **TypeScript-like DX**: Strongly typed with excellent IDE support

## Installation

Add `atomic_flutter` to your `pubspec.yaml`:

```yaml
dependencies:
  atomic_flutter: ^0.0.1
```

Then run:

```bash
flutter pub get
```

## Usage

### Import the package

```dart
import 'package:atomic_flutter/atomic_flutter.dart';
```

### Design Tokens

#### Colors
```dart
// Primary colors
AtomicColors.primary
AtomicColors.primaryLight
AtomicColors.primaryDark

// Semantic colors
AtomicColors.success
AtomicColors.warning
AtomicColors.error
AtomicColors.info

// Text colors
AtomicColors.textPrimary
AtomicColors.textSecondary

// Utility methods
AtomicColors.withAlpha(AtomicColors.primary, 0.5)
AtomicColors.primaryGradient
```

#### Spacing
```dart
// Spacing values
AtomicSpacing.xs  // 8
AtomicSpacing.sm  // 12
AtomicSpacing.md  // 16
AtomicSpacing.lg  // 24

// EdgeInsets helpers
AtomicSpacing.allMd
AtomicSpacing.horizontalLg
AtomicSpacing.symmetric(horizontal: AtomicSpacing.md, vertical: AtomicSpacing.sm)
```

#### Typography
```dart
// Text styles
AtomicTypography.headlineLarge
AtomicTypography.bodyMedium
AtomicTypography.labelSmall

// With colors
AtomicTypography.headlineLargePrimary
AtomicTypography.bodyMediumSecondary
```

### Components

#### AtomicButton
```dart
AtomicButton(
  label: 'Click Me',
  onPressed: () {
    // Handle press
  },
  variant: AtomicButtonVariant.primary,
  size: AtomicButtonSize.medium,
  icon: Icons.add,
  isLoading: false,
  isFullWidth: false,
)
```

#### AtomicCard
```dart
AtomicCard(
  child: Text('Card content'),
  padding: AtomicSpacing.allLg,
  shadow: AtomicCardShadow.medium,
  onTap: () {
    // Handle tap
  },
  borderRadius: AtomicBorders.lg,
)
```

#### AtomicTextField
```dart
AtomicTextField(
  controller: _controller,
  label: 'Email',
  hint: 'Enter your email',
  prefixIcon: Icons.email,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    return null;
  },
  borderType: AtomicTextFieldBorderType.outlined,
)
```

## Example

```dart
import 'package:flutter/material.dart';
import 'package:atomic_flutter/atomic_flutter.dart';

class LoginScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: AtomicSpacing.allXl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome Back',
              style: AtomicTypography.headlineLargePrimary,
            ),
            SizedBox(height: AtomicSpacing.xl),
            AtomicCard(
              child: Column(
                children: [
                  AtomicTextField(
                    controller: _emailController,
                    label: 'Email',
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: AtomicSpacing.md),
                  AtomicTextField(
                    controller: _passwordController,
                    label: 'Password',
                    prefixIcon: Icons.lock,
                    obscureText: true,
                  ),
                  SizedBox(height: AtomicSpacing.lg),
                  AtomicButton(
                    label: 'Login',
                    onPressed: () {
                      // Handle login
                    },
                    isFullWidth: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Components Roadmap

### ✅ Available

#### **Atoms (Basic Components)**
- AtomicButton
- AtomicIconButton
- AtomicCard
- AtomicGradientContainer
- AtomicCollapseBox
- AtomicSmoothContainer / AtomicAnimatedSmoothContainer
- AtomicTextField
- AtomicSlider / AtomicRangeSlider
- AtomicSwitch
- AtomicCheckbox
- AtomicRadio
- AtomicIcon
- AtomicLoader
- AtomicChip
- AtomicShimmer
- AtomicBadge
- AtomicToast
- AtomicAlert
- AtomicTag
- AtomicProgress / AtomicProgressCard / AtomicStepProgress
- AtomicAvatar
- AtomicText
- AtomicImage / AtomicSvg
- AtomicDivider
- AtomicDialog
- AtomicBottomSheet
- AtomicTooltip / AtomicRichTooltip

#### **Molecules (Combined Components)**
- AtomicDropdown
- AtomicFormField
- AtomicNavigationBar / AtomicNavigationRail

### 🚧 Coming Soon

#### **Molecules**
- AtomicListItem
- AtomicAppBar
- AtomicDatePicker
- AtomicTimePicker

#### **Organisms**
- AtomicDataTable
- AtomicForm
- AtomicLayout
- AtomicStepper

## Contributing

Contributions are welcome! Please read our contributing guidelines before submitting PRs.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Maintainers

- **Ümit UZ** - [umituz.com](https://umituz.com)

## Standards

This package follows:
- [Flutter Mobile Standards](https://github.com/umituz/umituz.com/blob/main/.cursor/rules/projects/flutter-mobile-standards.mdc)
- Atomic Design Principles
- Material Design 3 Guidelines
- WCAG 2.1 AA Accessibility Standards
