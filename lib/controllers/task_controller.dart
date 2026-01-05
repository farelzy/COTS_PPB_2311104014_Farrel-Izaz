import '../models/task_model.dart';
import '../services/task_service.dart';

class TaskController {
  final TaskService _service = TaskService();

  Future<List<Task>> fetchTasks() async {
    try {
      return await _service.getTasks();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> addTask(Task task) async {
    return await _service.addTask(task);
  }

  Future<bool> updateTask(int id, Map<String, dynamic> data) async {
    return await _service.updateTask(id, data);
  }

  List<Task> filterTasks(List<Task> allTasks, String query, String statusFilter) {
    return allTasks.where((task) {
      final matchesSearch = task.title.toLowerCase().contains(query.toLowerCase()) ||
                            task.course.toLowerCase().contains(query.toLowerCase());
      
      bool matchesStatus = true;
      final now = DateTime.now();
      
      final deadlineDate = DateTime.tryParse(task.deadline);
      // Buat batas akhir hari deadline (Jam 23:59:59)
      final deadlineEnd = deadlineDate != null 
          ? DateTime(deadlineDate.year, deadlineDate.month, deadlineDate.day, 23, 59, 59)
          : null;

      bool isOverdue = false;
      if (deadlineEnd != null) {
        isOverdue = now.isAfter(deadlineEnd) && !task.isDone;
      }

      if (statusFilter == "Semua") {
        matchesStatus = true;
      } else if (statusFilter == "Selesai") {
        matchesStatus = task.isDone;
      } else if (statusFilter == "Berjalan") {
        matchesStatus = !task.isDone && !isOverdue; 
      } else if (statusFilter == "Terlambat") {
        matchesStatus = task.status == "TERLAMBAT" || isOverdue;
      }

      return matchesSearch && matchesStatus;
    }).toList();
  }
}