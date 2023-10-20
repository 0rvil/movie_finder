import 'package:movie_finder/networking/ApiProvider.dart';
import 'package:movie_finder/models/NowPlayingResponse.dart';
class NowPlayingRepository{
  ApiProvider _provider = ApiProvider();
  Future<List<Results>?> fetchNowPlayingList() async{
    final response = await _provider.get("nowPlaying");
    return NowPlayingResponse.fromJson(response).results;
  }
}