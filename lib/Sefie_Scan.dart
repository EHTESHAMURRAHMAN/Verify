import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:verify_demo/Id_Scan.dart';

class SelfieScan extends StatefulWidget {
  const SelfieScan({super.key});

  @override
  State<SelfieScan> createState() => _SelfieScanState();
}

class _SelfieScanState extends State<SelfieScan> {
  File? _image;
  final picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      final bytes = await File(pickedFile.path).readAsBytes();
      final base64String = base64Encode(bytes);
      print('Base64 String: $base64String');
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: _image != null
            ? Column(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(_image!)),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      _pickImage(ImageSource.camera);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.orange.shade700,
                          borderRadius: BorderRadius.circular(10)),
                      height: 60,
                      width: MediaQuery.of(context).size.width / 2,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.camera_viewfinder,
                              color: Colors.white, size: 30),
                          SizedBox(width: 10),
                          Text('Retake a Selfie',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.orange.shade700,
                              borderRadius: BorderRadius.circular(10)),
                          height: 60,
                          width: MediaQuery.of(context).size.width / 3,
                          child: const Center(
                            child: Text('Back',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white)),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(const IDSacan());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.orange.shade700,
                              borderRadius: BorderRadius.circular(10)),
                          height: 60,
                          width: MediaQuery.of(context).size.width / 3,
                          child: const Center(
                            child: Text('Continue',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )
            : Column(
                children: [
                  Text('Selfie Varification',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w400,
                          color: Colors.blue.shade900)),
                  const SizedBox(height: 20),
                  Container(
                    height: MediaQuery.of(context).size.height / 4,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.lightbulb,
                            size: 100, color: Colors.blue.shade900),
                        const SizedBox(height: 10),
                        Text('Use ample lighting to ensure a clear photo.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.blue.shade900)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: MediaQuery.of(context).size.height / 4,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.camera_viewfinder,
                            size: 100, color: Colors.blue.shade900),
                        const SizedBox(height: 10),
                        Text(
                            'Look straight at the camera with a neutral expession',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.blue.shade900)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      _pickImage(ImageSource.camera);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.orange.shade700,
                          borderRadius: BorderRadius.circular(10)),
                      height: 60,
                      width: MediaQuery.of(context).size.width / 2,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.camera_viewfinder,
                              color: Colors.white, size: 30),
                          SizedBox(width: 10),
                          Text('Take a Selfie',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                        ],
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }

  showBottom(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text('Selec',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.camera),
                    child: const Text("Take a Selfie"),
                  ),
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    child: const Text("Pick from Gallery"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
