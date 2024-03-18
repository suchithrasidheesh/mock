
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget{
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<List<Map<String, dynamic>>> loadImages() async {

    List<Map<String, dynamic>> files = [];

    final ListResult result = await storage.ref().list();
    final List<Reference> allFiles = result.items;

    await Future.forEach<Reference>(allFiles,
            (file) async {
          final String fileUrl = await file.getDownloadURL();
          files.add({
            "url": fileUrl,
            "path": file.fullPath,
          });
        });
    return files;
  }


  Future<void> upload(String inputSource) async {
    final picker = ImagePicker();

    XFile? pickedImage;
    try {
      pickedImage = await picker.pickImage(
          source: inputSource == 'camera' ? ImageSource.camera : ImageSource.gallery,
          maxWidth: 1920);

      final String fileName = path.basename(pickedImage!.path);
      File imageFile = File(pickedImage.path);

      try {
        // Uploading the selected image with some custom meta data
        await storage.ref(fileName).putFile(
            imageFile,
        );
        // Refresh the UI
        setState(() {});

      } on FirebaseException catch (error) {
        if (kDebugMode) {
          print(error);
        }
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }




  //File? image;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Home page'),
      ),
      body: Column(
        children: [
          Center(child: Text('Welcome to Home Page')),
          SizedBox(height: 30,),
          Text('Upload Image'),
          SizedBox(height: 20,),
          Row(
            children: [
              ElevatedButton.icon(
                  onPressed: () => upload('camera'),
                  icon: const Icon(Icons.camera),
                  label: const Text('camera')),
              ElevatedButton.icon(
                  onPressed: () => upload('gallery'),
                  icon: const Icon(Icons.library_add),
                  label: const Text('Gallery')),
            ],
          ),
          Expanded(
              child: FutureBuilder(
                  future:loadImages(),
                  builder: (context,AsyncSnapshot<List<Map<String,dynamic>>>snapshot){
                    if (snapshot.connectionState == ConnectionState.done) {
                      return ListView.builder(
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          final Map<String, dynamic> image = snapshot.data![index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: ListTile(
                              dense: false,
                              leading: Image.network(image['url']),
                            ),
                          );
                        },
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },)
          ),
        ],
      ),
    );
  }
}