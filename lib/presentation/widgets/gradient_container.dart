import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../providers/theme_provider.dart';

class GradientContainer extends StatelessWidget {
  final Widget child;
  final LinearGradient? gradient;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final List<BoxShadow>? boxShadow;

  const GradientContainer({
    super.key,
    required this.child,
    this.gradient,
    this.borderRadius,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onTap,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    Widget container = Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        gradient: gradient ?? AppColors.primaryGradient,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        boxShadow:
            boxShadow ??
            [
              BoxShadow(
                color: (gradient?.colors.first ?? AppColors.primary1)
                    .withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: container);
    }

    return container;
  }
}

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final LinearGradient? gradient;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final TextStyle? textStyle;
  final Widget? icon;
  final bool isLoading;

  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.gradient,
    this.padding,
    this.borderRadius,
    this.textStyle,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      gradient: gradient ?? AppColors.primaryGradient,
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      onTap: isLoading ? null : onPressed,
      child: Padding(
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            else if (icon != null) ...[
              icon!,
              const SizedBox(width: 6),
            ],
            if (!isLoading)
              Flexible(
                child: Text(
                  text,
                  style:
                      textStyle ??
                      Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class GradientCard extends StatelessWidget {
  final Widget child;
  final LinearGradient? gradient;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final bool isElevated;

  const GradientCard({
    super.key,
    required this.child,
    this.gradient,
    this.padding,
    this.margin,
    this.onTap,
    this.isElevated = true,
  });

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      gradient: gradient ?? AppColors.lightCardGradient,
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onTap: onTap,
      boxShadow: isElevated
          ? [
              BoxShadow(
                color: AppColors.primary1.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: AppColors.primary2.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ]
          : null,
      child: child,
    );
  }
}

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final LinearGradient? gradient;
  final bool showThemeToggle;

  const GradientAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.bottom,
    this.gradient,
    this.showThemeToggle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient ?? AppColors.primaryGradient,
      ),
      child: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: leading,
        actions: [
          if (showThemeToggle) ...[
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return IconButton(
                  icon: Icon(themeProvider.themeIcon, color: Colors.white),
                  onPressed: () => themeProvider.toggleTheme(),
                  tooltip: themeProvider.themeLabel,
                );
              },
            ),
          ],
          if (actions != null) ...actions!,
        ],
        bottom: bottom,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme: const IconThemeData(color: Colors.white),
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}
