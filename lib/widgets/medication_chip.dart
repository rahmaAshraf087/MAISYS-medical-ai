import 'package:flutter/material.dart';
import 'package:maisys/theme/color_manager.dart';
import 'package:maisys/theme/style_helper.dart';

class MedicationChip extends StatelessWidget {
  final String label;
  final VoidCallback onDeleted;

  const MedicationChip({
    super.key,
    required this.label,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: ColorManager.primaryBlue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyles.font14whitebold,
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: onDeleted,
            child: Icon(
              Icons.close,
              color: Colors.white,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}