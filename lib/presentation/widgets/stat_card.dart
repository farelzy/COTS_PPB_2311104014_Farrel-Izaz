import 'package:flutter/material.dart';
import '../../design_system/styles.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String count;

  const StatCard({
    Key? key, 
    required this.label, 
    required this.count
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: Offset(0, 2))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.body),
            SizedBox(height: 8),
            Text(count, style: AppTextStyles.title.copyWith(fontSize: 32)),
          ],
        ),
      ),
    );
  }
}