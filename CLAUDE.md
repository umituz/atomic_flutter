# AI Assistant Development Notes for Atomic Flutter Kit

This document contains comprehensive development guidelines, troubleshooting tips, and learned patterns for working with the Atomic Flutter Kit package.

## Project Overview

**Package Name**: `atomic_flutter_kit`  
**Version**: 0.12.1  
**Pub.dev**: https://pub.dev/packages/atomic_flutter_kit  
**GitHub**: https://github.com/umituz/atomic_flutter_kit

### Architecture
- **Design System**: Atomic Design (Atoms → Molecules → Organisms → Templates)
- **Theme System**: Material Design 3 with custom tokens
- **State Management**: Flutter Riverpod
- **Animation Library**: flutter_animate
- **Icons**: Lucide Icons + custom icon set

## Development Standards

### Code Organization
```
lib/
├── atomic_flutter_kit.dart           # Main library export
├── tokens/                           # Design tokens (colors, spacing, typography)
├── atoms/                           # Basic components (buttons, inputs, cards)
├── molecules/                       # Composite components (forms, navigation)
├── organisms/                       # Complex components (auth forms, AI assistant)
├── templates/                       # Page-level components
├── themes/                          # Theme system and providers
├── services/                        # Network, storage, haptics
├── utilities/                       # Helper classes and utilities
└── utils/                          # Extensions and utility functions
```

### Naming Conventions
- **Components**: `AtomicComponentName` (e.g., `AtomicButton`, `AtomicCard`)
- **Enums**: `AtomicEnumName` (e.g., `AtomicButtonVariant`, `AtomicLoadingState`)
- **Models**: `AtomicModelName` (e.g., `AtomicActionListItem`)
- **Services**: `AtomicServiceName` (e.g., `AtomicNetworkClient`)
- **Files**: `atomic_component_name.dart` (snake_case)

### Documentation Standards
- Every public class must have comprehensive dartdoc comments
- Include usage examples in documentation
- Document parameters with `@param` when complex
- Cross-reference related components with `[ComponentName]`

## Publishing Standards

### Package Quality Requirements
- **Pub Points**: Target 160/160
- **Documentation**: Must include library-level and class-level docs
- **README**: Comprehensive with examples and feature list
- **CHANGELOG**: Semantic versioning with detailed change notes
- **Tests**: Unit tests for core functionality

### Pub.dev Scoring Criteria
1. **Follow Dart file conventions** (30/30) ✅
2. **Provide documentation** (20/20) ✅
3. **Platform support** (20/20) ✅  
4. **Pass static analysis** (50/50) ✅
5. **Support up-to-date dependencies** (40/40) ✅

### Common Issues and Solutions

#### Documentation Warnings
**Issue**: Library-level documentation missing
```
warning: atomic_flutter_kit has no library level documentation comments
```
**Solution**: Add comprehensive library documentation:
```dart
/// A comprehensive atomic design system for Flutter applications.
///
/// This library provides a complete set of atomic design components...
library atomic_flutter_kit;
```

#### Package Naming Conflicts
**Issue**: Package name conflicts on pub.dev
**Solution**: 
1. Update `pubspec.yaml` name field
2. Rename main library file
3. Update all import statements
4. Update GitHub repository URLs

#### Static Analysis Issues
**Issue**: Missing documentation comments
**Solution**: Add dartdoc comments to all public APIs:
```dart
/// Brief description of the class/method.
///
/// Detailed explanation with usage examples...
class AtomicComponent {
  /// Brief parameter description.
  final String parameter;
}
```

### Version Management
- Use semantic versioning (major.minor.patch)
- Update CHANGELOG.md for each release
- Update README.md version references
- Test with `dart pub publish --dry-run` before publishing

## Component Development Patterns

### Theme Integration
All components should integrate with the theme system:
```dart
class AtomicComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);
    return Container(
      color: theme.colors.primary,
      // ...
    );
  }
}
```

### Responsive Design
Use responsive utilities for adaptive layouts:
```dart
AtomicResponsive(
  mobile: MobileLayout(),
  tablet: TabletLayout(),
  desktop: DesktopLayout(),
)
```

### Accessibility
- Include semantic labels
- Support screen readers
- Ensure proper focus handling
- Meet WCAG 2.1 AA standards

```dart
Semantics(
  label: 'Submit form',
  button: true,
  child: AtomicButton(
    label: 'Submit',
    onPressed: _handleSubmit,
  ),
)
```

### Animation Standards
- Use `flutter_animate` for consistent animations
- Standard duration: 200-300ms for interactions
- Easing: Use Material Design curves

```dart
Widget.animate()
  .fadeIn(duration: AtomicAnimations.fast)
  .slideX(begin: -0.1, end: 0);
```

## Testing Strategy

### Unit Tests
- Test component rendering
- Test state changes
- Test user interactions
- Test accessibility features

### Integration Tests
- Test theme switching
- Test responsive behavior
- Test component composition

### Example Test Structure
```dart
testWidgets('AtomicButton should render with correct label', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: AtomicButton(
        label: 'Test Button',
        onPressed: () {},
      ),
    ),
  );
  
  expect(find.text('Test Button'), findsOneWidget);
});
```

## Performance Guidelines

### Optimization Patterns
- Use `const` constructors where possible
- Implement `shouldRepaint` for custom painters
- Use `RepaintBoundary` for complex widgets
- Lazy load expensive operations

### Memory Management
- Dispose controllers and listeners
- Use weak references for callbacks
- Avoid memory leaks in animations

## Migration Patterns

### Breaking Changes
When introducing breaking changes:
1. Deprecate old APIs first
2. Provide migration guides
3. Update examples and documentation
4. Increment major version

### Legacy Support
- Keep deprecated APIs for one major version
- Provide clear migration paths
- Include migration scripts when possible

## AI Development Best Practices

### When Working with This Package
1. **Always check current version** in `pubspec.yaml`
2. **Read existing patterns** before implementing new features
3. **Follow naming conventions** strictly
4. **Add comprehensive documentation** to all new components
5. **Test thoroughly** before proposing changes
6. **Update CHANGELOG.md** with all changes

### Common Commands
```bash
# Install dependencies
flutter pub get

# Run tests
flutter test

# Check for publishing issues
dart pub publish --dry-run

# Publish to pub.dev
dart pub publish

# Analyze code
dart analyze

# Format code
dart format lib/ test/
```

### Git Workflow
- Use conventional commits
- Don't mention AI assistance in commit messages
- Keep commits focused and atomic
- Update documentation with code changes

## Troubleshooting

### Build Issues
- Clean build: `flutter clean && flutter pub get`
- Check Flutter/Dart versions in `pubspec.yaml`
- Verify all imports are correct

### Publishing Issues
- Ensure no uncommitted changes
- Verify CHANGELOG.md includes current version
- Check package name uniqueness on pub.dev
- Validate with dry-run first

### Documentation Issues
- Use dartdoc format (`///`) not regular comments (`//`)
- Include code examples in documentation
- Cross-reference related components
- Keep examples up-to-date with API changes

## Future Enhancements

### Planned Features
- Additional Material Design 3 components
- Enhanced theming system
- Improved accessibility features
- Performance optimizations

### Extension Points
- Custom theme tokens
- Component variants
- Animation customization
- Platform-specific optimizations

---

*This document is maintained to ensure consistent development practices and to preserve institutional knowledge about this package.*