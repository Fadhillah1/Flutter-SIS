//
//
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'employee_model.dart';

import 'restapi.dart';

class EmployeeFormAdd extends StatefulWidget{
  const EmployeeFormAdd({Key? key}) : super (key: key);

  @override
  //
  _EmployeeFormAddState createState() => _EmployeeFormAddState();
}

class _EmployeeFormAddState extends State<EmployeeFormAdd>{
  final name = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final birthday = TextEditingController();
  final address = TextEditingController();
  String gender = 'Male';

  late Future<DateTime?> selectedDate;
  String date = "-";

  DataService ds = DataService();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text("Employee Form Add"),
        backgroundColor: Colors.indigo,
    ),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // name
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: name,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              border:  OutlineInputBorder(),
              hintText: 'Full Name',
            ),
          ),
        ),
        // Gender
        Padding(
          padding: 
            const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: DropdownButtonFormField(
            decoration: const InputDecoration(
              filled: false,
              border: InputBorder.none,
            ),
            value: gender,
            onChanged: (String? newValue){
              if (kDebugMode) {
                print(newValue);
              }

              setState(() {
                gender = newValue!;
              });
            },
            items: <String>['Male', 'Female']
                .map<DropdownMenuItem<String>>((String value){
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList())),
        // Birthday
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: birthday,
            keyboardType: TextInputType.text,
            maxLines: 1,
            decoration: const InputDecoration(
              border:  OutlineInputBorder(),
              hintText: 'Birthday',
            ),
            onTap: () {
              showDialogPicker(context);
            },
          ),
        ),
        // Phone
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: phone,
            keyboardType: TextInputType.phone,
            maxLines: 1,
            decoration: const InputDecoration(
              border:  OutlineInputBorder(),
              hintText: 'Phone Number',
            ),
          ),
        ),
        // Email
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: email,
            keyboardType: TextInputType.emailAddress,
            maxLines: 1,
            decoration: const InputDecoration(
              border:  OutlineInputBorder(),
              hintText: 'Email Address',
            ),
          ),
        ),
        // Address
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: address,
            maxLines: 4,
            minLines: 3,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              border:  OutlineInputBorder(),
              hintText: 'Phone Number',
            ),
          ),
        ),
        // Submit Button
        Padding(
          padding: 
            const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen, elevation: 0),
              onPressed: () async {
                List response = jsonDecode(await ds.insertEmployee(
                  '63476ceb99b6c11c094bd5ec', 
                  name.text, 
                  phone.text, 
                  email.text, 
                  address.text, 
                  gender,
                  birthday.text,
                  "-"));

                List<EmployeeModel> employee = response
                  .map((e) => EmployeeModel.fromJson(e))
                  .toList();

                if (employee.length == 1) {
                  Navigator.pop(context, true);
                } else {
                  if (kDebugMode){
                    print(response);
                  }
                }
              },
              child: const Text("SUBMIT"),
            ),
          ))
      ],
    ));
  }

  // Date Picker
  void showDialogPicker(BuildContext context){
    selectedDate = showDatePicker(
      context: context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child){
        return Theme(
          data: ThemeData.light(),
          child: child!,
        );
      },
    );

    selectedDate.then((value) {
      setState(() {
        if (value == null) return;

        final DateFormat formatter = DateFormat('dd-MMM-yyyy');
        final String formattedDate = formatter.format(value);
        birthday.text = formattedDate;
      });
    }, onError: (error) {
      if (kDebugMode){
        print(error);
      }
    });
  }
}