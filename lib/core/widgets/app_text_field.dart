import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class AppTextField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool autofocus;

  const AppTextField({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTypography.secondary.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6.0),
        ],
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          onChanged: onChanged,
          onTap: onTap,
          readOnly: readOnly,
          autofocus: autofocus,
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}

/// Reusable Search input field with consistent clear button & accessibility label.
class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final bool autofocus;

  const SearchField({
    super.key,
    required this.controller,
    this.hintText = 'Search...',
    this.onChanged,
    this.onClear,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextField(
      controller: controller,
      autofocus: autofocus,
      onChanged: onChanged,
      style: AppTypography.bodyMedium.copyWith(
        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: isDark ? AppColors.darkSurface : AppColors.surface,
        prefixIcon: Icon(
          AppIcons.search,
          size: 20.0,
          color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
        ),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                tooltip: 'Clear search',
                icon: const Icon(AppIcons.close, size: 18.0),
                onPressed: () {
                  controller.clear();
                  onClear?.call();
                  onChanged?.call('');
                },
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        border: OutlineInputBorder(
          borderRadius: AppRadii.roundedFull,
          borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadii.roundedFull,
          borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadii.roundedFull,
          borderSide: BorderSide(
            color: isDark ? AppColors.primaryDark : AppColors.primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

/// Accessible Selection Field for dates, times, and pickers.
class SelectionField extends StatelessWidget {
  final String label;
  final String valueText;
  final IconData icon;
  final VoidCallback onTap;
  final bool isPlaceholder;
  final VoidCallback? onClear;

  const SelectionField({
    super.key,
    required this.label,
    required this.valueText,
    required this.icon,
    required this.onTap,
    this.isPlaceholder = false,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Semantics(
      button: true,
      label: '$label: $valueText',
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.roundedMd,
        child: Container(
          constraints: const BoxConstraints(minHeight: 48.0),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10.0),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceElevated : AppColors.surface,
            borderRadius: AppRadii.roundedMd,
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18.0,
                color: isPlaceholder
                    ? (isDark ? AppColors.darkTextTertiary : AppColors.textTertiary)
                    : (isDark ? AppColors.primaryDark : AppColors.primary),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: AppTypography.metadata.copyWith(
                        fontSize: 10.5,
                        color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                      ),
                    ),
                    Text(
                      valueText,
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: isPlaceholder ? FontWeight.w400 : FontWeight.w600,
                        color: isPlaceholder
                            ? (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary)
                            : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (onClear != null && !isPlaceholder)
                IconButton(
                  icon: const Icon(AppIcons.close, size: 16.0),
                  tooltip: 'Clear $label',
                  visualDensity: VisualDensity.compact,
                  onPressed: onClear,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
