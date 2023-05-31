// ignore_for_file: non_constant_identifier_names

import 'dart:ui';

import 'package:cineverse/utils/text.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Description extends StatelessWidget {
  final String name, description, bannerurl, posterurl, vote, launch_on;

  const Description({
    Key? key,
    required this.name,
    required this.description,
    required this.bannerurl,
    required this.posterurl,
    required this.vote,
    required this.launch_on,
  }) : super(key: key);

  Widget buildShimmerWidget({
    required Widget child,
    required double height,
    required double width,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[400]!,
      highlightColor: Colors.grey[100]!,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: height,
          width: width,
          color: Colors.white,
          child: child,
        ),
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context); // Go back when the button is pressed
              },
            ),
            const SizedBox(width: 10),
            const modified_text(
              text: 'Movie Details',
              size: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPosterImage(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: FutureBuilder(
        future: precacheImage(NetworkImage(posterurl), context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Image.network(
              posterurl,
              fit: BoxFit.cover,
            );
          }
          return buildShimmerWidget(
            child: Container(),
            height: 300,
            width: double.infinity,
          );
        },
      ),
    );
  }

  Widget buildMovieName(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 1)),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return modified_text(
            text: name,
            size: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          );
        }
        return buildShimmerWidget(
          child: Container(),
          height: 30,
          width: 200,
        );
      },
    );
  }

  Widget buildRatingAndVote(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 1)),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final voteDecimal = double.parse(vote).toStringAsFixed(1);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const modified_text(
                text: '⭐ Average Rating',
                size: 16,
                color: Colors.white,
              ),
              modified_text(
                text: voteDecimal,
                size: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildShimmerWidget(
              child: Container(),
              height: 20,
              width: 150,
            ),
            const SizedBox(height: 10),
            buildShimmerWidget(
              child: Container(),
              height: 20,
              width: 100,
            ),
          ],
        );
      },
    );
  }

  Widget buildReleaseDate(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 1)),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return modified_text(
            text: 'Releasing On - $launch_on',
            size: 16,
            color: Colors.white70,
          );
        }
        return buildShimmerWidget(
          child: Container(),
          height: 20,
          width: 200,
        );
      },
    );
  }

  Widget buildMovieDescription(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 1)),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return modified_text(
            text: description,
            size: 18,
            color: Colors.white,
          );
        }
        return buildShimmerWidget(
          child: Container(),
          height: 200,
          width: double.infinity,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              bannerurl,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.transparent,
                  Colors.black.withOpacity(0.8),
                ],
                stops: const [0.0, 0.2, 0.8],
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildAppBar(context),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildPosterImage(context),
                      const SizedBox(height: 20),
                      buildMovieName(context),
                      const SizedBox(height: 10),
                      buildRatingAndVote(context),
                      const SizedBox(height: 10),
                      buildReleaseDate(context),
                      const SizedBox(height: 20),
                      buildMovieDescription(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
