import 'package:flutter/material.dart';

class AmountPercentageToggle extends StatelessWidget {
  final bool isPercentMode;
  final ValueChanged<bool> onToggle;

  const AmountPercentageToggle({
    super.key,
    required this.isPercentMode,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(child: _buildToggleButton('Amount', !isPercentMode, theme)),
          Expanded(
            child: _buildToggleButton('Percentage', isPercentMode, theme),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label, bool isActive, ThemeData theme) {
    return GestureDetector(
      onTap: () => onToggle(label == 'Percentage'),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isActive
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
