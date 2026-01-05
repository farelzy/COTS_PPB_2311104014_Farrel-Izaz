import 'package:flutter/material.dart';
import '../presentation/pages/dashboard_page.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'COTS Pemrograman Perangkat Bergerak',
      debugShowCheckedModeBanner: false,
      home: DashboardPage(),
    );
  }
}