import 'dart:convert';

import 'package:simple_economy_game/models/user.dart';
import 'package:http/http.dart' as http;
import '../models/building.dart';

class BuildingProvider {
  Future<List<Building>> getBuildings(User user) async {
    final url = 'http://localhost:8080/api/users/${user.id}/buildings';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${user.token}',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final buildingsList = jsonData['buildings'] as List<dynamic>;

      return buildingsList
          .map((buildingData) => Building(
                id: buildingData['id'],
                type: buildingData['type'],
              ))
          .toList();
    } else {
      throw Exception('Failed to fetch buildings');
    }
  }

  Future<void> buildBuilding(String type, User user) async {
    final url = 'http://localhost:8080/api/users/${user.id}/buildings';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${user.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'type': type}),
    );

    if (response.statusCode == 201) {
    } else {
      throw Exception('Failed to build building');
    }
  }
}
