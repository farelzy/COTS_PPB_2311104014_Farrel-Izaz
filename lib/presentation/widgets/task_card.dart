import 'package:flutter/material.dart';
import '../../design_system/styles.dart';
import '../../models/task_model.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  const TaskCard({
    Key? key, 
    required this.task, 
    required this.onTap
  }) : super(key: key);

  String _formatDate(String rawDate) {
    try {
      DateTime date = DateTime.parse(rawDate);
      return DateFormat('d MMMM yyyy', 'id_ID').format(date);
    } catch (e) {
      return rawDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title, 
                    style: AppTextStyles.section,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(task.course, style: AppTextStyles.caption),
                  SizedBox(height: 8),
                  Text(
                    "Deadline: ${_formatDate(task.deadline)}",
                    style: AppTextStyles.caption.copyWith(color: AppColors.danger)
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            _buildStatusChip()
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    final isDone = task.isDone;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDone ? AppColors.background : AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        task.status,
        style: AppTextStyles.caption.copyWith(
          color: isDone ? AppColors.muted : AppColors.primary, 
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}