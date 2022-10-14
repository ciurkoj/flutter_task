import 'dart:convert';

import 'package:flutter_task/models/movie.dart';
import 'package:http/http.dart' as http;



class Webservice {

  Future<List<Movie>> fetchMovies(String keyword) async {

    String encodedQuerry = Uri.encodeFull(keyword);
    String url = "http://www.omdbapi.com/?s=$encodedQuerry&apikey=e3e0fd27";
    var response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {

      final body = jsonDecode(response.body);
      final Iterable json = body["Search"];
      return json.map((movie) => Movie.fromJson(movie)).toList();

    } else {
      throw Exception("Unable to perform request!");
    }
  }
}