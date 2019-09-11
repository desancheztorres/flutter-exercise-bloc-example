import 'package:equatable/equatable.dart';

import 'package:flutter_exercises/models/models.dart';

abstract class ExerciseState extends Equatable {
  ExerciseState([List props = const []]) : super(props);
}

class ExerciseUninitialized extends ExerciseState {
  @override
  String toString() => 'ExerciseUninitialized';
}

class ExerciseError extends ExerciseState {
  @override
  String toString() => 'ExerciseError';
}

class ExerciseLoaded extends ExerciseState {
  final List<Exercise> exercises;
  final bool hasReachedMax;

  ExerciseLoaded({
    this.exercises,
    this.hasReachedMax,
  }) : super([exercises, hasReachedMax]);

  ExerciseLoaded copyWith({
    List<Exercise> exercises,
    bool hasReachedMax,
  }) {
    return ExerciseLoaded(
      exercises: exercises ?? this.exercises,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() =>
      'ExerciseLoaded { exercises: ${exercises.length}, hasReachedMax: $hasReachedMax }';
}
