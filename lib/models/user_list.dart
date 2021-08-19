class UserList {
  UserList(this.username, this.query, this.order, this.sort, this.type);

  final String username;
  final String? query;
  final String? order;
  final String? sort;
  final String type;

  String? get title => query == '' ? null : query;

  Map<String, String?> toJson() {
    return {
      'username': username,
      'query': query,
      'order': order,
      'sort': sort,
      'type': type,
    };
  }
}
