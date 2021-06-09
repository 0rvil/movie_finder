import 'dart:async';
import 'package:movie_finder/models/SearchResponse.dart';
import 'package:movie_finder/networking/Response.dart';
import 'package:movie_finder/repository/SearchRepository.dart';

class SearchBloc{
  SearchRepository _searchRepository;
  StreamController _searchDataController;

  StreamSink<Response<SearchResponse>> get searchDataSink => _searchDataController.sink;

  Stream<Response<SearchResponse>> get searchDataStream => _searchDataController.stream;


  SearchBloc(String query){
    _searchDataController = StreamController<Response<SearchResponse>>();
    _searchRepository = SearchRepository();
    fetchSearchQuery(query);
  }

  fetchSearchQuery(String query) async{
    searchDataSink.add(Response.loading("Retrieving Search..."));
    try{
      SearchResponse search = await _searchRepository.fetchSearchQuery(query);
      searchDataSink.add(Response.completed(search));
    } catch(e){
      searchDataSink.add(Response.error(e.toString()));
      print(e);
      print("Mission failed");
    }
  }

  dispose(){
    _searchDataController?.close();
  }
}