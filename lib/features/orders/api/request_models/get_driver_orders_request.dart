class GetDriverOrdersRequest {
  final int page;
  final int limit;

  const GetDriverOrdersRequest({
    required this.page,
    required this.limit,
  });

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
    };
  }
}