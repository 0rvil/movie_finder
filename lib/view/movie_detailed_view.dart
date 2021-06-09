import 'package:flutter/material.dart';
import 'package:movie_finder/blocs/MovieDetailedBloc.dart';
import 'package:movie_finder/models/MovieDetailedResponse.dart';
import 'package:movie_finder/networking/Response.dart';


class MovieDetailedView extends StatefulWidget{
  final String selectedMovie;
  const MovieDetailedView(this.selectedMovie);

  @override
  _MovieDetailedViewState createState() => _MovieDetailedViewState();

}

class _MovieDetailedViewState extends State<MovieDetailedView>{
  MovieDetailedBloc _bloc;

  @override
  void initState(){
    super.initState();
    _bloc = MovieDetailedBloc(widget.selectedMovie);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movie Finder"),
      ),
      body: RefreshIndicator(
        onRefresh: () => _bloc.fetchMovieDetails(widget.selectedMovie),
        child: StreamBuilder<Response<MovieDetailedResponse>>(
          stream: _bloc.detailedDataStream,
          builder: (context,snapshot){
            if(snapshot.hasData){
              switch (snapshot.data.status){
                case Status.LOADING:
                  return Loading(loadingMessage: snapshot.data.message);
                  break;
                case Status.COMPLETED:
                  return MovieCard(movieResponse: snapshot.data.data);
                  break;
                case Status.ERROR:
                  return Error(errorMessage: snapshot.data.message,
                    onRetryPressed: ()=> _bloc.fetchMovieDetails(widget.selectedMovie),
                  );
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

class MovieCard extends StatefulWidget{
  final MovieDetailedResponse movieResponse;
  const MovieCard({Key key, this.movieResponse}): super(key:key);

  @override
  _MovieCardState createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard>{
  bool saved = false;
  bool watchList = false;

  @override
  Widget build(BuildContext context) {
    // Scaffold Messenger for SnackBar
    final messenger = ScaffoldMessenger.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10,10,10,0),
        child:  Center(
          child:
          Card(elevation: 5.0,
              child: Column(
                children: [
                  ListTile(
                    title:Text(widget.movieResponse.title),
                    subtitle: Text(widget.movieResponse.releaseDate),
                  ),
                  Image.network('https://image.tmdb.org/t/p/w342${widget.movieResponse.posterPath}'),
                  ButtonBar(
                    children: [
                      IconButton(
                        icon: Icon(saved ? Icons.favorite : Icons.favorite_border_outlined,
                          color: saved ? Colors.red : null,),
                        onPressed: (){
                          setState(() {
                            saved = !this.saved;
                            messenger.showSnackBar( SnackBar(content: Text( saved ? 'Added to Favorites' : 'Removed from Favorites' )));
                          });
                        },
                      ),
                      IconButton(
                          icon: Icon(watchList ? Icons.bookmark :Icons.bookmark_border_outlined,
                              color: watchList ? Colors.blue: null),
                          onPressed: (){
                            setState(() {
                              watchList = !this.watchList;
                              messenger.showSnackBar(SnackBar(content: Text( watchList? 'Added to Watch List' : 'Removed from Watch List')));
                            });
                          })
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(widget.movieResponse.overview,),
                  ),
                ],
              )),
        ),
      ),
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