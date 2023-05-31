import 'package:cineverse/utils/text.dart';
import 'package:cineverse/widgets/toprated.dart';
import 'package:cineverse/widgets/trending.dart';
import 'package:cineverse/widgets/tv.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Home(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.deepPurple,
          useMaterial3: true),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List trendingMovies = [];
  List topRatedMovies = [];
  List tvShows = [];
  final String apiKey = 'ca02d098bf97fde1ef06c32d89201081';
  final String readAccessToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjYTAyZDA5OGJmOTdmZGUxZWYwNmMzMmQ4OTIwMTA4MSIsInN1YiI6IjY0NzYwZmZjZGQyNTg5MDEyMDA2MDg3YSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.je4ZZdgWH7yRJPQ8kq88hIjcD5Dq5MdhWzSMmIIZwKI';

  @override
  void initState() {
    loadmovies();
    super.initState();
  }

  loadmovies() async {
    TMDB tmdbWithCustomLogs = TMDB(
      ApiKeys(apiKey, readAccessToken),
      logConfig: const ConfigLogger(
        showLogs: true,
        showErrorLogs: true,
      ),
    );

    Map? trendingResult = await tmdbWithCustomLogs.v3.trending.getTrending();
    Map? topRatedMoviesResult =
        await tmdbWithCustomLogs.v3.movies.getTopRated();
    Map? tvShowsResult = await tmdbWithCustomLogs.v3.tv.getPopular();

    setState(() {
      trendingMovies = trendingResult['results'] ?? [];
      topRatedMovies = topRatedMoviesResult['results'] ?? [];
      tvShows = tvShowsResult['results'] ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const modified_text(text: 'Cineverse', size: 27),
      ),
      body: ListView(children: [
        TrendingMovies(trending: trendingMovies),
        TopRated(toprated: topRatedMovies),
        TV(tv: tvShows),
      ]),
    );
  }
}
