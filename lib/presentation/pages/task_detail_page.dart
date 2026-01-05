import 'package:flutter/material.dart';
import '../../design_system/styles.dart';
import '../../models/task_model.dart';
import '../../services/task_service.dart';
import '../../controllers/task_controller.dart';

class TaskDetailPage extends StatefulWidget {
  final Task task;
  TaskDetailPage({required this.task});

  @override
  _TaskDetailPageState createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  final TaskController _controller = TaskController();
  late Task _task;
  final _noteController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
    _noteController.text = _task.note;
  }

  Future<void> _updateStatus(bool? isDone) async {
    if (isDone == null) return;
    setState(() => _isLoading = true);

    String newStatus;

    DateTime deadlineDate = DateTime.parse(_task.deadline);

    DateTime deadlineLimit = DateTime(
      deadlineDate.year,
      deadlineDate.month,
      deadlineDate.day,
      23,
      59,
      59,
    );

    DateTime now = DateTime.now();

    if (isDone) {
      if (now.isAfter(deadlineLimit)) {
        newStatus = "TERLAMBAT"; // Selesai, tapi submit lewat deadline
      } else {
        newStatus = "SELESAI"; // Selesai tepat waktu
      }
    } else {
      if (now.isAfter(deadlineLimit)) {
        newStatus = "TERLAMBAT";
      } else {
        newStatus = "BERJALAN";
      }
    }

    final success = await _controller.updateTask(_task.id!, {
      "is_done": isDone,
      "status": newStatus,
    });

    if (success) {
      setState(() {
        _task = Task(
          id: _task.id,
          title: _task.title,
          course: _task.course,
          deadline: _task.deadline,
          status: newStatus,
          note: _task.note,
          isDone: isDone,
        );
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal update status")));
    }
  }

  Future<void> _saveNote() async {
    setState(() => _isLoading = true);
    final success = await TaskService().updateTask(_task.id!, {
      "note": _noteController.text,
    });
    setState(() => _isLoading = false);
    if (success) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Detail Tugas", style: AppTextStyles.section),
        leading: BackButton(color: AppColors.text),
        backgroundColor: AppColors.surface,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Judul Tugas", style: AppTextStyles.caption),
                SizedBox(height: 4),
                Text(_task.title, style: AppTextStyles.title),
                SizedBox(height: 12),

                Text("Mata Kuliah", style: AppTextStyles.caption),
                SizedBox(height: 4),
                Text(_task.course, style: AppTextStyles.body),
                SizedBox(height: 12),

                Text("Deadline", style: AppTextStyles.caption),
                SizedBox(height: 4),
                Text(_task.deadline, style: AppTextStyles.body),
                SizedBox(height: 12),

                Text("Status", style: AppTextStyles.caption),
                SizedBox(height: 6),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _task.status,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          Text("Penyelesaian", style: AppTextStyles.section),
          SizedBox(height: 8),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: Text("Tugas sudah selesai"),
            subtitle: Text("Centang jika tugas sudah final"),
            value: _task.isDone,
            onChanged: _updateStatus,
            activeColor: AppColors.primary,
          ),
          SizedBox(height: 24),
          Text("Catatan", style: AppTextStyles.section),
          SizedBox(height: 8),
          TextField(
            controller: _noteController,
            maxLines: 4,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              hintText: "Catatan tambahan...",
            ),
          ),
          SizedBox(height: 24),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              onPressed: _isLoading ? null : _saveNote,
              child: Text("Simpan Perubahan", style: TextStyle(color: AppColors.background),),
            ),
          ),
        ],
      ),
    );
  }
}
