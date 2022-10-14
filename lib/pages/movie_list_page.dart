import 'package:flutter/material.dart';
import 'package:flutter_task/view%20models/movie_list_view_model.dart';
import 'package:flutter_task/widgets/movie_list.dart';

import 'package:provider/provider.dart';

class MovieListPage extends StatefulWidget {
  @override
  _MovieListPageState createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // you can uncomment this to get all batman movies when the page is loaded
    //Provider.of<MovieListViewModel>(context, listen: false).fetchMovies("batman");
  }

  @override
  Widget build(BuildContext context) {

    final vm = Provider.of<MovieListViewModel>(context);

    return Wrap(
      children: [
        Center(child: Text("MVVM model demo", style: Theme.of(context).textTheme.headline3,)),
        Center(child: Text("Simply type a name of a film to get a list of related films", style: Theme.of(context).textTheme.subtitle1,)),
        Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: TextField(
                  controller: _controller,
                  onSubmitted: (value) {
                    if(value.isNotEmpty) {
                      vm.fetchMovies(value.characters.last == " " ? value.substring(0, value.length-1) : value);
                    }
                  },
                  decoration: const InputDecoration(
                      hintText: "Search",
                      hintStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none
                  ),

                ),
              ),
              Expanded(
                  child: MovieList(movies: vm.movies))
            ])
        ),
      ],
    );
  }
}