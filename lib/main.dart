import 'package:flutter/material.dart';

import 'package:office/employee_form_add.dart';
import 'package:office/employee_form_edit.dart';
import 'package:office/employee_list.dart';
import 'package:office/employee_detail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const EmployeeList(),
      routes: {
        'employee_list' : (context) => const EmployeeList(),
        'employee_form_add' : (context) => const EmployeeFormAdd(),
        'employee_form_edit' : (context) => const EmployeeFormEdit(),
        'employee_detail' : (context) => const EmployeeDetail()
      },
    );
  }
}
