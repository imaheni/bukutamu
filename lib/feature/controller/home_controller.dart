import 'dart:convert';

import 'package:bukutamu/api/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HomeController {
   final VoidCallback initState;

  // Konstruktor untuk HomeController dengan initState sebagai parameter
  HomeController({required this.initState});

  bool isLoad = false;


  // Kontroler untuk menangani input form
  final TextEditingController nameController = TextEditingController();
  final TextEditingController institutionController = TextEditingController();
  final TextEditingController purposeController = TextEditingController();
  final TextEditingController recipientController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // Fungsi untuk menambah entri tamu
  void addGuestEntry() async {
    if (nameController.text.isNotEmpty &&
        institutionController.text.isNotEmpty &&
        purposeController.text.isNotEmpty &&
        recipientController.text.isNotEmpty &&
        phoneController.text.isNotEmpty) {
      // setState(() {
      isLoad = true;
      initState();
      
      var headers = {'Content-Type': 'application/json'};
      var data = json.encode({
        "name": nameController.text,
        "institution": institutionController.text,
        "purpose": purposeController.text,
        "recipient": recipientController.text,
        "phone": phoneController.text
      });
      var dio = Dio();
      var response = await dio.request(
        '${APIMG.MG}/guest',
        options: Options(
          method: 'POST',
          headers: headers,
        ),
        data: data,
      );

      if (response.statusCode == 200) {
        print(json.encode(response.data));
      } else {
        print(response.statusMessage);
      }
      isLoad = false;
      initState();
      nameController.clear();
      institutionController.clear();
      purposeController.clear();
      recipientController.clear();
      phoneController.clear();
    }
  }
  
}
