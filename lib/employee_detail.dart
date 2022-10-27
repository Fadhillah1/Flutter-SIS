// ignore_for_file: library_private_types_in_public_api,
// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:async';
import 'dart:io';

//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:office/employee_model.dart';
import 'restapi.dart';

class EmployeeDetail extends StatefulWidget {
  const EmployeeDetail({Key? key}) : super(key: key);

  @override
  _EmployeeDetailState createState() => _EmployeeDetailState();
}

class _EmployeeDetailState extends State<EmployeeDetail> {
  DataService ds = DataService();

  // Employee Data
  List<EmployeeModel> employee = [];

  selectIdEmployee(String id) async {
    List data = [];
    data = jsonDecode(await ds.selectId("63476b1099b6c11c094bd501", "office", 
      "employee", "63476ceb99b6c11c094bd5ec", id));
    employee = data.map((e) => EmployeeModel.fromJson(e)).toList();
  }

  // Info
  FutureOr reloadDataEmployee(dynamic value) {
    setState(() {
      final args = ModalRoute.of(context)?.settings.arguments as List<String>;

      selectIdEmployee(args[0]);
    });
  }

  // Profpic
  File? image;
  String? imageProfpic;

  /*Future pickImage(ImageSource source, String id) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) {
        if (kDebugMode) {
          print('no image');
        }
      } else {
        if (kDebugMode) {
          print('have image');
        }
        final upload = jsonDecode(await ds.upload(
                '6115e1be32c2a05a0b647a5f', 'office', File(image.path)))
            as Map<String, dynamic>;
        if (kDebugMode) {
          print(upload['file_name']);
        }

        // bool updateProfpic = await requester.updateId(
        //     'profpic',
        //     upload['file_name'],
        //     '52f866f58d909e13236110e5',
        //     'crud',
        //     'employee',
        //     '5ab617c01f6d047f0dd36d55',
        //     id);

        // if (updateProfpic) {
        //   if (kDebugMode) {
        //     print('Data Updated');

        //     setState(() {
        //       // imageProfpic = 'https://file.247go.app/d226fd9f5fcf8bc3cbdff22e2bd79efe/' + upload['file_name'];
        //     });
        //   }
        // }
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }*/

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as List<String>;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text("Employee Detail"),
        backgroundColor: Colors.indigo,
        elevation: 0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                //pickImage(ImageSource.camera, args[0]);
              },
              child: const Icon(
                Icons.camera_alt,
                size: 26.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                // Navigator.pushNamed(context, 'employee_form_edit',
                //     arguments: [employee[0].id]);
               Navigator.pushNamed(context, 'employee_form_edit',
                    arguments: [employee[0].id]).then(reloadDataEmployee);
              },
              child: const Icon(
                Icons.edit,
                size: 26.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Warning"),
                      content: const Text("Remove this data?"),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('CANCEL'),
                          onPressed: () {
                            // Close Dialog
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('REMOVE'),
                          onPressed: () async {
                            // Close Dialog
                            Navigator.of(context).pop();

                            bool response = await ds.removeId(
                                '6115e1be32c2a05a0b647a5f',
                                'office',
                                'employee',
                                '6346875d99b6c11c094bd4ed',
                                args[0]);

                            if (response) {
                              Navigator.pop(context, true);
                            }
                          },
                        )
                      ],
                    );
                  },
                );
              },
              child: const Icon(
                Icons.delete_outline,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<dynamic>(
        future: selectIdEmployee(args[0]),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              {
                return const Text('none');
              }
            case ConnectionState.waiting:
              {
                return const Center(child: CircularProgressIndicator());
              }
            case ConnectionState.active:
              {
                return const Text('Active');
              }
            case ConnectionState.done:
              {
                if (snapshot.hasError) {
                  return Text('${snapshot.error}',
                      style: const TextStyle(color: Colors.red));
                } else {
                  return ListView(
                    children: [
                      Container(
                        decoration: const BoxDecoration(color: Colors.indigo),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.40,
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            const SizedBox(height: 20),
                            const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 130,
                            ),
                            // IconButton(
                            //   onPressed: () {
                            //     Navigator.pop(context);
                            //     pickImage(ImageSource.camera, args[0]);
                            //   },
                            //   icon: const Icon(
                            //     Icons.person,
                            //     color: Colors.white,
                            //     size: 130,
                            //   ),
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    employee[0].name,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 30),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Text(
                                    employee[0].gender,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text(employee[0].name),
                          subtitle: const Text(
                            "Name",
                            style: TextStyle(color: Colors.black54),
                          ),
                          leading: IconButton(
                              icon: const Icon(Icons.person,
                                  color: Colors.indigo),
                              onPressed: () {}),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text(employee[0].email),
                          subtitle: const Text(
                            "email",
                            style: TextStyle(color: Colors.black54),
                          ),
                          leading: IconButton(
                              icon:
                                  const Icon(Icons.email, color: Colors.indigo),
                              onPressed: () {}),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text(employee[0].phone),
                          subtitle: const Text(
                            "Phone",
                            style: TextStyle(color: Colors.black54),
                          ),
                          leading: IconButton(
                              icon:
                                  const Icon(Icons.phone, color: Colors.indigo),
                              onPressed: () {}),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text(employee[0].birthday),
                          subtitle: const Text(
                            "Birthday",
                            style: TextStyle(color: Colors.black54),
                          ),
                          leading: IconButton(
                              icon: const Icon(Icons.calendar_today,
                                  color: Colors.indigo),
                              onPressed: () {}),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text(employee[0].address),
                          subtitle: const Text(
                            "Address",
                            style: TextStyle(color: Colors.black54),
                          ),
                          leading: IconButton(
                              icon:
                                  const Icon(Icons.house, color: Colors.indigo),
                              onPressed: () {}),
                        ),
                      ),
                    ],
                  );
                }
              }
          }
        },
      ),
    );
  }
}