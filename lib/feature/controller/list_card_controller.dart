import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ListCardController {
  final VoidCallback initState;

  // Konstruktor untuk HomeController dengan initState sebagai parameter
  ListCardController({required this.initState});
  List<Map<String, String>> dataGuests = [];

  // Mengambil semua data tamu dari server
  void getGuestsAll() async {
    try {
      var response = await Dio().get(
        "https://database-query.v3.microgen.id/api/v1/5e1db2df-b436-4ef5-97e3-bd7b6ba57b5b/guest",
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );
      if (response.statusCode == 200) {
        dataGuests.clear();
        for (var guest in response.data) {
          print("COBA ${guest}");
          dataGuests.add({
            "_id": guest['_id'],
            "name": guest['name'],
            "institution": guest['institution'],
            "purpose": guest['purpose'],
            "recipient": guest['recipient'],
            "phone": guest['phone']
          });
        }
        initState();
      }
    } catch (e) {
      // Handle error (tampilkan pesan error atau log)
    }
  }

  // Fungsi untuk menghapus tamu berdasarkan id
  void deleteGuest(String id) async {
    print("iddelete $id");
    try {
      var response = await Dio().delete(
        "https://database-query.v3.microgen.id/api/v1/5e1db2df-b436-4ef5-97e3-bd7b6ba57b5b/guest/$id",
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );
      print ("Hallo $id");

      if (response.statusCode == 200) {
        // Hapus dari list lokal
        dataGuests.removeWhere((guest) => guest['_id'] == id);
        initState();  // Update UI
      }
    } catch (e) {
      // Handle error (tampilkan pesan error atau log)
    }
  }

  // Fungsi untuk memperbarui data tamu
  void editGuest(String id, Map<String, String> updatedData) async {
    print('-----------------------------------');
    print(id);
    print(updatedData.toString());
    print('-----------------------------------');
    try {
      var response = await Dio().patch(
        "https://database-query.v3.microgen.id/api/v1/5e1db2df-b436-4ef5-97e3-bd7b6ba57b5b/guest/$id",
        data: updatedData,
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );
      if (response.statusCode == 200) {
        // Update data di list lokal
        int index = dataGuests.indexWhere((guest) => guest['_id'] == id);
        if (index != -1) {
          dataGuests[index] = updatedData;
        }
        initState();  // Update UI
      }
    } catch (e) {
      // Handle error (tampilkan pesan error atau log)
    }
  }
}
