import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_exercises/bloc/bloc.dart';
import 'package:flutter_exercises/models/models.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Infinite Scroll',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Exercises'),
        ),
        body: BlocProvider(
          builder: (context) =>
              ExerciseBloc(httpClient: http.Client())..dispatch(Fetch()),
          child: HomePage(),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  ExerciseBloc _exerciseBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _exerciseBloc = BlocProvider.of<ExerciseBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExerciseBloc, ExerciseState>(
      builder: (context, state) {
        if (state is ExerciseError) {
          return Center(
            child: Text('failed to fetch exercises'),
          );
        }
        if (state is ExerciseLoaded) {
          if (state.exercises.isEmpty) {
            return Center(
              child: Text('no exercises'),
            );
          }
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return index >= state.exercises.length
                  ? BottomLoader()
                  : ExerciseWidget(exercise: state.exercises[index]);
            },
            itemCount: state.hasReachedMax
                ? state.exercises.length
                : state.exercises.length + 1,
            controller: _scrollController,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _exerciseBloc.dispatch(Fetch());
    }
  }
}

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }
}

class ExerciseWidget extends StatelessWidget {
  final Exercise exercise;

  const ExerciseWidget({Key key, @required this.exercise}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        '${exercise.id}',
        style: TextStyle(fontSize: 10.0),
      ),
      title: Text(exercise.name),
      isThreeLine: true,
      subtitle: Text(exercise.description),
      dense: true,
    );
  }
}
