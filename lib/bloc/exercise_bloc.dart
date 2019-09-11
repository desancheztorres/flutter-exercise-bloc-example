import 'dart:async';
import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:flutter_exercises/bloc/bloc.dart';
import 'package:flutter_exercises/models/models.dart';

class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  final http.Client httpClient;

  ExerciseBloc({@required this.httpClient});

  int page = 1;

  @override
  Stream<ExerciseState> transformEvents(
    Stream<ExerciseEvent> events,
    Stream<ExerciseState> Function(ExerciseEvent event) next,
  ) {
    return super.transformEvents(
      (events as Observable<ExerciseEvent>).debounceTime(
        Duration(milliseconds: 500),
      ),
      next,
    );
  }

  @override
  get initialState => ExerciseUninitialized();

  @override
  Stream<ExerciseState> mapEventToState(ExerciseEvent event) async* {
    if (event is Fetch && !_hasReachedMax(currentState)) {
      try {
        if (currentState is ExerciseUninitialized) {
          final exercises = await _fetchExercises(page);
          yield ExerciseLoaded(exercises: exercises, hasReachedMax: false);
          return;
        }
        if (currentState is ExerciseLoaded) {
          page++;
          final exercises = await _fetchExercises(page);
          yield exercises.isEmpty
              ? (currentState as ExerciseLoaded).copyWith(hasReachedMax: true)
              : ExerciseLoaded(
                  exercises:
                      (currentState as ExerciseLoaded).exercises + exercises,
                  hasReachedMax: false,
                );
        }
      } catch (_) {
        yield ExerciseError();
      }
    }
  }

  bool _hasReachedMax(ExerciseState state) =>
      state is ExerciseLoaded && state.hasReachedMax;

  Future<List<Exercise>> _fetchExercises(int page) async {
    final response = await httpClient.get(
        'http://ultramuscleportal.com/ultralifestyle/public/api/exercises?page=$page');
    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedData = json.decode(response.body);

      final List<Exercise> exercises = List();

      decodedData['data'].forEach((exercise) {
        final exercisesTemp = Exercise.fromJson(exercise);

        exercises.add(exercisesTemp);
      });

      return exercises;
    } else {
      throw Exception('error fetching exercises');
    }
  }
}
