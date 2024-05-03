class MediaRequest {
  final int page;
  final String query;
  final int perPage;

  MediaRequest(this.page, this.query, this.perPage);

  Map<String, dynamic> toJson() {
    return {'page': page, 'q': query, 'per_page': perPage};
  }
}