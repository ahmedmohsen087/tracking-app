class GetOrdersRequest {
  final int page;
  final int limit;

  const GetOrdersRequest({
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