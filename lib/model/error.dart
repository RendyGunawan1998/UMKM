class ErrorModel {
  int statusCode;
  String message;

  ErrorModel.fromJson(Map<String, dynamic> jsonMap)
      : statusCode = jsonMap["status"] == null ? 404 : jsonMap["status"],
        message =
            jsonMap["message"] == null ? "Oopss, Error" : jsonMap["message"];
}
