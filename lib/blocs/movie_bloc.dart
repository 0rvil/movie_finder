import 'dart:async';
import 'package:movie_finder/networking/Response.dart';
import 'package:movie_finder/repository/MovieRepository.dart';
import 'package:movie_finder/models/MovieResponse.dart';

class MovieBloc {
  MovieRepository _movieRepository;
  StreamController _movieListController;

  StreamSink<Response<List<Movie>>> get movieListSink =>
      _movieListController.sink;

  Stream<Response<List<Movie>>> get movieListStream =>
      _movieListController.stream;

  MovieBloc() {
    _movieListController = StreamController<Response<List<Movie>>>();
    _movieRepository = MovieRepository();
    fetchMovieList();
  }
  fetchMovieList() async {
    movieListSink.add(Response.loading('Fetching Movies'));
    try {
      List<Movie> movies = await _movieRepository.fetchMovieList();
      movieListSink.add(Response.completed(movies));
    } catch (e) {
      movieListSink.add(Response.error(e.toString()));
      print(e);
    }
  }
  dispose() {
    _movieListController?.close();
  }
}