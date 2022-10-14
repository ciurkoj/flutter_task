import 'package:flutter/material.dart';
import 'package:flutter_task/services/web_service.dart';

import 'movie_view_model.dart';

class MovieListViewModel extends ChangeNotifier {

  List<MovieViewModel> movies = [];

  Future<void> fetchMovies(String keyword) async {
    final results =  await Webservice().fetchMovies(keyword);
    movies = results.map((item) => MovieViewModel(movie: item)).toList();
    print(this.movies);
    notifyListeners();
  }

}