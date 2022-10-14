
import 'package:flutter/material.dart';
import 'package:flutter_task/view%20models/movie_view_model.dart';


class MovieList extends StatelessWidget {

  final List<MovieViewModel>? movies;

  const MovieList({this.movies});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: movies?.length,
      itemBuilder: (context, index) {

        final movie = movies?[index];

        return Column(
          children: [
            Container(color:Colors.black12, height: 10,),
            ListTile(
              contentPadding: const EdgeInsets.all(20),
              leading: Container(
                decoration: BoxDecoration(
                    image: movie?.poster != null ?
                     DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(movie!.poster!)
                    ) : null,
                    borderRadius: BorderRadius.circular(6)
                ),
                width: 50,
                height: 150,
              ),
              title: Text(movie?.title ?? "no title"),
            ),
          ],
        );
      },
    );
  }
}