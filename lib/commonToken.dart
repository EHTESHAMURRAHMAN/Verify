import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:verify_demo/Api.dart';
import 'package:verify_demo/resp.dart';

const String baseVerifyApi = "";

class CommonToken {
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
        await Api().selfieCheck(
            data.access_token, ''); // Wait for selfieCheck to complete
      } else {
        EasyLoading.showError('❌ Failed to refresh session.');
      }
    } catch (e) {
      EasyLoading.showError('🚨 Error while refreshing token.');
    }
  }
}
