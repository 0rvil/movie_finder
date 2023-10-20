import 'package:movie_finder/networking/ApiProvider.dart';
import 'package:movie_finder/models/MovieResponse.dart';
class MovieRepository {
  ApiProvider _helper = ApiProvider();
  Future<List<Movie>?> fetchMovieList() async {
    final response = await _helper.get("popular");
    return MovieResponse.fromJson(response).results;
  }
}