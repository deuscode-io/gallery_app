abstract class MediaEvent {}

class OpenPage extends MediaEvent {
  final String query;
  final int perPage;

  OpenPage({required this.query,required this.perPage});
}

class ReachScrollEnd extends MediaEvent {}

class NewQuery extends MediaEvent {
  final String text;

  NewQuery(this.text);
}

class ReloadButtonPressed extends MediaEvent {}
