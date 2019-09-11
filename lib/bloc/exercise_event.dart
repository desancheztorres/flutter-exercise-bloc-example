import 'package:equatable/equatable.dart';

abstract class ExerciseEvent extends Equatable {}

class Fetch extends ExerciseEvent {
  @override
  String toString() => 'Fetch';
}
