import 'package:equatable/equatable.dart';

abstract class MediaEvent extends Equatable {}

class OpenPage extends MediaEvent {
  final String query;
  final int perPage;

  OpenPage({required this.query, required this.perPage});

  @override
  List<Object?> get props => [query, perPage];
}

class ReachScrollEnd extends MediaEvent {
  @override
  List<Object?> get props => [];
}

class NewQuery extends MediaEvent {
  final String text;

  NewQuery(this.text);

  @override
  List<Object?> get props => [text];
}

class ReloadButtonPressed extends MediaEvent {
  @override
  List<Object?> get props => [];
}
