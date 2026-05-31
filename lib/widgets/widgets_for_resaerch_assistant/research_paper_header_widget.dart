import 'package:flutter/material.dart';

import 'package:maisys/theme/style_helper.dart';

class ResearchPaperHeaderWidget extends StatelessWidget {
  final String paperTitle;
  final VoidCallback onBack;

  const ResearchPaperHeaderWidget({
    super.key,
    required this.paperTitle,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Color(0xFF1E2A3A),
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF2D3E50),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: onBack,
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Back',
                  style: TextStyles.font14whitebold,
                ),
              ],
            ),
          ),

          SizedBox(width: 20),

          // Paper Title
          Expanded(
            child: Text(
              'Paper: $paperTitle',
              style: TextStyles.font16white600w,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}