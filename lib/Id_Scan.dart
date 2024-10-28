import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:verify_demo/commonToken.dart';
import 'package:verify_demo/dropdown_Detail.dart';
import 'package:verify_demo/fetched_data.dart';
import 'package:verify_demo/resp.dart';
import 'package:verify_demo/responsepage.dart';

class IDSacan extends StatefulWidget {
  const IDSacan({super.key});

  @override
  State<IDSacan> createState() => _IDSacanState();
}

class _IDSacanState extends State<IDSacan> {
  String? selectedCountry;
  String? selectedIdType;
  File? _idfrontimage;
  File? _idbackimage;
  String frontimage = '';
  final picker = ImagePicker();

  Future<void> _pickfrontImage(ImageSource source) async {
    // if (selectedCountry == null) {
    //   EasyLoading.showToast('Select Country',
    //       toastPosition: EasyLoadingToastPosition.top);

    //   return;
    // }
    // if (selectedIdType == null) {
    //   EasyLoading.showToast('Select ID type',
    //       toastPosition: EasyLoadingToastPosition.top);

    //   return;
    // }
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _idfrontimage = File(pickedFile.path);
      });
      final bytes = await File(pickedFile.path).readAsBytes();
      final base64String = base64Encode(bytes);
      frontimage = base64String;
      print('Base64 String: $base64String');
    } else {
      print('No image selected.');
    }
  }

  Future<void> _pickBackImage(ImageSource source) async {
    if (selectedCountry == null) {
      EasyLoading.showToast('Select Country',
          toastPosition: EasyLoadingToastPosition.top);

      return;
    }
    if (selectedIdType == null) {
      EasyLoading.showToast('Select ID type',
          toastPosition: EasyLoadingToastPosition.top);
      return;
    }
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _idbackimage = File(pickedFile.path);
      });
      final bytes = await File(pickedFile.path).readAsBytes();
      final base64String = base64Encode(bytes);
      print('Base64 String: $base64String');
      Get.to(ImageSlider(
        firstimg: _idfrontimage,
        secondimg: _idbackimage,
      ));
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [
            Text('Upload your ID',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                    color: Colors.blue.shade900)),
            const SizedBox(height: 10),
            const Text('Use a valid government-issued photo ID',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
            const SizedBox(height: 30),
            const Text('Choosing issuing country/region',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Container(
              height: 60, // Set container height to 60
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: Center(
                child: DropdownButton<String>(
                  value: selectedCountry,
                  isExpanded: true,
                  hint: const Text("Select Country"),
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  underline: const SizedBox(),
                  items: countries.map((country) {
                    return DropdownMenuItem<String>(
                      value: country,
                      child: Text(country),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedCountry = newValue;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text('Select ID type',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: Center(
                child: DropdownButton<String>(
                  value: selectedIdType,
                  isExpanded: true,
                  hint: const Text("Select ID Type"),
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  underline: const SizedBox(),
                  items: idTypes.map((idType) {
                    return DropdownMenuItem<String>(
                      value: idType,
                      child: Text(idType),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedIdType = newValue;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            _idfrontimage == null
                ? Center(
                    child: InkWell(
                      onTap: () {
                        _pickfrontImage(ImageSource.gallery);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.orange.shade700,
                            borderRadius: BorderRadius.circular(10)),
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.upload, color: Colors.white, size: 30),
                            SizedBox(width: 10),
                            Text('Upload front side of your ID',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: InkWell(
                      onTap: () {
                        _pickBackImage(ImageSource.camera);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.orange.shade700,
                            borderRadius: BorderRadius.circular(10)),
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.upload, color: Colors.white, size: 30),
                            SizedBox(width: 10),
                            Text('Upload Back side of your ID',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white)),
                          ],
                        ),
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
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    firstTokenSelfie();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.orange.shade200,
                        borderRadius: BorderRadius.circular(10)),
                    height: 60,
                    width: MediaQuery.of(context).size.width / 3,
                    child: const Center(
                      child: Text('Continue',
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                    ),
                  ),
                )
              ],
            )
          ])),
    );
  }

  Future<void> firstTokenSelfie() async {
    try {
      EasyLoading.show(status: '🌟 Securing your verification, hang tight...');

      final response = await http.post(
        Uri.parse('$baseVerifyApi/access/oauth/token'),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        encoding: Encoding.getByName('utf-8'),
        body: {
          "grant_type": "password",
          "username": "user_africa_crypto@abc.com",
          "password": "Welcome@123!",
          "client_id": "tenant-africa-crypto",
          "client_secret": "1a40ff7f-86c2-4f15-b42d-2bc5e4291803"
        },
      );

      if (response.statusCode == 200) {
        VerifyToken data = verifyTokenFromJson(response.body);
        await secondSelfie(
            data.refresh_token); // Wait for secondSelfie to complete
      } else {
        EasyLoading.showError('❌ Failed to get token, please retry.');
      }
    } catch (e) {
      EasyLoading.showError('🚨 Oops, something went wrong.');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> secondSelfie(String token) async {
    try {
      EasyLoading.show(status: '🔄 Refreshing session, almost there...');

      final response = await http.post(
        Uri.parse('$baseVerifyApi/access/oauth/token'),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        encoding: Encoding.getByName('utf-8'),
        body: {
          "grant_type": "refresh_token",
          "client_id": "tenant-africa-crypto",
          "client_secret": "1a40ff7f-86c2-4f15-b42d-2bc5e4291803",
          "refresh_token": token
        },
      );

      if (response.statusCode == 200) {
        VerifyToken data = verifyTokenFromJson(response.body);
        await idVerify(data.access_token);
      } else {
        EasyLoading.showError('❌ Failed to refresh session.');
      }
    } catch (e) {
      EasyLoading.showError('🚨 Error while refreshing token.');
    }
  }

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
        "base64stringFront": frontimage,
        "docFormatBack": "PNG",
        "docFormatFront": "PNG",
        "docType": "Passport",
        "isFaceImageReturned": true,
        "requestId": "10"
      },
      "requestId": "10"
    });

    final response = await http.post(
      Uri.parse('$baseVerifyApi/kyc/v1/service/extract/id/version/3'),
      headers: headers,
      body: msg,
    );

    if (response.statusCode == 200) {
      ApiResponse apiResponse = ApiResponse.fromJson(jsonDecode(response.body));
      print("Request ID: ${apiResponse.get("requestId")}");
      print("Event ID: ${apiResponse.get("eventId")}");
      print(
          "Face Image (base64): ${apiResponse.data['extractedData']?['faceImageBase64']}");

      apiResponse.data.forEach((key, value) {
        print("$key: $value");
      });
      Get.to(ApiResponsePage(responseData: apiResponse.data));
    } else {
      EasyLoading.showError("⚠️ Verification failed. Check your connection.");
    }
  }
}
