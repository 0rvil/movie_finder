import 'dart:async';

import 'package:movie_finder/models/MovieDetailedResponse.dart';
import 'package:movie_finder/networking/Response.dart';
import 'package:movie_finder/repository/MovieDetailRepository.dart';

class MovieDetailedBloc{
  late MovieDetailRepository _detailRepository;
  late StreamController<Response<MovieDetailedResponse>> _controller;

  StreamSink<Response<MovieDetailedResponse>> get detailedDataSink =>
      _controller.sink;

  Stream<Response<MovieDetailedResponse>> get detailedDataStream =>
      _controller.stream;

  MovieDetailedBloc(String? query){
    _controller = StreamController<Response<MovieDetailedResponse>>();
    _detailRepository = MovieDetailRepository();
    if(query != null){
      fetchMovieDetails(query);
    }
  }

  Future<void> fetchMovieDetails(String query) async{
    detailedDataSink.add(Response.loading("Retrieving Data..."));
    try{
      MovieDetailedResponse search = await _detailRepository.fetchMovieDetails(query);
      detailedDataSink.add(Response.completed(search));
    } catch(e){
      detailedDataSink.add(Response.error(e.toString()));
    }
  }

  void dispose(){
    _controller.close();
  }

}