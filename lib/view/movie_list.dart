import 'package:movie_finder/blocs/movie_bloc.dart';
import 'package:movie_finder/models/MovieResponse.dart';
import 'package:movie_finder/networking/Response.dart';
import 'package:flutter/material.dart';
import 'package:movie_finder/view/Search_View.dart';
import 'package:movie_finder/view/movie_detailed_view.dart';

String search = 'The dark knight rises';

class MovieScreen extends StatefulWidget {
  @override
  _MovieScreenState createState() => _MovieScreenState();
}
class _MovieScreenState extends State<MovieScreen> {
  MovieBloc _bloc;
  final myController = TextEditingController();
  bool isSearching = false;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _bloc = MovieBloc();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !isSearching ? Text("Movie Finder"): TextField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration( prefixIcon: IconButton(
              icon: Icon(Icons.search),
              color: Colors.white,
              onPressed: () {
                search = myController.text;
                myController.clear();
                setState(() {
                  isSearching = false;
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          SearchScreen(search)));
                });
              }),
              hintText: "Search for a Movie",
              hintStyle: TextStyle(color: Colors.white)
          ),
          controller: myController,
        ),
        actions: <Widget>[
          IconButton(icon: !isSearching ? Icon(Icons.search): Icon(Icons.cancel), onPressed: (){
            setState(() {
              this.isSearching = !this.isSearching;
            });
          })
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _bloc.fetchMovieList(),
        child: StreamBuilder<Response<List<Movie>>>(
          stream: _bloc.movieListStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return Loading(loadingMessage: snapshot.data.message);
                  break;
                case Status.COMPLETED:
                  return MovieList(movieList: snapshot.data.data);
                  break;
                case Status.ERROR:
                  return Error(
                    errorMessage: snapshot.data.message,
                    onRetryPressed: () => _bloc.fetchMovieList(),
                  );
                  break;
              }
            }
            return Container();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            setState(() {
              _isListening = !this._isListening;
            });
          },
          child: Icon(Icons.mic),
        ),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movieList;
  const MovieList({Key key, this.movieList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(alignment: Alignment.topLeft ,
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0, top: 8.0),
              child: Text("Popular", style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
            )),
        Container(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movieList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            MovieDetailedView(movieList[index].id.toString())));
                  },
                  child: Card(
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w342${movieList[index].posterPath}',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class Error extends StatelessWidget {
  final String errorMessage;
  final Function onRetryPressed;
  const Error({Key key, this.errorMessage, this.onRetryPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
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
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color> (Colors.redAccent)),
            child: Text(
              'Retry',
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