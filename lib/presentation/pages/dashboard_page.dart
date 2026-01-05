import 'package:flutter/material.dart';
import '../../design_system/styles.dart';
import '../../models/task_model.dart';
import '../../controllers/task_controller.dart';
import '../widgets/stat_card.dart';
import '../widgets/task_card.dart';
import 'task_list_page.dart';
import 'add_task_page.dart';
import 'task_detail_page.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TaskController _controller = TaskController();
  List<Task> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final tasks = await _controller.fetchTasks();
      setState(() {
        _tasks = tasks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    int total = _tasks.length;
    int selesai = _tasks.where((t) => t.isDone).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Beranda", style: AppTextStyles.title),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
      ),
      body: _isLoading 
        ? Center(child: CircularProgressIndicator()) 
        : RefreshIndicator(
            onRefresh: _loadData,
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                Text("Tugas Besar", style: AppTextStyles.title),
                SizedBox(height: 16),

                Row(
                  children: [
                    StatCard(label: "Total Tugas", count: "$total"),
                    SizedBox(width: 16),
                    StatCard(label: "Selesai", count: "$selesai"),
                  ],
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Tugas Terdekat", style: AppTextStyles.section),
                    TextButton(
                      onPressed: () async {
                        await Navigator.push(context, MaterialPageRoute(builder: (_) => TaskListPage()));
                        _loadData();
                      },
                      child: Text("Lihat Semua"),
                    )
                  ],
                ),
                ..._tasks.take(3).map((task) => TaskCard(
                  task: task,
                  onTap: () async {
                    await Navigator.push(context, MaterialPageRoute(builder: (_) => TaskDetailPage(task: task)));
                    _loadData();
                  },
                )),
              ],
            ),
          ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        label: Text("Tambah Tugas", style: TextStyle(color: AppColors.background) ),
        icon: Icon(Icons.add, color: AppColors.background),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => AddTaskPage()));
          _loadData();
        },
      ),
    );
  }
}