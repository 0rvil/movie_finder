import 'package:movie_finder/networking/ApiProvider.dart';
import 'package:movie_finder/models/MovieDetailedResponse.dart';
class MovieDetailRepository{
  ApiProvider _apiProvider = ApiProvider();

  Future<MovieDetailedResponse> fetchMovieDetails(String query) async {
    final response = await _apiProvider.get("movie/" + query);
    return MovieDetailedResponse.fromJson(response);
  }
}