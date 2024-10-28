import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:verify_demo/commonToken.dart';

class DocumentVerificationScreen extends StatefulWidget {
  const DocumentVerificationScreen({super.key});

  @override
  _DocumentVerificationScreenState createState() =>
      _DocumentVerificationScreenState();
}

class _DocumentVerificationScreenState
    extends State<DocumentVerificationScreen> {
  String? selfieBase64;
  String? idFrontBase64;
  String? idBackBase64;

  // Variables to store fetched data
  String? firstName;
  String? lastName;
  String? documentNumber;
  String? dateOfBirth;
  String? documentExpiry;

  // Method to pick an image (selfie or ID)
  Future<void> pickImage(String type) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      String base64String = base64Encode(bytes);
      setState(() {
        if (type == 'selfie') {
          selfieBase64 = base64String; // Set selfie base64
        } else if (type == 'idFront') {
          idFrontBase64 = base64String; // Set ID front base64
        } else if (type == 'idBack') {
          idBackBase64 = base64String; // Set ID back base64
        }
      });
    }
  }

  // Step 1: Obtain the first token
  Future<void> firstToken() async {
    EasyLoading.show(status: '🔄 Processing your request, please wait...');

    try {
      final response = await http.post(
        Uri.parse('$baseVerifyApi/access/oauth/token'),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "grant_type": "password",
          "username": "user_africa_crypto@abc.com",
          "password": "Welcome@123!",
          "client_id": "tenant-africa-crypto",
          "client_secret": "1a40ff7f-86c2-4f15-b42d-2bc5e4291803"
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        String refreshToken = data['refresh_token'];
        await secondToken(refreshToken);
      } else {
        EasyLoading.showError("🚫 Failed to process request.");
      }
    } catch (e) {
      EasyLoading.showError('⚠️ An error occurred.');
    } finally {
      EasyLoading.dismiss();
    }
  }

  // Step 2: Obtain the second token using the refresh token
  Future<void> secondToken(String refreshToken) async {
    EasyLoading.show(status: '🔄 Refreshing your credentials...');

    try {
      final response = await http.post(
        Uri.parse('$baseVerifyApi/access/oauth/token'),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "grant_type": "refresh_token",
          "client_id": "tenant-africa-crypto",
          "client_secret": "1a40ff7f-86c2-4f15-b42d-2bc5e4291803",
          "refresh_token": refreshToken
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        String accessToken = data['access_token'];
        await idVerify(accessToken);
      } else {
        EasyLoading.showError("🚫 Failed to refresh credentials.");
      }
    } catch (e) {
      EasyLoading.showError("⚠️ Error occurred while refreshing credentials.");
    } finally {
      EasyLoading.dismiss();
    }
  }

  // Step 3: Verify the ID
  Future<void> idVerify(String accessToken) async {
    EasyLoading.show(status: '🧐 Verifying your document, hold on...');

    Map<String, String> headers = {
      "X-TenantID": "19",
      "Authorization": "Bearer $accessToken",
      'Content-Type': 'application/json'
    };

    final msg = jsonEncode({
      "eventType": "ID_EXTRACTION",
      "imageExtractionDto": {
        "base64stringBack": idBackBase64,
        "base64stringFront": idFrontBase64,
        "docFormatBack": "PNG",
        "docFormatFront": "PNG",
        "docType": "ID", // You can adjust this based on user selection
        "isFaceImageReturned": true,
        "requestId": "2"
      },
      "inputDto": {
        "firstName": "John", // Replace with user input
        "lastName": "Doe", // Replace with user input
        "documentNumber": "ABC123456", // Replace with user input
        "dateOfBirth": "1990-01-01", // Replace with user input
        "documentExpiry": "2030-01-01", // Replace with user input
        "minAgeAllowed": 10,
        "graceExpiryDays": 30
      },
      "isRetry": true,
      "previousEventId": 18,
      "requestId": "2"
    });

    try {
      final response = await http.post(
        Uri.parse('$baseVerifyApi/kyc/v1/service/extract/id/version/3'),
        headers: headers,
        body: msg,
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        // Fetch the required fields from the response
        setState(() {
          firstName = responseBody['data']
              ['firstName']; // Adjust according to actual response structure
          lastName = responseBody['data']
              ['lastName']; // Adjust according to actual response structure
          documentNumber = responseBody['data'][
              'documentNumber']; // Adjust according to actual response structure
          dateOfBirth = responseBody['data']
              ['dateOfBirth']; // Adjust according to actual response structure
          documentExpiry = responseBody['data'][
              'documentExpiry']; // Adjust according to actual response structure
        });
        EasyLoading.showSuccess('✅ Document verified successfully!');
      } else {
        EasyLoading.showError("⚠️ Verification failed. Check your connection.");
      }
    } catch (e) {
      EasyLoading.showError("🚨 Error during document verification.");
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Document Verification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => pickImage('selfie'),
              child: Text("Upload Selfie"),
            ),
            ElevatedButton(
              onPressed: () => pickImage('idFront'),
              child: Text("Upload ID Front"),
            ),
            ElevatedButton(
              onPressed: () => pickImage('idBack'),
              child: Text("Upload ID Back"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: firstToken,
              child: Text("Verify Document"),
            ),
            SizedBox(height: 20),
            // Display fetched data
            if (firstName != null) ...[
              Text('First Name: $firstName'),
              Text('Last Name: $lastName'),
              Text('Document Number: $documentNumber'),
              Text('Date of Birth: $dateOfBirth'),
              Text('Document Expiry: $documentExpiry'),
            ],
          ],
        ),
      ),
    );
  }
}


// class UploadIDPage extends StatefulWidget {
//   final String selfieBase64;

//   UploadIDPage({required this.selfieBase64});

//   @override
//   _UploadIDPageState createState() => _UploadIDPageState();
// }

// class _UploadIDPageState extends State<UploadIDPage> {
//   String? idDocumentBase64;
//   String? verificationResult; // To hold verification result

//   // Method to pick an ID image from the gallery
//   Future<void> _pickIDImage() async {
//     final ImagePicker _picker = ImagePicker();
//     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

//     if (image != null) {
//       // Convert image to base64
//       final bytes = await image.readAsBytes();
//       idDocumentBase64 = base64Encode(bytes);

//       // Call verification API
//       await _verifyDocument(widget.selfieBase64, idDocumentBase64!);
//     }
//   }

//   // Method to verify the uploaded document against the selfie
//   Future<void> _verifyDocument(String selfie, String idDocument) async {
//     EasyLoading.show(status: '🧐 Verifying your document, hold on...');

//     // Prepare the headers
//     Map<String, String> headers = {
//       "Content-Type": "application/json",
//       "X-TenantID": "19", // Add any required headers here
//     };

//     // Prepare the body
//     final msg = jsonEncode({
//       "eventType": "ID_EXTRACTION",
//       "imageExtractionDto": {
//         "base64stringBack": idDocument,
//         "base64stringFront": selfie,
//         "docFormatBack": "PNG", // Adjust according to your ID document type
//         "docFormatFront": "PNG", // Adjust according to your selfie type
//         "docType": "ID", // Adjust to your ID type
//         "isFaceImageReturned":
//             true // Ask the API to return face image comparison
//       },
//       // Add other required parameters as per the API documentation
//     });

//     try {
//       // Call the verification API
//       final response = await http.post(
//         Uri.parse(
//             '$baseVerifyApi/kyc/v1/service/extract/id/version/3'),
//         headers: headers,
//         body: msg,
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);

//         // Check if verification was successful
//         if (responseData['successful']) {
//           // Extract verification fields
//           verificationResult = 'Verification Successful!';

//           // Display specific fields based on the API response
//           var fields = responseData['fieldComparisonList'] as List;
//           for (var field in fields) {
//             verificationResult +=
//                 '\n${field['fieldName']}: ${field['comparisonStatus']}';
//           }

//           // Optionally, display the extracted face image from the document if available
//           if (responseData['faceImage'] != null) {
//             verificationResult +=
//                 '\nFace Image URL: ${responseData['faceImage']}';
//           }

//           EasyLoading.showSuccess(verificationResult!);
//         } else {
//           EasyLoading.showError(
//               '❌ Verification failed. Please review your documents.');
//         }
//       } else {
//         EasyLoading.showError(
//             "⚠️ Verification failed. Status code: ${response.statusCode}");
//       }
//     } catch (e) {
//       EasyLoading.showError("🚨 Error during document verification: $e");
//     } finally {
//       EasyLoading.dismiss();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Upload ID Document')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: _pickIDImage,
//               child: Text('Upload ID Document'),
//             ),
//             if (verificationResult != null)
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child:
//                     Text(verificationResult!, style: TextStyle(fontSize: 16)),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
