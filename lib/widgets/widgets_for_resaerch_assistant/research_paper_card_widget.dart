import 'package:flutter/material.dart';
import 'package:maisys/theme/color_manager.dart';
import 'package:maisys/theme/style_helper.dart';

class ResearchPaperCardWidget extends StatelessWidget {
  final String title;
  final String authors;
  final String journal;
  final String description;
  final VoidCallback onTap;

  const ResearchPaperCardWidget({
    super.key,
    required this.title,
    required this.authors,
    required this.journal,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color(0xFF1E2A3A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Color(0xFF2D3E50),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              title,
              style: TextStyles.font16white600w,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: 8),

            // Authors
            Text(
              authors,
              style: TextStyles.font12lightgray400w.copyWith(
                color: ColorManager.primaryBlue,
              ),
            ),

            SizedBox(height: 5),

            // Journal
            Text(
              journal,
              style: TextStyles.font12lightgray400w.copyWith(
                color: Colors.white54,
              ),
            ),

            SizedBox(height: 10),

            // Description
            Text(
              description,
              style: TextStyles.font12lightgray400w.copyWith(
                color: Colors.white70,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}