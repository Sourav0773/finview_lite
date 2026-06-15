import 'package:finview_lite/core/util/time.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String userName;
  final VoidCallback onRefresh; 
  final VoidCallback onThemeToggle; 

  const Header({
    super.key,
    required this.userName,
    required this.onRefresh,
    required this.onThemeToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width > 840;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Timely greetings i.e morning, noon etc
            Text(
              Time.getSystemGreeting(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withAlpha(180),
              ),
            ),

            /// User name who has logged in
            Text(
              userName,
              style: theme.textTheme.titleLarge,
            ),
          ],
        ),
        Row(
          children: [
            /// Refresh button
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.refresh_rounded),
                  color: theme.colorScheme.onSurface,
                  onPressed: onRefresh,
                ),
                Text(
                  'Refresh',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            SizedBox(width: isDesktop ? 16 : 4),

            /// Theme switching button
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    theme.brightness == Brightness.dark
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined,
                    color: theme.colorScheme.onSurface,
                  ),
                  onPressed: onThemeToggle,
                ),
                Text(
                  theme.brightness == Brightness.dark
                      ? 'Light Theme'
                      : 'Dark Theme',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}