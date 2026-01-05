import 'package:flutter/material.dart';
import '../../design_system/styles.dart';
import '../../models/task_model.dart';
import '../../controllers/task_controller.dart';
import '../widgets/task_card.dart';
import 'task_detail_page.dart';
import 'add_task_page.dart';

class TaskListPage extends StatefulWidget {
  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final TaskController _controller = TaskController();
  
  List<Task> _allTasks = [];
  List<Task> _displayedTasks = [];
  bool _isLoading = true;

  String _searchQuery = "";
  String _selectedFilter = "Semua";
  final List<String> _filterOptions = ["Semua", "Berjalan", "Selesai", "Terlambat"];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);
    try {
      final tasks = await _controller.fetchTasks();
      setState(() {
        _allTasks = tasks;
        _applyFilters();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _applyFilters() {
    setState(() {
      _displayedTasks = _controller.filterTasks(_allTasks, _searchQuery, _selectedFilter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Daftar Tugas", style: AppTextStyles.section),
        backgroundColor: AppColors.surface,
        leading: BackButton(color: AppColors.text),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: AppColors.primary),
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (_) => AddTaskPage()));
              _loadTasks();
            },
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: AppColors.surface,
            child: Column(
              children: [
                TextField(
                  onChanged: (val) {
                    _searchQuery = val;
                    _applyFilters();
                  },
                  decoration: InputDecoration(
                    hintText: "Cari tugas atau mata kuliah...",
                    prefixIcon: Icon(Icons.search, color: AppColors.muted),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 0)
                  ),
                ),
                SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filterOptions.map((filter) {
                      final isSelected = _selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedFilter = filter);
                              _applyFilters();
                            }
                          },
                          backgroundColor: AppColors.background,
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : AppColors.text,
                            fontWeight: FontWeight.w600
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          showCheckmark: false,
                        ),
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: _isLoading 
              ? Center(child: CircularProgressIndicator()) 
              : _displayedTasks.isEmpty 
                ? Center(child: Text("Tidak ada tugas ditemukan", style: AppTextStyles.caption))
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: _displayedTasks.length,
                    itemBuilder: (context, index) {
                      final task = _displayedTasks[index];
                      return TaskCard(
                        task: task,
                        onTap: () async {
                          await Navigator.push(context, MaterialPageRoute(builder: (_) => TaskDetailPage(task: task)));
                          _loadTasks();
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}