import 'package:equatable/equatable.dart';

class MediaRequest extends Equatable {
  final int page;
  final String query;
  final int perPage;

  const MediaRequest(this.page, this.query, this.perPage);

  Map<String, dynamic> toJson() {
    return {'page': page, 'q': query, 'per_page': perPage};
  }

  @override
  List<Object?> get props => [page, query, perPage];
}
