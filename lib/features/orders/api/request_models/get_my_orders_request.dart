class GetMyOrdersRequest {
  final int page;
  final int limit;

  const GetMyOrdersRequest({
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