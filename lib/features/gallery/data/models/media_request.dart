import 'package:equatable/equatable.dart';

class MediaRequest extends Equatable {
  final String query;
  final int page;
  final int perPage;

  const MediaRequest({
    required this.query,
    required this.page,
    required this.perPage,
  });

  @override
  List<Object?> get props => [query, page, perPage];
}
