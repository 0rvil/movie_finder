import 'package:http/http.dart' as http;
import 'package:movie_finder/networking/CustomExceptions.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

class ApiProvider {

  Future<dynamic> get(String url) async{
    var responseJson;
    try{
      final _baseUrl = Uri.https("m-finder-34.wl.r.appspot.com",'/$url');
      final response = await http.get(_baseUrl);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    print(responseJson);
    return responseJson;
  }

  dynamic _response(http.Response response) {
    switch(response.statusCode){
      case 200:
        var responseJson = json.decode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 403:
          throw UnauthorisedException(response.body.toString());
      default:
        throw FetchDataException('Error occurred while communicating with the Server. StatusCode : ${response.statusCode}');
    }
  }
}