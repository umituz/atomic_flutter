# Changelog

All notable changes to the Atomic Flutter design system will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.8.0] - 2024-12-21 - 🎯 Phase 4 Migration Complete

### Added - Phase 4 Controllers & Enums Migration
- ✨ **Controllers (Providers)**:
  - `AtomicSheetSelectController<T>` - Enhanced sheet selection controller with generics
    - Multi-selection support with allowMultipleSelection flag
    - Validation and filtering capabilities
    - Type-safe value extraction with selectedValue and selectedValues
  - `AtomicValueController<T>` - Enhanced value notifier with custom listeners
    - Custom VoidCallback listeners with indexed removal
    - Value-change listeners with ValueChanged<T?> support
    - Conditional notification with shouldNotify predicates
  - `AtomicListValueController<T>` - Specialized controller for list values
    - List operations: add, remove, toggle, clear
    - Helper methods: contains, isEmpty, isNotEmpty, length
- ✨ **Enums**:
  - `AtomicLoadingState` - Loading states with transition validation and helpers
    - States: idle, loading, success, error, refreshing
    - Validation: canTransitionTo with state flow checking
    - UI Helpers: color, icon, description getters
  - `AtomicStatus` - Comprehensive status enum with semantic meanings
    - States: loading, success, error, empty, cannot, timeout, idle, cancelled, warning
    - UI Integration: color, icon, displayText properties
    - State categorization: isCompleted, isActive, isNegative helpers
  - `AtomicGender` - Inclusive gender options with modern approach
    - Options: male, female, nonBinary, preferNotToSay, other
    - Accessibility: displayText, shortText, commonPronouns
    - API Integration: apiValue, fromApiValue, fromString
    - Form helpers: formOptions, basicOptions, inclusiveOptions

### Technical Improvements
- 📚 Updated barrel exports in atomic_flutter.dart to include providers and enums
- 🔧 Migrated 5 files from atomic project to atomic_flutter package
- ✅ Enhanced controllers with generic type support and advanced features
- ✅ Modern enum implementation with enhanced utility methods
- ✅ Legacy compatibility support for smooth migration
- 🎯 Achieved 60% migration progress (35/58 files)

### Migration Progress Update
- ✅ **Phase 1**: Atomic Components - COMPLETE
- ✅ **Phase 2**: Extensions & Utilities - COMPLETE  
- ✅ **Phase 3**: Data Models - COMPLETE
- ✅ **Phase 4**: Controllers & Enums - COMPLETE
- 🚧 **Phase 5**: Network & Services - REMAINING

## [0.7.0] - 2024-12-21 - 🚀 Phase 1-3 Migration Complete

### Added - Phase 1 Components Migration
- ✨ **Container Components**:
  - `AtomicAnimatedContainer` - Animated version of smooth container with implicit animations
  - `AtomicIconBox` - Container with icon, customizable styling and tap interactions
- ✨ **Input Components**:
  - `AtomicButtonCheck` - Button-style checkbox with text label and smooth animations
- ✨ **Feedback Components**:
  - `AtomicDotLoading` - Animated loading indicator with bouncing dots (small, medium, large sizes)
- ✨ **Sheet Components**:
  - `AtomicCustomSheetBody` - Body content for bottom sheets with customizable styling
  - `AtomicSheetBuilder` - Helper for building bottom sheets with consistent styling
- ✨ **Layout Components**:
  - `AtomicStackedBody` - Layout component for creating stacked card effects
- ✨ **Utilities**:
  - `SvgProvider` - ImageProvider for SVG files supporting network, asset, and file sources

### Added - Phase 2 Extensions Migration
- ✨ **Extension Utilities**:
  - `BoolExtension` - Boolean utilities with API serialization support
  - `CloneExtension` - Deep cloning using isolates with sync/async methods
  - `MapExtension` - Enhanced map operations with type safety
  - `ListExtension` - Advanced list operations including pluck functionality

### Added - Phase 3 Models Migration
- ✨ **Data Models**:
  - `AtomicActionListItem` - Action list item model with callbacks and unique identifiers
  - `AtomicBottomBarItem` - Bottom navigation bar item model with badge support
  - `AtomicIconListItemModel` - Icon list item model with customizable colors (renamed to avoid conflicts)
  - `AtomicSelectListItem<T>` - Generic selectable list item model with type safety
  - `AtomicTextListItem` - Simple text list item model with styling options

### Config
- 🔧 **LegacyColors** - Simplified backward compatibility layer (reduced complexity)
- 🔧 **LegacyDimensions** - Legacy dimension mappings for smooth migration

### Fixed
- 🔧 Fixed `ui.PictureRecorder` import issues in SvgProvider
- 🔧 Fixed BoxShadow type issues in AtomicStackedBody  
- 🔧 Fixed import paths for atomic_smooth_container references
- 🔧 Resolved naming conflicts between models and UI components

### Technical Improvements
- 📚 Updated barrel exports in atomic_flutter.dart to include all new components and models
- 🔧 Migrated 13 components + 5 models from atomic project to atomic_flutter package
- ✅ Maintained Material Design 3 compliance across all migrated components
- ✅ Integrated all components with atomic theme system
- 🎯 Achieved 52% migration progress (30/58 files)

## [0.6.0] - 2024-12-21 - 🎉 ALL CRITICAL MOLECULES COMPLETED! 

### Added - Final Critical Molecule
- ✨ **AtomicTimePicker** - Material Design time picker with theme integration
- ✨ **AtomicSimpleTimePicker** - Simple time picker for basic use cases
- ✨ **Time formatting support** - 12/24 hour format with automatic detection
- ✨ **Variant support** - Filled, outlined, and underlined variants

### 🎯 **MILESTONE ACHIEVED: Production-Ready Design System**
- ✅ **35+ Atomic Components** - Complete atoms library
- ✅ **7 Major Molecules** - All critical combinations completed
- ✅ **100% Material Design 3** - Fully compliant implementation
- ✅ **Complete Theme System** - Colors, typography, spacing, borders, shadows
- ✅ **Responsive Utilities** - Mobile-first responsive helpers
- ✅ **Accessibility Ready** - WCAG 2.1 AA compliance
- ✅ **Production Tested** - All components lint-clean and test-ready

### Architecture Completeness
- 🏗️ **Atoms Phase** - COMPLETE ✅
- 🧩 **Molecules Phase** - COMPLETE ✅  
- 🔬 **Organisms Phase** - PLANNING 🚧
- 📱 **Templates Phase** - FUTURE 📋
- 🏛️ **Pages Phase** - FUTURE 📋

### Next Phase: Organisms (Complex Components)
- 📊 **AtomicDataTable** - Data tables with sorting/filtering  
- 📝 **AtomicForm** - Complete form components
- 🏗️ **AtomicLayout** - Responsive layout templates
- 📈 **AtomicStepper** - Multi-step workflow components

## [0.5.0] - 2024-12-21

### Added - Major Molecules Components
- ✨ **AtomicListItem** - Material Design list item with flexible layout options
- ✨ **AtomicUserListItem** - Specialized list item for user display with avatar support
- ✨ **AtomicIconListItem** - List item with icon container for menu items
- ✨ **AtomicAppBar** - Material Design app bar with theme integration and modern features
- ✨ **AtomicSimpleAppBar** - Simplified app bar for common use cases
- ✨ **AtomicSearchAppBar** - App bar with integrated search functionality
- ✨ **AtomicDatePicker** - Material Design date picker with theme integration
- ✨ **AtomicSimpleDatePicker** - Simple date picker for basic use cases
- ✨ **AtomicDateRangePicker** - Date range picker for selecting date ranges

### Enhanced
- 🔧 **Export structure** - Organized molecules exports by category
- 📚 **Documentation** - Updated README with comprehensive component list
- 🏗️ **Architecture** - Improved folder structure for molecules

### Developer Experience
- 🚀 **Helper Components** - Added specialized variants for common use cases
- 🎨 **Theming** - All new components fully integrated with atomic theme system
- ♿ **Accessibility** - WCAG 2.1 AA compliance maintained across all components

## [0.4.0] - 2024-12-21

### Added - Molecules Level Components
- ✨ **AtomicDropdown** - Material Design dropdown with enhanced functionality and filtering
- ✨ **AtomicFormField** - Wrapper for form inputs with validation support
- ✨ **AtomicNavigationBar** - Material Design 3 bottom navigation bar
- ✨ **AtomicNavigationRail** - Navigation rail variant for larger screens  
- ✨ **AtomicNavigationDestination** - Data class for navigation destinations with badge support

### Architecture Updates
- 🏗️ **Molecules folder structure** - Added organized molecules directory structure
- 🏗️ **Export system** - Updated barrel exports to include new molecules
- 🏗️ **Documentation** - Updated README with new component categories

### Framework Compliance  
- ✅ **Material Design 3** - All navigation components follow MD3 standards
- ✅ **Atomic Design** - Proper separation of atoms vs molecules
- ✅ **Flutter Standards** - Following umituz.com Flutter mobile standards

## [0.3.0] - 2024-12-21

### Added
- ✨ **AtomicSlider** - Material Design slider with theme integration
- ✨ **AtomicRangeSlider** - Range slider for selecting value ranges
- ✨ **AtomicProgress** - Linear and circular progress indicators
- ✨ **AtomicProgressCard** - Progress indicator with card wrapper
- ✨ **AtomicStepProgress** - Multi-step progress indicator for workflows
- ✨ **AtomicTooltip** - Material Design tooltip with theme integration
- ✨ **AtomicRichTooltip** - Enhanced tooltip with rich content support
- ✨ **AtomicTooltipHelper** - Utility functions for tooltip positioning

### Enhanced
- 🔧 **Build Configuration** - Updated flutter_svg dependency
- 🔧 **Type Safety** - Improved enum definitions and type checking
- 🔧 **Performance** - Optimized animation configurations

### Improved
- 🔧 Better Material Design 3 compliance
- 🎯 Consistent theme integration across all components
- 📊 Enhanced accessibility support
- ⚡ Performance optimizations for 60fps animations

### Documentation
- 📚 Updated README with new component documentation
- 📝 Added comprehensive usage examples
- 🎯 Component roadmap updated

## [0.2.0] - 2024-12-20

### Added
- ✨ **AtomicText** - Flexible text component with theme integration
- ✨ **AtomicImage** - Multi-source image component with loading states
- ✨ **AtomicSvg** - SVG image component with theme integration
- ✨ **AtomicSmoothContainer** - Container with smooth corners
- ✨ **AtomicAnimatedSmoothContainer** - Animated smooth container
- ✨ **AtomicAlert** - Notification/alert component with multiple variants
- ✨ **AtomicTag** - Small label/tag component for categorization

### Dependencies
- 📦 Added `flutter_svg: ^2.0.9` for SVG support
- 📦 Added `intl: ^0.20.2` for internationalization support

## [0.1.0] - 2024-12-19

### Added
- 🎉 Initial release of Atomic Flutter Design System
- 🎨 **Core Theme System** with atomic design tokens
- 🔘 **Buttons**: AtomicButton, AtomicIconButton
- 📦 **Containers**: AtomicCard, AtomicGradientContainer, AtomicCollapseBox
- 📝 **Inputs**: AtomicTextField, AtomicSwitch, AtomicCheckbox, AtomicRadio
- 🎯 **Icons**: AtomicIcon with standardized sizing
- 🔄 **Feedback**: AtomicLoader, AtomicChip, AtomicShimmer, AtomicBadge, AtomicToast
- 👤 **Display**: AtomicAvatar
- 📋 **Overlays**: AtomicDivider, AtomicDialog, AtomicBottomSheet
- 🎨 **Design Tokens**: Colors, Typography, Spacing, Animations, Shadows, Borders
- 📱 **Utilities**: AtomicResponsive, AtomicDebouncer

### Core Features
- 🌙 Dark/Light theme support
- 📱 Responsive design utilities
- ♿ Accessibility compliance (WCAG 2.1 AA)
- ⚡ 60fps performance optimization
- 🎯 Material Design 3 compliance
- 🔧 TypeScript-style null safety

### Documentation
- 📚 Comprehensive README with usage examples
- 🎯 Component roadmap and feature matrix
- 📝 Installation and setup guide
