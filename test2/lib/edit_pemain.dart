import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditPlayer extends StatefulWidget {
  final Map<String, dynamic> player;

  EditPlayer({required this.player});

  @override
  _EditPlayerState createState() => _EditPlayerState();
}

class _EditPlayerState extends State<EditPlayer> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController namaController;
  late TextEditingController negaraController;
  late TextEditingController timController;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.player['nama']);
    negaraController = TextEditingController(text: widget.player['negara']);
    timController = TextEditingController(text: widget.player['tim']);
  }

  Future<void> _updatePlayer() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('http://localhost/edit_pemain.php'),
        body: {
          'id': widget.player['id'],
          'nama': namaController.text,
          'negara': negaraController.text,
          'tim': timController.text,
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data updated successfully')),
        );
        Navigator.pop(context); // Navigate back to the main page
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update data')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Pemain E-Sport',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF690006),
      ),
      body: Container(
        color: Color(0xFF121212),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: namaController,
                  decoration: InputDecoration(
                    labelText: 'Nama',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF690006)),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: negaraController,
                  decoration: InputDecoration(
                    labelText: 'Negara',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF690006)),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter country';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: timController,
                  decoration: InputDecoration(
                    labelText: 'Tim',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF690006)),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter team';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _updatePlayer,
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF690006),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
