import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/app_theme.dart';
import 'features/movies/presentation/bloc/movie_bloc.dart';
import 'features/movies/presentation/pages/home_page.dart';
import 'injection_container.dart';

class MohannadMovieApp extends StatelessWidget {
  const MohannadMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mohannad Movie',
      debugShowCheckedModeBanner: false,
      theme: darkTheme,
      home: BlocProvider(
        create: (_) => sl<MovieBloc>(),
        child: const HomePage(),
      ),
    );
  }
}
