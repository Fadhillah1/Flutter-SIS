import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:office/employee_model.dart';
import 'restapi.dart';

class EmployeeFormEdit extends StatefulWidget{
  const EmployeeFormEdit({Key? key}) : super(key: key);

  @override
  _EmployeeFormEditState createState() => _EmployeeFormEditState();
}

class _EmployeeFormEditState extends State<EmployeeFormEdit>{
  DataService ds = DataService();

  final name = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final birthday = TextEditingController();
  final address = TextEditingController();
  String gender = 'Male';
  String update_id = '';

  late Future<DateTime?> selectedDate;
  String date = "-";

  List<EmployeeModel> employee = [];

  selectIdEmployee(String id) async {
    List data = [];
    data = jsonDecode(await ds.selectId('63476b1099b6c11c094bd501', 'office', 
      'employee', '63476ceb99b6c11c094bd5ec', id));
    employee = data.map((e) => EmployeeModel.fromJson(e)).toList();

    name.text = employee[0].name;
    gender = employee[0].gender;
    birthday.text = employee[0].birthday;
    phone.text = employee[0].phone;
    email.text = employee[0].email;
    address.text = employee[0].address;
    update_id = employee[0].id;
  }

  @override
  Widget build(BuildContext context){
    final args = ModalRoute.of(context)?.settings.arguments as List<String>;
    selectIdEmployee(args[0]);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text("Employee Form Edit"),
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  <Widget>[
          //Name
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: name,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Full Name'
              ),
            ),
          ),
          //Gender
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: DropdownButtonFormField(
              decoration: const InputDecoration(
                filled: false,
                border: InputBorder.none,
              ),
              value: gender,
              onChanged: (String? newValue){
                if(kDebugMode){
                  print(newValue);
                }

                setState(() {
                  gender = newValue!;
                });
              },
              items: <String>['Male', 'Female']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value)
                );
              }).toList()),
          ),
          //Birthday
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child:TextField(
              controller: birthday,
              keyboardType: TextInputType.text,
              maxLines: 1,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Birthday",
              ),
              onTap: (){
                showDialogPicker(context);
              },
            ), 
          ),
          //Phone
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: phone,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Phone'
              ),
            ),
          ),
          //Email
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: email,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Email'
              ),
            ),
          ),
          //Address
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: address,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Address'
              ),
            ),
          ),
          //Submit Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen, elevation: 0),
                onPressed: () async{
                  bool updateStatus = await ds.updateId(
                    'name~email~gender~phone~birthday~address', 
                    '${name.text}~${email.text}~$gender~${phone.text}~${birthday.text}~${address.text}',
                    '63476a7599b6c11c094bd4ff',
                    'office',
                    'employee',
                    '63476cf199b6c11c094bd5f2',
                    update_id);

                if(updateStatus){
                  Navigator.pop(context, true);
                }
              },
              child: const Text("UPDATE"),
            ),
          )),
        ],
      ),
    );
  }

  //Date Picker
  void showDialogPicker(BuildContext context){
    selectedDate = showDatePicker(
      context: context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime(1998), 
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child){
        return Theme(
          data: ThemeData.light(), 
          child: child!,
        );
      },
    );

    selectedDate.then((value){
      setState(() {
        if (value == null) return;

        final DateFormat formatter = DateFormat('dd-MMM-yyyy');
        final String formattedDate = formatter.format(value);
        birthday.text = formattedDate;
      });
    }, onError: (error){
      if(kDebugMode){
        print(error);
      }
    });
  }
}