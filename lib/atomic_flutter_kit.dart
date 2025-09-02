/// A comprehensive atomic design system for Flutter applications.
///
/// This library provides a complete set of atomic design components,
/// design tokens, and utilities following Material Design 3 principles.
/// Perfect for building consistent, accessible, and performant Flutter apps.
///
/// Key features:
/// - 🎨 Modern Design Tokens (colors, typography, spacing, shadows, borders)
/// - 🧱 Atomic Components (atoms, molecules, organisms)
/// - 🚀 Performance Optimized (60fps animations, efficient rendering)
/// - 📱 Responsive Design (mobile-first with responsive utilities)
/// - 🌈 Theme Support (light/dark mode with customization)
/// - ♿ Accessibility (WCAG 2.1 AA compliant)
///
/// ## Quick Start
///
/// ```dart
/// import 'package:atomic_flutter_kit/atomic_flutter_kit.dart';
///
/// // Use design tokens
/// Container(
///   color: AtomicColors.primary,
///   padding: AtomicSpacing.allMd,
///   child: AtomicButton(
///     label: 'Hello World',
///     onPressed: () {},
///   ),
/// )
/// ```
library atomic_flutter_kit;

export 'themes/atomic_theme_data.dart';
export 'themes/atomic_theme_provider.dart';

export 'tokens/colors/atomic_colors.dart';
export 'tokens/spacing/atomic_spacing.dart';
export 'tokens/typography/atomic_typography.dart';
export 'tokens/animations/atomic_animations.dart';
export 'tokens/shadows/atomic_shadows.dart';
export 'tokens/borders/atomic_borders.dart';

export 'utilities/atomic_responsive.dart';
export 'utilities/atomic_responsive_utils.dart';
export 'utilities/atomic_debouncer.dart';

export 'utils/svg_provider.dart';
export 'utils/extensions/extensions.dart';

export 'models/action_list_item.dart';
export 'models/bottom_bar_item.dart';
export 'models/icon_list_item.dart';
export 'models/select_list_item.dart';
export 'models/text_list_item.dart';
export 'models/base_model.dart';
export 'models/auth/auth_user.dart';
export 'models/auth/auth_result.dart';
export 'models/http/api_response.dart';

export 'providers/sheet_select_controller.dart';
export 'providers/value_controller.dart';
export 'providers/auth/auth_provider.dart';
export 'providers/base_provider.dart';

export 'tokens/enums/atomic_loading_state.dart';
export 'tokens/enums/atomic_status.dart';
export 'tokens/enums/atomic_gender.dart';
export 'tokens/enums/atomic_otp_status.dart';

export 'tokens/icons/atomic_custom_icons.dart';

export 'services/atomic_haptic_service.dart';
export 'services/network/network.dart';
export 'services/storage/storage.dart';
export 'services/atomic_base_service.dart';
export 'config/api_config.dart';
export 'config/auth_constants.dart';
export 'services/auth/auth_service.dart';
export 'services/auth/token_storage_service.dart';
export 'services/base_api_service.dart';
export 'services/http/atomic_http_client.dart';

export 'atoms/buttons/atomic_button.dart';
export 'atoms/buttons/atomic_icon_button.dart';

export 'atoms/containers/atomic_card.dart';
export 'atoms/containers/atomic_gradient_container.dart';
export 'atoms/containers/atomic_collapse_box.dart';
export 'atoms/containers/atomic_smooth_container.dart';
export 'atoms/containers/atomic_animated_container.dart';
export 'atoms/containers/atomic_icon_box.dart';

export 'atoms/inputs/atomic_text_field.dart';
export 'atoms/inputs/atomic_switch.dart';
export 'atoms/inputs/atomic_checkbox.dart';
export 'atoms/inputs/atomic_radio.dart';
export 'atoms/inputs/atomic_slider.dart';
export 'atoms/inputs/atomic_button_check.dart';

export 'atoms/icons/atomic_icon.dart';

export 'atoms/display/atomic_text.dart';
export 'atoms/display/atomic_image.dart';
export 'atoms/display/atomic_avatar.dart';

export 'atoms/feedback/atomic_loader.dart';
export 'atoms/feedback/atomic_chip.dart';
export 'atoms/feedback/atomic_shimmer.dart';
export 'atoms/feedback/atomic_badge.dart';
export 'atoms/feedback/atomic_toast.dart';
export 'atoms/feedback/atomic_alert.dart';
export 'atoms/feedback/atomic_tag.dart';
export 'atoms/feedback/atomic_progress.dart';
export 'atoms/feedback/atomic_dot_loading.dart';

export 'atoms/overlays/atomic_divider.dart';
export 'atoms/overlays/atomic_dialog.dart';
export 'atoms/overlays/atomic_bottom_sheet.dart';
export 'atoms/overlays/atomic_tooltip.dart';

export 'molecules/inputs/atomic_dropdown.dart';
export 'molecules/forms/atomic_form_field.dart';
export 'molecules/pickers/atomic_date_picker.dart';
export 'molecules/pickers/atomic_time_picker.dart';

export 'molecules/navigation/atomic_navigation_bar.dart';
export 'molecules/navigation/atomic_app_bar.dart';

export 'molecules/lists/atomic_list_item.dart';

export 'molecules/sheets/atomic_custom_sheet_body.dart';
export 'molecules/sheets/atomic_sheet_builder.dart';

export 'molecules/layouts/atomic_stacked_body.dart';

export 'organisms/auth/atomic_login_form.dart';
export 'organisms/auth/atomic_register_form.dart';
export 'organisms/auth/atomic_otp_form.dart';
// export 'organisms/ai_assistant/atomic_ai_assistant.dart'; // Disabled due to syntax errors

export 'templates/auth/atomic_auth_template.dart';
export 'templates/auth/atomic_auth_template_helper.dart';

export 'navigation/atomic_router.dart';

// Templates - New standardization layer
export 'templates/constants/atomic_app_constants.dart';
export 'templates/initialization/atomic_app_initializer.dart';
export 'templates/routing/atomic_router_template.dart';
export 'templates/screens/atomic_home_screen_template.dart';
