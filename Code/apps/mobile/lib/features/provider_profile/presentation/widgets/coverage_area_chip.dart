import 'package:flutter/material.dart';
import 'package:sanaya/core/widgets/app_badge.dart';

/// Puce affichant une zone d'intervention (gouvernorat ou délégation).
class CoverageAreaChip extends StatelessWidget {
  const CoverageAreaChip({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return AppBadge(
      label: label,
      variant: AppBadgeVariant.neutral,
      bordered: true,
    );
  }
}
