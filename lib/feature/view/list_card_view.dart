import 'package:bukutamu/feature/controller/list_card_controller.dart';
import 'package:flutter/material.dart';

class ListCardsView extends StatefulWidget {
  const ListCardsView({super.key});

  @override
  State<ListCardsView> createState() => _ListCardsViewState();
}

class _ListCardsViewState extends State<ListCardsView> {
  late ListCardController _controller;

  @override
  void initState() {
    _controller = ListCardController(initState: () => setState(() {}));
    _controller.getGuestsAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Tamu"),
        backgroundColor: Colors.teal, // Ubah warna AppBar
      ),
      backgroundColor: Colors.teal, // Ubah warna dasar
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _controller.dataGuests.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  var item = _controller.dataGuests[index];
                  print(item.toString());
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x19000000),
                            blurRadius: 24,
                            offset: Offset(0, 11),
                          ),
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 96,
                            height: 96,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                                ),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            ),
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name'] ?? "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6.0),
                                Text(
                                  item['institution'] ?? "",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['recipient'] ?? "",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                    Text(
                                      item['phone'] ?? "",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24.0),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        print(item['_id']);
                                        _controller.deleteGuest(item['_id'].toString());
                                      },
                                      child: CircleAvatar(
                                        radius: 16.0,
                                        backgroundColor: Colors.red[200],
                                        child: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                          size: 16.0,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    InkWell(
                                      onTap: () {
                                        _showEditDialog(context ,item);
                                      
                                        },
                                      child: CircleAvatar(
                                        radius: 16.0,
                                        backgroundColor: Colors.blue[200],
                                        child: const Icon(
                                          Icons.edit_outlined,
                                          color: Colors.blue,
                                          size: 16.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
 // Fungsi untuk menampilkan dialog edit
  void _showEditDialog(BuildContext context,Map<String, String> guest) {
    print("WOY $guest");
    TextEditingController nameController = TextEditingController(text: guest['name']);
    TextEditingController institutionController = TextEditingController(text: guest['institution']);
    TextEditingController phoneController = TextEditingController(text: guest['phone']);
    TextEditingController recipientController = TextEditingController(text: guest['recipient']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Tamu"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: institutionController,
                decoration: const InputDecoration(labelText: "Institution"),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Phone"),
              ),
              TextField(
                controller: recipientController,
                decoration: const InputDecoration(labelText: "Recipient"),
              ),
            ],
          ),
          actions: <Widget>[
           
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Save"),
              onPressed: () {
                _controller.editGuest(guest['_id'].toString(), {
                  "name": nameController.text,
                  "institution": institutionController.text,
                  "phone": phoneController.text,
                  "recipient": recipientController.text,
                });
                _controller.getGuestsAll();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
