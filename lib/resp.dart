import 'dart:convert';

VerifyToken verifyTokenFromJson(String str) =>
    VerifyToken.fromJson(json.decode(str));

String verifyTokenToJson(VerifyToken data) => json.encode(data.toJson());

class VerifyToken {
  VerifyToken({
    required this.access_token,
    required this.refresh_token,
  });

  final String access_token;
  final String refresh_token;

  factory VerifyToken.fromJson(Map<String, dynamic> json) => VerifyToken(
        access_token: json["access_token"],
        refresh_token: json["refresh_token"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": access_token,
        "refresh_token": refresh_token,
      };
}

VerifySelfie verifySelfieFromJson(String str) =>
    VerifySelfie.fromJson(json.decode(str));

String verifySelfieToJson(VerifyToken data) => json.encode(data.toJson());

class VerifySelfie {
  VerifySelfie({
    required this.isMatching,
  });

  final bool isMatching;

  factory VerifySelfie.fromJson(Map<String, dynamic> json) => VerifySelfie(
        isMatching: json["isMatching"],
      );

  Map<String, dynamic> toJson() => {
        "isMatching": isMatching,
      };
}

class VerifySuccess {
  VerifySuccess({
    required this.successful,
    required this.fieldComparisonList,
  });

  final bool successful;
  final List<FieldComparison> fieldComparisonList;

  factory VerifySuccess.fromJson(Map<String, dynamic> json) => VerifySuccess(
        successful: json["successful"],
        fieldComparisonList: List<FieldComparison>.from(
            json["fieldComparisonList"]
                .map((x) => FieldComparison.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "successful": successful,
        "fieldComparisonList":
            List<dynamic>.from(fieldComparisonList.map((x) => x.toJson())),
      };
}

class FieldComparison {
  FieldComparison({
    required this.sourceFieldName,
    required this.targetFieldName,
    required this.comparisonScore,
    required this.comparisonStatus,
  });

  final String sourceFieldName;
  final String targetFieldName;
  final double comparisonScore;
  final String comparisonStatus;

  factory FieldComparison.fromJson(Map<String, dynamic> json) =>
      FieldComparison(
        sourceFieldName: json["sourceFieldName"],
        targetFieldName: json["targetFieldName"],
        comparisonScore: json["comparisonScore"].toDouble(),
        comparisonStatus: json["comparisonStatus"],
      );

  Map<String, dynamic> toJson() => {
        "sourceFieldName": sourceFieldName,
        "targetFieldName": targetFieldName,
        "comparisonScore": comparisonScore,
        "comparisonStatus": comparisonStatus,
      };
}

class ApiResponse {
  final Map<String, dynamic> data;

  ApiResponse({required this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(data: json);
  }

  dynamic get(String key) => data[key]; // Getter to access fields easily
}
