import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/movie_bloc.dart';
import '../widgets/category_row.dart';
import 'search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<MovieBloc>().add(const FetchMoviesByYear(page: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mohannad Movie',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchPage()),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<MovieBloc>().add(const FetchMoviesByYear(page: 1));
        },
        child: BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            if (state is MovieLoading || state is MovieInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is MovieError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              );
            }
            if (state is MovieLoaded) {
              final movies = state.movies;
              return ListView(
                children: [
                  const SizedBox(height: 8),
                  CategoryRow(title: 'Most Watched — Public Domain', movies: movies),
                  CategoryRow(
                    title: 'Classics',
                    movies: movies.where((m) => (m.year ?? 0) < 1980).toList(),
                  ),
                  CategoryRow(
                    title: 'All Titles',
                    movies: movies,
                  ),
                  const SizedBox(height: 24),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
