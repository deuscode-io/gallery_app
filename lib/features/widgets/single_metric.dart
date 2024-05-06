import 'package:flutter/material.dart';

enum MetricType {
  likes,
  views;

  IconData get iconData {
    switch (this) {
      case MetricType.likes:
        return Icons.thumb_up_alt_outlined;
      default:
        return Icons.remove_red_eye_outlined;
    }
  }

  TextDirection get textDirection {
    switch (this) {
      case MetricType.likes:
        return TextDirection.ltr;
      default:
        return TextDirection.rtl;
    }
  }

  TextAlign get textAlign {
    switch (this) {
      case MetricType.likes:
        return TextAlign.start;
      default:
        return TextAlign.end;
    }
  }

  EdgeInsets get padding {
    switch (this) {
      case MetricType.likes:
        return const EdgeInsets.only(left: 8);
      default:
        return const EdgeInsets.only(right: 8);
    }
  }
}

class SingleMetric extends StatelessWidget {
  const SingleMetric({
    super.key,
    required this.value,
    required this.type,
    required this.onTap,
  });

  final int value;
  final MetricType type;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        customBorder: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        onTap: onTap,
        child: Padding(
          padding: type.padding,
          child: Row(
            textDirection: type.textDirection,
            children: [
              Icon(type.iconData, size: 18),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  value.toString(),
                  overflow: TextOverflow.ellipsis,
                  textAlign: type.textAlign,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
