import 'package:flutter/material.dart';
import 'package:movie_finder/blocs/SearchBloc.dart';
import 'package:movie_finder/models/SearchResponse.dart';
import 'package:movie_finder/networking/Response.dart';
import 'package:movie_finder/view/movie_detailed_view.dart';

class SearchScreen extends StatefulWidget {
  final String selectedQuery;
  const SearchScreen(this.selectedQuery);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>{
  SearchBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = SearchBloc(widget.selectedQuery);
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text("Movie Finder"),
     ),
     body: RefreshIndicator(
       onRefresh: () => _bloc.fetchSearchQuery(widget.selectedQuery),
       child: StreamBuilder<Response<SearchResponse>>(
         stream: _bloc.searchDataStream,
         builder: (context,snapshot){
           if(snapshot.hasData){
             switch (snapshot.data.status){
               case Status.LOADING:
                 return Loading(loadingMessage: snapshot.data.message);
                 break;
               case Status.COMPLETED:
                 return _SearchListState(searchResponse: snapshot.data.data);
                 break;
               case Status.ERROR:
                 return Error(errorMessage: snapshot.data.message,
                     onRetryPressed: ()=> _bloc.fetchSearchQuery(widget.selectedQuery), );
                 break;
             }
           }
           return Container();
         },
       ),
     ),
   );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}

class _SearchListState extends StatelessWidget{
  final SearchResponse searchResponse;
  bool saved = false;
  bool watchList = false;

  _SearchListState({Key key, this.searchResponse}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final List<Results> list = searchResponse.results;

      return SingleChildScrollView(
        physics: ScrollPhysics(),
        child: (
          ListView.builder(
            itemCount: searchResponse.results.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            MovieDetailedView(list[index].id.toString()))),
                    child: Card(
                       elevation: 5.0,
                      child: Column(
                        children: [
                          ListTile(
                            title:Text(list[index].title),
                            subtitle: Text(list[index].releaseDate),
                          ),
                          SizedBox(
                            height: 300,
                              width: 200,
                              child: Image.network('https://image.tmdb.org/t/p/w342${list[index].posterPath}', scale: 0.5,),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(list[index].overview, overflow: TextOverflow.ellipsis,),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
            },
          )
        )
        );
    }
}

class Error extends StatelessWidget{
  final String errorMessage;
  final Function onRetryPressed;

  const Error({Key key, this.errorMessage, this.onRetryPressed}): super(key: key);

  @override
  Widget build(BuildContext context) {
    print(errorMessage);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          OutlinedButton(
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent.shade100)),
            child: Text(
              'Retry',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: onRetryPressed,
          )
        ],
      ),
    );
  }
}

class Loading extends StatelessWidget {
  final String loadingMessage;
  const Loading({Key key, this.loadingMessage}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            loadingMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          SizedBox(height: 24),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreen),
          ),
        ],
      ),
    );
  }
}