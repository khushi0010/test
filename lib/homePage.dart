import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class HomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
 // final picker = ImagePicker();
  File? _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }
  Future<void> _uploadImage(File image) async {
    final url = Uri.parse('http://your-server-url.com/upload-image');
    final request =  http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('image', image.path));
    final response = await request.send();
    if (response.statusCode == 200) {
      // image uploaded successfully
    } else {
      // image upload failed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.indigo.shade500,
          title: Center(child: Text('Image Upload',
            style: TextStyle(color: Colors.white),))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             if (_imageFile != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(300),
              child:  Image.file(_imageFile!),),
              const SizedBox(height: 20),
              new SizedBox(
                width: 250,
                child:ElevatedButton(
                onPressed: () => _uploadImage(_imageFile!),
                child: const Row(children:
                [
                  Icon(Icons.upload),
                  Text('Upload Image'),
                ]),

              ),)
            ]

             else ...[
              new SizedBox(
                width: 250,
                child:
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.gallery),
                child: const Row(
                  children: [
                    Icon(Icons.image),
                    Text('Select Image'),
                  ],
                ),
                
              ),)
            ],
            const Center(child: Text('Please provide api to upload image')),
          ],
        ),
      ),
    );
  }}