import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/helpers/debouncer.dart';

// own
import 'package:movies_app/models/models.dart';

class MoviesProvider extends ChangeNotifier {
  final String _baseUrl = 'api.themoviedb.org';
  final String _apiKey = 'b74470fb7dc90218e33a8edff9285f9b';
  final String _language = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];
  Map<int, List<Cast>> moviesCast = {};
  int _popularPage = 0;

  final debouncer = Debouncer(duration: const Duration(milliseconds: 500));

  final StreamController<List<Movie>> _suggestionStreamController =
      StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream =>
      _suggestionStreamController.stream;

  MoviesProvider() {
    getOnDisplayMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    final url = Uri.https(
      _baseUrl,
      endpoint,
      {'api_key': _apiKey, 'language': _language, 'page': '$page'},
    );

    final response = await http.get(url);

    return response.body;
  }

  getOnDisplayMovies() async {
    final jsonData = await _getJsonData('3/movie/now_playing');

    final nowPlayingResp = NowPlaying.fromJson(jsonData);

    onDisplayMovies = nowPlayingResp.results;

    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage++;

    final jsonData = await _getJsonData('/3/movie/popular', _popularPage);

    final popularResp = Popular.fromJson(jsonData);

    popularMovies = [...popularMovies, ...popularResp.results];

    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int id) async {
    if (moviesCast.containsKey(id)) {
      return moviesCast[id]!;
    }

    final jsonData = await _getJsonData('3/movie/$id/credits');

    final creditsResp = Credits.fromJson(jsonData);

    moviesCast[id] = creditsResp.cast;

    return creditsResp.cast;
  }

  Future<List<Movie>> searchMovie(String query) async {
    final url = Uri.https(
      _baseUrl,
      '3/search/movie',
      {'api_key': _apiKey, 'language': _language, 'query': query},
    );

    final response = await http.get(url);

    final searchResp = Search.fromJson(response.body);

    return searchResp.results;
  }

  void getSuggestionsByQuery(String query) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      print('Jeje');
      final results = await searchMovie(value);

      _suggestionStreamController.add(results);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debouncer.value = query;
    });

    Future.delayed(const Duration(milliseconds: 301))
        .then((_) => timer.cancel());
  }
}
