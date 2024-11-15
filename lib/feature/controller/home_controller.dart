import 'dart:convert';
import 'dart:io'; // For file handling
import 'package:bukutamu/api/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeController {
   BuildContext context;
  final VoidCallback onImagePicked;
  final VoidCallback onSubmit;
  void Function(void Function()) setState;

  // Konstruktor untuk HomeController dengan initState sebagai parameter
  HomeController({required this.context,required this.setState, required this.onImagePicked, required this.onSubmit,});

  bool isLoad = false;
  File? imageFile; // To store the image picked by the user


  // Kontroler untuk menangani input form
  final TextEditingController nameController = TextEditingController();
  final TextEditingController institutionController = TextEditingController();
  final TextEditingController purposeController = TextEditingController();
  final TextEditingController recipientController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

// Function to pick an image from the camera
  Future<void> pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      imageFile = File(pickedFile.path); // Save the selected image
      onImagePicked(); // Update the UI after image is picked
      setState((){}); // Trigger any necessary UI state update
    }
  }

  // Fungsi untuk menambah entri tamu
 void addGuestEntry() async {
  if (nameController.text.isNotEmpty &&
      institutionController.text.isNotEmpty &&
      purposeController.text.isNotEmpty &&
      recipientController.text.isNotEmpty &&
      phoneController.text.isNotEmpty) {
    
    // Tampilkan loading saat memproses
    setState(() {
      isLoad = true;
    });

    try {
      print('IMAGE FILE PATH: ${imageFile?.path}');
        
      // Jika gambar dipilih, pastikan file tidak null dan ada
      if (imageFile != null && imageFile!.existsSync()) {
        var uploadResponse = await Dio().post(
          "https://database-query.v3.microgen.id/api/v1/5e1db2df-b436-4ef5-97e3-bd7b6ba57b5b/storage/upload",
          options: Options(
            headers: {
              "Content-Type": "application/json",
            },
          ),
          data: FormData.fromMap(
            {
              "file": await MultipartFile.fromFile(imageFile!.path),
            },
          ),
        );

        print("UPLOAD IMAGE TO STORE : ${uploadResponse.data}");
        print("UPLOAD IMAGE TO STORE : ${uploadResponse.statusCode}");

        if (uploadResponse.statusCode == 200) {
          var guestResponse = await Dio().post(
            '${APIMG.MG}/guest',
            options: Options(
              headers: {
                "Content-Type": "application/json",
              },
            ),
            data: {
              "name": nameController.text,
              "institution": institutionController.text,
              "purpose": purposeController.text,
              "recipient": recipientController.text,
              "phone": phoneController.text,
              "imageUrl":uploadResponse.data['url']
            },
          );

          print("DATA KE SERVER : ${guestResponse.statusCode}");
          print("DATA KE SERVER : ${guestResponse.data}");

          if (guestResponse.statusCode == 200) {
            print(json.encode(guestResponse.data));
          } else {
            print(guestResponse.statusMessage);
          }
        }
      } else {
        print("No valid image or file does not exist.");
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      // Sembunyikan loading dan reset form setelah selesai
      setState(() {
        isLoad = false;
      });

      nameController.clear();
      institutionController.clear();
      purposeController.clear();
      recipientController.clear();
      phoneController.clear();
      imageFile =null;
    }
  }
}

}
