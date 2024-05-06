import 'package:flutter/material.dart';
import 'package:gallery_app/features/widgets/single_metric.dart';

class MetricGroups extends StatelessWidget {
  const MetricGroups({
    super.key,
    required this.likesValue,
    required this.viewsValue,
    required this.onLikesTap,
    required this.onViewsTap,
  });

  final int likesValue;
  final int viewsValue;
  final VoidCallback onLikesTap;
  final VoidCallback onViewsTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SingleMetric(
          value: likesValue,
          type: MetricType.likes,
          onTap: onLikesTap,
        ),
        const SizedBox(width: 8),
        SingleMetric(
          value: viewsValue,
          type: MetricType.views,
          onTap: onViewsTap,
        ),
      ],
    );
  }
}
