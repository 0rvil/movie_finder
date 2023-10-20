import 'dart:async';
import 'package:movie_finder/models/SearchResponse.dart';
import 'package:movie_finder/networking/Response.dart';
import 'package:movie_finder/repository/SearchRepository.dart';

class SearchBloc{
  late SearchRepository _searchRepository;
  late StreamController<Response<SearchResponse>> _searchDataController;

  StreamSink<Response<SearchResponse>> get searchDataSink => _searchDataController.sink;
  Stream<Response<SearchResponse>> get searchDataStream => _searchDataController.stream;


  SearchBloc(String? query){
    _searchDataController = StreamController<Response<SearchResponse>>();
    _searchRepository = SearchRepository();
    if (query != null) {
      fetchSearchQuery(query);
    }
  }

  fetchSearchQuery(String? query) async{
    if (query == null) {
      searchDataSink.add(Response.error("Query is null"));
      return;
    }
    searchDataSink.add(Response.loading("Retrieving Search..."));
    try{
      SearchResponse search = await _searchRepository.fetchSearchQuery(query);
      searchDataSink.add(Response.completed(search));
    } catch(e){
      searchDataSink.add(Response.error(e.toString()));
      print(e);
      print("Query failed");
    }
  }

  void dispose(){
    _searchDataController.close();
  }
}