import 'package:flutter/material.dart';
import '../../design_system/styles.dart';
import '../../models/task_model.dart';
import '../../controllers/task_controller.dart';
import '../widgets/app_input.dart';

class AddTaskPage extends StatefulWidget {
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TaskController();
  
  final _titleController = TextEditingController();
  final _courseController = TextEditingController();
  final _dateController = TextEditingController();
  final _noteController = TextEditingController();
  
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Tambah Tugas", style: AppTextStyles.section),
        backgroundColor: AppColors.surface,
        leading: BackButton(color: AppColors.text),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            AppInput(label: "Judul Tugas", controller: _titleController, isRequired: true, disableNumbers: true,),
            AppInput(label: "Mata Kuliah", controller: _courseController, isRequired: true, disableNumbers: true,),
            
            AppInput(
              label: "Deadline",
              controller: _dateController,
              isRequired: true,
              icon: Icons.calendar_today,
              readOnly: true,
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context, 
                  initialDate: DateTime.now(), 
                  firstDate: DateTime(2020), 
                  lastDate: DateTime(2030)
                );
                if (picked != null) {
                  _dateController.text = "${picked.year}-${picked.month.toString().padLeft(2,'0')}-${picked.day.toString().padLeft(2,'0')}";
                }
              },
            ),

            AppInput(label: "Catatan", controller: _noteController, maxLines: 3),
            
            SizedBox(height: 24),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                onPressed: _isSubmitting ? null : _submitTask,
                child: _isSubmitting ? CircularProgressIndicator(color: Colors.white) : Text("Simpan Perubahan"),
              ),
            ),
             SizedBox(height: 12),
             SizedBox(
              height: 48,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Batal", style: TextStyle(color: AppColors.text)),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _submitTask() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      
      Task newTask = Task(
        title: _titleController.text,
        course: _courseController.text,
        deadline: _dateController.text,
        status: "BERJALAN",
        note: _noteController.text,
        isDone: false,
      );

      bool success = await _controller.addTask(newTask);
      setState(() => _isSubmitting = false);

      if (success) Navigator.pop(context);
      else ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal menambah tugas")));
    }
  }
}