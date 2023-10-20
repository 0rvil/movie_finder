import 'package:http/http.dart' as http;
import 'package:movie_finder/networking/CustomExceptions.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

class ApiProvider {

  Future<dynamic> get(String path) async{
    try{
      final baseUrl = Uri.https("m-finder-34.wl.r.appspot.com", path);
      final response = await http.get(baseUrl);
      return _handleResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

  }

  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      case 400:
        throw BadRequestException(response.body.toString());
      case 403:
        throw UnauthorisedException(response.body.toString());
      default:
        throw FetchDataException('Error occurred while communicating with the Server. StatusCode: ${response.statusCode}');
    }
  }
}