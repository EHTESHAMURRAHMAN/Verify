import 'package:flutter/material.dart';

import 'dart:convert'; // Import this for base64 decoding
import 'dart:typed_data'; // Import this for Uint8List
import 'package:flutter/material.dart';

class ApiResponsePage extends StatelessWidget {
  final Map<String, dynamic> responseData;

  const ApiResponsePage({Key? key, required this.responseData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract relevant fields from the response data
    final vizData = responseData['extractedData']['vizData'] ?? {};
    final generalData = responseData['extractedData']['generalData'] ?? {};
    final errorDetail = responseData['errorDetail'] ?? [];
    final successful = responseData['successful'] ?? false;
    final faceImageBase64 =
        responseData['extractedData']['faceImageBase64'] ?? '';

    // Decode base64 string to bytes
    Uint8List? imageBytes;
    if (faceImageBase64.isNotEmpty) {
      imageBytes = base64Decode(faceImageBase64);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('API Response Data')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Display faceImageBase64 as an image if available
          if (imageBytes != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  const Text("Face Image",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8.0),
                  Image.memory(imageBytes,
                      height: 200, fit: BoxFit.cover), // Displaying the image
                ],
              ),
            ),
          ...vizData.entries.map((entry) {
            return ListTile(
              title: Text(entry.key,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(entry.value.toString()),
            );
          }).toList(),
          // Display vizData
          ...vizData.entries.map((entry) {
            return ListTile(
              title: Text(entry.key,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(entry.value.toString()),
            );
          }).toList(),

          // Display generalData
          ...generalData.entries.map((entry) {
            return ListTile(
              title: Text(entry.key,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(entry.value.toString()),
            );
          }).toList(),

          // Display errorDetail
          if (errorDetail.isNotEmpty)
            ListTile(
              title: const Text("Error Details",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(errorDetail
                  .join(", ")), // Join error details if there are multiple
            ),

          // Display successful status
          ListTile(
            title: const Text("Successful",
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(successful.toString()),
          ),
        ],
      ),
    );
  }
}
