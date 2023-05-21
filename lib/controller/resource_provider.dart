import 'dart:convert';

import 'package:simple_econmy_game/models/user.dart';

import '../models/resource.dart';
import 'package:http/http.dart' as http;

class ResourceProvider {
  Future<List<Resource>> getResources(User user) async {
    final url = 'http://localhost:8080/api/users/${user.id}/resources';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${user.token}',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final resourcesList = jsonData['resources'] as List<dynamic>;

      return resourcesList
          .map((resourceData) => Resource(
                type: resourceData['type'],
                id: resourceData['id'],
                amount: resourceData['amount'],
              ))
          .toList();
    } else {
      throw Exception('Failed to fetch resources');
    }
  }
}
