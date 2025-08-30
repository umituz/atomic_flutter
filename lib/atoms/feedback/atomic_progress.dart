import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_data.dart';
import 'package:atomic_flutter_kit/atoms/display/atomic_text.dart';

/// A customizable progress indicator for displaying the progress of a task.
///
/// The [AtomicProgress] widget supports both linear and circular progress
/// indicators. It can display determinate or indeterminate progress, and
/// offers various customization options for size, color, and labels.
///
/// Features:
/// - Supports linear and circular variants ([AtomicProgressVariant]).
/// - Three predefined sizes ([AtomicProgressSize]).
/// - Customizable background and value colors.
/// - Optional label and percentage display.
/// - Semantic labels for accessibility.
///
/// Example usage:
/// ```dart
/// // Linear determinate progress
/// AtomicProgress(
///   value: 0.7,
///   variant: AtomicProgressVariant.linear,
///   size: AtomicProgressSize.medium,
///   label: 'Downloading...',
///   showPercentage: true,
/// )
///
/// // Circular indeterminate progress
/// AtomicProgress.circular(
///   size: AtomicProgressSize.large,
///   valueColor: Colors.green,
/// )
/// ```
class AtomicProgress extends StatelessWidget {
  /// The current progress value, from 0.0 to 1.0.
  /// If null, the indicator is indeterminate.
  final double? value;

  /// The color of the track behind the progress indicator.
  final Color? backgroundColor;

  /// The color of the progress indicator itself.
  final Color? valueColor;

  /// The visual variant of the progress indicator (linear or circular).
  final AtomicProgressVariant variant;

  /// The size of the progress indicator.
  final AtomicProgressSize size;

  /// The width of the progress indicator's stroke (for circular) or height (for linear).
  final double? strokeWidth;

  /// An optional label to display above the progress indicator.
  final String? label;

  /// If true, displays the percentage completion next to the progress indicator.
  final bool showPercentage;

  /// A semantic label for accessibility purposes.
  final String? semanticLabel;

  /// The external margin around the progress indicator.
  final EdgeInsetsGeometry? margin;

  /// Creates an [AtomicProgress] widget.
  ///
  /// [value] is the current progress (0.0 to 1.0). If null, it's indeterminate.
  /// [backgroundColor] is the color of the track.
  /// [valueColor] is the color of the progress.
  /// [variant] specifies linear or circular. Defaults to [AtomicProgressVariant.linear].
  /// [size] defines the size. Defaults to [AtomicProgressSize.medium].
  /// [strokeWidth] customizes the thickness.
  /// [label] is text displayed above.
  /// [showPercentage] displays percentage if true and [value] is not null.
  /// [semanticLabel] for accessibility.
  /// [margin] for external spacing.
  const AtomicProgress({
    super.key,
    this.value,
    this.backgroundColor,
    this.valueColor,
    this.variant = AtomicProgressVariant.linear,
    this.size = AtomicProgressSize.medium,
    this.strokeWidth,
    this.label,
    this.showPercentage = false,
    this.semanticLabel,
    this.margin,
  });

  /// Creates a linear [AtomicProgress] indicator.
  ///
  /// [value] is the current progress (0.0 to 1.0). If null, it's indeterminate.
  /// [backgroundColor] is the color of the track.
  /// [valueColor] is the color of the progress.
  /// [size] defines the size. Defaults to [AtomicProgressSize.medium].
  /// [label] is text displayed above.
  /// [showPercentage] displays percentage if true and [value] is not null.
  /// [semanticLabel] for accessibility.
  /// [margin] for external spacing.
  const AtomicProgress.linear({
    super.key,
    this.value,
    this.backgroundColor,
    this.valueColor,
    this.size = AtomicProgressSize.medium,
    this.label,
    this.showPercentage = false,
    this.semanticLabel,
    this.margin,
  })  : variant = AtomicProgressVariant.linear,
        strokeWidth = null;

  /// Creates a circular [AtomicProgress] indicator.
  ///
  /// [value] is the current progress (0.0 to 1.0). If null, it's indeterminate.
  /// [backgroundColor] is the color of the track.
  /// [valueColor] is the color of the progress.
  /// [size] defines the size. Defaults to [AtomicProgressSize.medium].
  /// [strokeWidth] customizes the thickness.
  /// [label] is text displayed above.
  /// [showPercentage] displays percentage if true and [value] is not null.
  /// [semanticLabel] for accessibility.
  /// [margin] for external spacing.
  const AtomicProgress.circular({
    super.key,
    this.value,
    this.backgroundColor,
    this.valueColor,
    this.size = AtomicProgressSize.medium,
    this.strokeWidth,
    this.label,
    this.showPercentage = false,
    this.semanticLabel,
    this.margin,
  }) : variant = AtomicProgressVariant.circular;

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);

    return Container(
      margin: margin,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: variant == AtomicProgressVariant.linear
            ? CrossAxisAlignment.stretch
            : CrossAxisAlignment.center,
        children: [
          if (label != null) ...[
            AtomicText.bodyMedium(
              label!,
              style: TextStyle(
                color: theme.colors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: theme.spacing.sm),
          ],
          _buildProgress(theme),
          if (showPercentage && value != null) ...[
            SizedBox(height: theme.spacing.xs),
            AtomicText.bodySmall(
              '${(value! * 100).round()}%',
              style: TextStyle(
                color: theme.colors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: variant == AtomicProgressVariant.circular
                  ? TextAlign.center
                  : TextAlign.end,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProgress(AtomicThemeData theme) {
    final effectiveValueColor = valueColor ?? theme.colors.primary;
    final effectiveBackgroundColor = backgroundColor ?? theme.colors.gray200;

    if (variant == AtomicProgressVariant.circular) {
      return _buildCircularProgress(
          theme, effectiveValueColor, effectiveBackgroundColor);
    } else {
      return _buildLinearProgress(
          theme, effectiveValueColor, effectiveBackgroundColor);
    }
  }

  Widget _buildLinearProgress(
    AtomicThemeData theme,
    Color valueColor,
    Color backgroundColor,
  ) {
    final height = _getLinearHeight();

    return SizedBox(
      height: height,
      child: LinearProgressIndicator(
        value: value,
        backgroundColor: backgroundColor,
        valueColor: AlwaysStoppedAnimation<Color>(valueColor),
        semanticsLabel: semanticLabel,
        semanticsValue: value != null ? '${(value! * 100).round()}%' : null,
      ),
    );
  }

  Widget _buildCircularProgress(
    AtomicThemeData theme,
    Color valueColor,
    Color backgroundColor,
  ) {
    final circularSize = _getCircularSize();
    final effectiveStrokeWidth = strokeWidth ?? _getDefaultStrokeWidth();

    return SizedBox(
      width: circularSize,
      height: circularSize,
      child: CircularProgressIndicator(
        value: value,
        backgroundColor: backgroundColor,
        valueColor: AlwaysStoppedAnimation<Color>(valueColor),
        strokeWidth: effectiveStrokeWidth,
        semanticsLabel: semanticLabel,
        semanticsValue: value != null ? '${(value! * 100).round()}%' : null,
      ),
    );
  }

  double _getLinearHeight() {
    switch (size) {
      case AtomicProgressSize.small:
        return 2.0;
      case AtomicProgressSize.medium:
        return 4.0;
      case AtomicProgressSize.large:
        return 6.0;
    }
  }

  double _getCircularSize() {
    switch (size) {
      case AtomicProgressSize.small:
        return 16.0;
      case AtomicProgressSize.medium:
        return 24.0;
      case AtomicProgressSize.large:
        return 32.0;
    }
  }

  double _getDefaultStrokeWidth() {
    switch (size) {
      case AtomicProgressSize.small:
        return 2.0;
      case AtomicProgressSize.medium:
        return 3.0;
      case AtomicProgressSize.large:
        return 4.0;
    }
  }
}

/// A card component that displays a progress indicator along with a title and optional details.
///
/// The [AtomicProgressCard] is useful for showing the status of a specific item
/// or task within a card-like layout. It combines a title, subtitle, icon,
/// and a progress bar, with an optional tap action.
///
/// Features:
/// - Displays a title, optional subtitle, and leading icon.
/// - Integrates an [AtomicProgress] indicator.
/// - Shows percentage completion.
/// - Customizable colors for progress and background.
/// - Optional tap interaction for the entire card.
///
/// Example usage:
/// ```dart
/// AtomicProgressCard(
///   title: 'Task Completion',
///   subtitle: 'Progress for current sprint',
///   value: 0.8,
///   icon: Icons.task_alt,
///   valueColor: Colors.purple,
///   onTap: () {
///     print('Progress card tapped!');
///   },
/// )
/// ```
class AtomicProgressCard extends StatelessWidget {
  /// The current progress value, from 0.0 to 1.0.
  final double? value;

  /// The main title of the progress card.
  final String title;

  /// An optional subtitle displayed below the title.
  final String? subtitle;

  /// An optional leading icon for the card.
  final IconData? icon;

  /// The color of the progress indicator within the card.
  final Color? valueColor;

  /// The background color of the progress track within the card.
  final Color? backgroundColor;

  /// The visual variant of the progress indicator (linear or circular).
  final AtomicProgressVariant variant;

  /// If true, displays the percentage completion on the card.
  final bool showPercentage;

  /// The callback function executed when the card is tapped.
  final VoidCallback? onTap;

  /// The external margin around the card.
  final EdgeInsetsGeometry? margin;

  /// The internal padding of the card.
  final EdgeInsetsGeometry? padding;

  /// Creates an [AtomicProgressCard].
  ///
  /// [value] is the current progress (0.0 to 1.0).
  /// [title] is the main title.
  /// [subtitle] is an optional secondary text.
  /// [icon] is an optional leading icon.
  /// [valueColor] is the color of the progress.
  /// [backgroundColor] is the color of the progress track.
  /// [variant] specifies linear or circular progress. Defaults to [AtomicProgressVariant.linear].
  /// [showPercentage] displays percentage if true. Defaults to true.
  /// [onTap] is the callback for card tap.
  /// [margin] for external spacing.
  /// [padding] for internal spacing.
  const AtomicProgressCard({
    super.key,
    this.value,
    required this.title,
    this.subtitle,
    this.icon,
    this.valueColor,
    this.backgroundColor,
    this.variant = AtomicProgressVariant.linear,
    this.showPercentage = true,
    this.onTap,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);

    return Container(
      margin: margin,
      child: Material(
        color: theme.colors.surface,
        borderRadius: BorderRadius.circular(12),
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: padding ?? EdgeInsets.all(theme.spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        color: valueColor ?? theme.colors.primary,
                        size: 20,
                      ),
                      SizedBox(width: theme.spacing.sm),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AtomicText.bodyLarge(
                            title,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: theme.colors.textPrimary,
                            ),
                          ),
                          if (subtitle != null) ...[
                            SizedBox(height: theme.spacing.xs),
                            AtomicText.bodySmall(
                              subtitle!,
                              style: TextStyle(
                                color: theme.colors.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (showPercentage && value != null)
                      AtomicText.bodyLarge(
                        '${(value! * 100).round()}%',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: valueColor ?? theme.colors.primary,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: theme.spacing.md),
                AtomicProgress(
                  value: value,
                  valueColor: valueColor,
                  backgroundColor: backgroundColor,
                  variant: variant,
                  size: AtomicProgressSize.medium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A widget that displays a multi-step progress indicator.
///
/// The [AtomicStepProgress] visually guides the user through a series of steps,
/// highlighting the current step and indicating completed ones. It supports
/// both horizontal and vertical orientations.
///
/// Features:
/// - Displays a list of [AtomicProgressStep]s.
/// - Highlights the [currentStep].
/// - Customizable colors for active, inactive, and completed steps.
/// - Supports horizontal and vertical orientations.
/// - Optional margin for external spacing.
///
/// Example usage:
/// ```dart
/// AtomicStepProgress(
///   steps: const [
///     AtomicProgressStep(title: 'Personal Info', subtitle: 'Enter your details'),
///     AtomicProgressStep(title: 'Address', subtitle: 'Provide your address'),
///     AtomicProgressStep(title: 'Payment', subtitle: 'Complete payment'),
///     AtomicProgressStep(title: 'Confirmation', subtitle: 'Review your order'),
///   ],
///   currentStep: 1, // Second step is active
///   orientation: AtomicStepProgressOrientation.horizontal,
/// )
/// ```
class AtomicStepProgress extends StatelessWidget {
  /// A list of steps to display in the progress indicator.
  final List<AtomicProgressStep> steps;

  /// The index of the currently active step (0-based).
  final int currentStep;

  /// The color of the active step.
  final Color? activeColor;

  /// The color of the inactive steps.
  final Color? inactiveColor;

  /// The color of the completed steps.
  final Color? completedColor;

  /// The orientation of the step progress indicator (horizontal or vertical).
  final AtomicStepProgressOrientation orientation;

  /// The external margin around the step progress indicator.
  final EdgeInsetsGeometry? margin;

  /// Creates an [AtomicStepProgress] widget.
  ///
  /// [steps] is a list of [AtomicProgressStep]s.
  /// [currentStep] is the 0-based index of the active step.
  /// [activeColor] is the color for the active step.
  /// [inactiveColor] is the color for inactive steps.
  /// [completedColor] is the color for completed steps.
  /// [orientation] specifies horizontal or vertical layout. Defaults to [AtomicStepProgressOrientation.horizontal].
  /// [margin] for external spacing.
  const AtomicStepProgress({
    super.key,
    required this.steps,
    required this.currentStep,
    this.activeColor,
    this.inactiveColor,
    this.completedColor,
    this.orientation = AtomicStepProgressOrientation.horizontal,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);
    final effectiveActiveColor = activeColor ?? theme.colors.primary;
    final effectiveInactiveColor = inactiveColor ?? theme.colors.gray300;
    final effectiveCompletedColor = completedColor ?? theme.colors.success;

    return Container(
      margin: margin,
      child: orientation == AtomicStepProgressOrientation.horizontal
          ? _buildHorizontalSteps(theme, effectiveActiveColor,
              effectiveInactiveColor, effectiveCompletedColor)
          : _buildVerticalSteps(theme, effectiveActiveColor,
              effectiveInactiveColor, effectiveCompletedColor),
    );
  }

  Widget _buildHorizontalSteps(
    AtomicThemeData theme,
    Color activeColor,
    Color inactiveColor,
    Color completedColor,
  ) {
    return Row(
      children: [
        for (int i = 0; i < steps.length; i++) ...[
          _buildStepCircle(
            theme,
            steps[i],
            i,
            activeColor,
            inactiveColor,
            completedColor,
          ),
          if (i < steps.length - 1)
            Expanded(
              child: _buildConnector(
                theme,
                i < currentStep ? completedColor : inactiveColor,
              ),
            ),
        ],
      ],
    );
  }

  Widget _buildVerticalSteps(
    AtomicThemeData theme,
    Color activeColor,
    Color inactiveColor,
    Color completedColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < steps.length; i++) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStepCircle(
                theme,
                steps[i],
                i,
                activeColor,
                inactiveColor,
                completedColor,
              ),
              SizedBox(width: theme.spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AtomicText.bodyMedium(
                      steps[i].title,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: i <= currentStep
                            ? theme.colors.textPrimary
                            : theme.colors.textSecondary,
                      ),
                    ),
                    if (steps[i].subtitle != null) ...[
                      SizedBox(height: theme.spacing.xs),
                      AtomicText.bodySmall(
                        steps[i].subtitle!,
                        style: TextStyle(
                          color: theme.colors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (i < steps.length - 1) ...[
            SizedBox(height: theme.spacing.sm),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: _buildVerticalConnector(
                theme,
                i < currentStep ? completedColor : inactiveColor,
              ),
            ),
            SizedBox(height: theme.spacing.sm),
          ],
        ],
      ],
    );
  }

  Widget _buildStepCircle(
    AtomicThemeData theme,
    AtomicProgressStep step,
    int index,
    Color activeColor,
    Color inactiveColor,
    Color completedColor,
  ) {
    final isCompleted = index < currentStep;
    final isActive = index == currentStep;
    final color =
        isCompleted ? completedColor : (isActive ? activeColor : inactiveColor);

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isCompleted || isActive ? color : Colors.transparent,
        border: Border.all(color: color, width: 2),
        shape: BoxShape.circle,
      ),
      child: isCompleted
          ? Icon(
              Icons.check,
              size: 16,
              color: theme.colors.textInverse,
            )
          : Center(
              child: AtomicText.bodySmall(
                '${index + 1}',
                style: TextStyle(
                  color: isActive ? theme.colors.textInverse : color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }

  Widget _buildConnector(AtomicThemeData theme, Color color) {
    return Container(
      height: 2,
      color: color,
      margin: EdgeInsets.symmetric(horizontal: theme.spacing.sm),
    );
  }

  Widget _buildVerticalConnector(AtomicThemeData theme, Color color) {
    return Container(
      width: 2,
      height: 24,
      color: color,
    );
  }
}

/// A model representing a single step in a multi-step progress indicator.
class AtomicProgressStep {
  /// The title of the step.
  final String title;

  /// An optional subtitle for the step.
  final String? subtitle;

  /// An optional icon for the step.
  final IconData? icon;

  /// Creates an [AtomicProgressStep].
  ///
  /// [title] is the main text for the step.
  /// [subtitle] is an optional secondary text.
  /// [icon] is an optional icon for the step.
  const AtomicProgressStep({
    required this.title,
    this.subtitle,
    this.icon,
  });
}

/// Defines the visual variants for an [AtomicProgress] indicator.
enum AtomicProgressVariant {
  /// A linear progress indicator (horizontal bar).
  linear,

  /// A circular progress indicator.
  circular,
}

/// Defines the predefined sizes for an [AtomicProgress] indicator.
enum AtomicProgressSize {
  /// A small progress indicator.
  small,

  /// A medium-sized progress indicator.
  medium,

  /// A large progress indicator.
  large,
}

/// Defines the orientation for an [AtomicStepProgress] indicator.
enum AtomicStepProgressOrientation {
  /// Horizontal layout for steps.
  horizontal,

  /// Vertical layout for steps.
  vertical,
}
