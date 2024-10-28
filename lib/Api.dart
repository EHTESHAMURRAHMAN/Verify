import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:verify_demo/commonToken.dart';
import 'package:verify_demo/resp.dart';

class Api {
  Future<void> selfieCheck(String accessToken, String idMatchWithFace) async {
    try {
      EasyLoading.show(status: '🧐 Verifying your selfie, hold on...');

      Map<String, String> headers = {
        "X-TenantID": "19",
        "Authorization": "Bearer $accessToken",
        'Content-Type': 'application/json'
      };
      final body = jsonEncode({
        "eventType": "SELFIE_MATCH",
        "idDocBase64String": idMatchWithFace,
        "idDocImageFormat": "PNG",
        "isRetry": true,
        "previousEventId": 0,
        "requestId": "1",
        "selfieBase64String": "",
        "selfieImageFormat": "PNG"
      });

      final response = await http.post(
        Uri.parse('$baseVerifyApi/kyc/v1/selfie/images/match'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        VerifySelfie data = verifySelfieFromJson(response.body);

        if (data.isMatching == true) {
          // Show success message for 2 seconds
          EasyLoading.showSuccess('✅ Selfie verified successfully! 🙌');

          // After showing success, start loading again for the next step
          EasyLoading.show(status: '🔄 Uploading selfie, please wait...');
        } else {
          EasyLoading.showError('❌ Selfie mismatch, try again.');
        }
      } else {
        EasyLoading.showError('⚠️ Verification failed, check your connection.');
      }
    } catch (e) {
      EasyLoading.showError('🚨 Error during selfie verification.');
    } finally {
      EasyLoading.dismiss();
    }
  }
}
