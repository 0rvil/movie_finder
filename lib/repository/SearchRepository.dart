import 'package:movie_finder/models/SearchResponse.dart';
import 'package:movie_finder/networking/ApiProvider.dart';

class SearchRepository{
  ApiProvider _apiProvider = ApiProvider();

  Future<SearchResponse> fetchSearchQuery(String query) async{
    final response = await _apiProvider.get("search/"+ query);
    return SearchResponse.fromJson(response);
  }
}