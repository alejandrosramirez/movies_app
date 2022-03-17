import 'dart:convert';

// own
import 'package:movies_app/models/models.dart';

class NowPlaying {
  NowPlaying({
    required this.dates,
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  Dates dates;
  int page;
  List<Movie> results;
  int totalPages;
  int totalResults;

  factory NowPlaying.fromJson(String str) =>
      NowPlaying.fromMap(json.decode(str));

  factory NowPlaying.fromMap(Map<String, dynamic> json) => NowPlaying(
        dates: Dates.fromMap(json["dates"]),
        page: json["page"],
        results: List<Movie>.from(json["results"].map((x) => Movie.fromMap(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );
}
