import 'package:bbpool/config/app_colors.dart';
import 'package:flutter/material.dart';

class GroupDetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const GroupDetailItem(
      {super.key,
      required this.icon,
      required this.label,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline:
              TextBaseline.alphabetic, // required for baseline alignment
          children: [
            Icon(icon, size: 12, color: AppColors.gradientButtonEnd),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 10, // match icon size for clean alignment
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
    ;
  }
}
