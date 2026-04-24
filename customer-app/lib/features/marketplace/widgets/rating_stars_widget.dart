import 'package:flutter/material.dart';

class RatingStarsWidget extends StatelessWidget {
  final double rating;
  final int? reviewCount;
  final double starSize;
  final bool showReviewCount;
  final TextStyle? reviewCountStyle;

  const RatingStarsWidget({
    super.key,
    required this.rating,
    this.reviewCount,
    this.starSize = 14,
    this.showReviewCount = true,
    this.reviewCountStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            return Icon(
              index < rating.round() ? Icons.star : Icons.star_border,
              size: starSize,
              color: Colors.amber,
            );
          }),
        ),
        if (showReviewCount && reviewCount != null && reviewCount! > 0) ...[
          const SizedBox(width: 4),
          Text(
            '($reviewCount)',
            style:
                reviewCountStyle ??
                TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ],
    );
  }
}
