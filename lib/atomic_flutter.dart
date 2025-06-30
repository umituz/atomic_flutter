library atomic_flutter;

// ===== THEMES =====
export 'themes/atomic_theme_data.dart';
export 'themes/atomic_theme_provider.dart';

// ===== DESIGN TOKENS =====

// Colors
export 'tokens/colors/atomic_colors.dart';

// Spacing
export 'tokens/spacing/atomic_spacing.dart';

// Typography
export 'tokens/typography/atomic_typography.dart';

// Animations
export 'tokens/animations/atomic_animations.dart';

// Shadows
export 'tokens/shadows/atomic_shadows.dart';

// Borders
export 'tokens/borders/atomic_borders.dart';

// ===== UTILITIES =====

// Responsive utilities
export 'utilities/atomic_responsive.dart';

// Function utilities
export 'utilities/atomic_debouncer.dart';

// Image utilities
export 'utils/svg_provider.dart';

// Extensions
export 'utils/extensions/extensions.dart';

// Models
export 'models/action_list_item.dart';
export 'models/bottom_bar_item.dart';
export 'models/icon_list_item.dart';
export 'models/select_list_item.dart';
export 'models/text_list_item.dart';

// Providers
export 'providers/sheet_select_controller.dart';
export 'providers/value_controller.dart';
export 'providers/atomic_database_provider.dart';

// Enums
export 'tokens/enums/atomic_loading_state.dart';
export 'tokens/enums/atomic_status.dart';
export 'tokens/enums/atomic_gender.dart';
export 'tokens/enums/atomic_otp_status.dart';

// Icons
export 'tokens/icons/atomic_custom_icons.dart';

// Services
export 'services/atomic_haptic_service.dart';
export 'services/network/network.dart';
export 'services/storage/storage.dart';
export 'services/atomic_base_service.dart';
export 'services/supabase/supabase.dart';

// ===== ATOMS =====

// Buttons
export 'atoms/buttons/atomic_button.dart';
export 'atoms/buttons/atomic_icon_button.dart';

// Containers
export 'atoms/containers/atomic_card.dart';
export 'atoms/containers/atomic_gradient_container.dart';
export 'atoms/containers/atomic_collapse_box.dart';
export 'atoms/containers/atomic_smooth_container.dart';
export 'atoms/containers/atomic_animated_container.dart';
export 'atoms/containers/atomic_icon_box.dart';

// Inputs
export 'atoms/inputs/atomic_text_field.dart';
export 'atoms/inputs/atomic_switch.dart';
export 'atoms/inputs/atomic_checkbox.dart';
export 'atoms/inputs/atomic_radio.dart';
export 'atoms/inputs/atomic_slider.dart';
export 'atoms/inputs/atomic_button_check.dart';

// Icons
export 'atoms/icons/atomic_icon.dart';

// Display
export 'atoms/display/atomic_text.dart';
export 'atoms/display/atomic_image.dart';
export 'atoms/display/atomic_avatar.dart';

// Feedback
export 'atoms/feedback/atomic_loader.dart';
export 'atoms/feedback/atomic_chip.dart';
export 'atoms/feedback/atomic_shimmer.dart';
export 'atoms/feedback/atomic_badge.dart';
export 'atoms/feedback/atomic_toast.dart';
export 'atoms/feedback/atomic_alert.dart';
export 'atoms/feedback/atomic_tag.dart';
export 'atoms/feedback/atomic_progress.dart';
export 'atoms/feedback/atomic_dot_loading.dart';

// Overlays
export 'atoms/overlays/atomic_divider.dart';
export 'atoms/overlays/atomic_dialog.dart';
export 'atoms/overlays/atomic_bottom_sheet.dart';
export 'atoms/overlays/atomic_tooltip.dart';

// ===== MOLECULES =====

// Forms & Inputs
export 'molecules/inputs/atomic_dropdown.dart';
export 'molecules/forms/atomic_form_field.dart';
export 'molecules/pickers/atomic_date_picker.dart';
export 'molecules/pickers/atomic_time_picker.dart';

// Navigation
export 'molecules/navigation/atomic_navigation_bar.dart';
export 'molecules/navigation/atomic_app_bar.dart';

// Lists
export 'molecules/lists/atomic_list_item.dart';

// Sheets
export 'molecules/sheets/atomic_custom_sheet_body.dart';
export 'molecules/sheets/atomic_sheet_builder.dart';

// Layouts
export 'molecules/layouts/atomic_stacked_body.dart';

// ===== REMAINING TODOS =====
// TODO: Complex components combining atoms
// ✅ All critical molecules completed!
// Next phase: Organisms level coming soon...

// ===== ORGANISMS =====

// Auth Organisms
export 'organisms/auth/atomic_login_form.dart';
export 'organisms/auth/atomic_otp_form.dart';
export 'organisms/ai_assistant/atomic_ai_assistant.dart';

// ===== TEMPLATES =====

// Auth Templates
export 'templates/auth/atomic_auth_template.dart';
export 'templates/auth/atomic_auth_template_helper.dart';

// ===== UTILITIES =====
// TODO: Helper functions and utilities
// - AtomicTheme
// - AtomicValidator
// - AtomicFormatter
// - AtomicResponsive
