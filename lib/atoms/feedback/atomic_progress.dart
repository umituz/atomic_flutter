import 'package:flutter/material.dart';
import '../../themes/atomic_theme_provider.dart';
import '../../themes/atomic_theme_data.dart';
import '../display/atomic_text.dart';

class AtomicProgress extends StatelessWidget {
  final double? value;
  final Color? backgroundColor;
  final Color? valueColor;
  final AtomicProgressVariant variant;
  final AtomicProgressSize size;
  final double? strokeWidth;
  final String? label;
  final bool showPercentage;
  final String? semanticLabel;
  final EdgeInsetsGeometry? margin;

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
  }) : variant = AtomicProgressVariant.linear,
       strokeWidth = null;

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
      return _buildCircularProgress(theme, effectiveValueColor, effectiveBackgroundColor);
    } else {
      return _buildLinearProgress(theme, effectiveValueColor, effectiveBackgroundColor);
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

class AtomicProgressCard extends StatelessWidget {
  final double? value;
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? valueColor;
  final Color? backgroundColor;
  final AtomicProgressVariant variant;
  final bool showPercentage;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

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

class AtomicStepProgress extends StatelessWidget {
  final List<AtomicProgressStep> steps;
  final int currentStep;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? completedColor;
  final AtomicStepProgressOrientation orientation;
  final EdgeInsetsGeometry? margin;

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
        ? _buildHorizontalSteps(theme, effectiveActiveColor, effectiveInactiveColor, effectiveCompletedColor)
        : _buildVerticalSteps(theme, effectiveActiveColor, effectiveInactiveColor, effectiveCompletedColor),
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
    final color = isCompleted ? completedColor : (isActive ? activeColor : inactiveColor);
    
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

class AtomicProgressStep {
  final String title;
  final String? subtitle;
  final IconData? icon;

  const AtomicProgressStep({
    required this.title,
    this.subtitle,
    this.icon,
  });
}

enum AtomicProgressVariant {
  linear,
  circular,
}

enum AtomicProgressSize {
  small,
  medium,
  large,
}

enum AtomicStepProgressOrientation {
  horizontal,
  vertical,
} 