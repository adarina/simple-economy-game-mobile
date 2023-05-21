import 'dart:async';
import 'package:flutter/material.dart';
import 'package:simple_econmy_game/models/building.dart';
import 'package:simple_econmy_game/controller/building_provider.dart';
import 'package:simple_econmy_game/models/resource.dart';
import 'package:simple_econmy_game/controller/resource_provider.dart';
import 'package:simple_econmy_game/models/user.dart';

class HomePage extends StatelessWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    ResourceProvider resourceProvider = ResourceProvider();
    BuildingProvider buildingProvider = BuildingProvider();

    Stream<List<Resource>> resourceStream =
        Stream.periodic(const Duration(seconds: 1))
            .asyncMap((_) => resourceProvider.getResources(user));
    Stream<List<Building>> buildingStream =
        Stream.periodic(const Duration(seconds: 1))
            .asyncMap((_) => buildingProvider.getBuildings(user));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 156, 112, 112),
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 250, 244, 211),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Logged in as: ${user.username}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  'Resources',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              StreamBuilder<List<Resource>>(
                stream: resourceStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final resources = snapshot.data!;

                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: resources.length * 2,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        if (index % 2 == 0) {
                          final resourceIndex = index ~/ 2;
                          final resource = resources[resourceIndex];
                          final imageName = '${resource.type}.png';

                          return SizedBox(
                            width: 40,
                            height: 40,
                            child: Image.asset(
                              'assets/images/$imageName',
                              fit: BoxFit.contain,
                            ),
                          );
                        } else {
                          final resourceIndex = (index - 1) ~/ 2;
                          final resource = resources[resourceIndex];

                          return Center(
                            child: Text('${resource.amount}'),
                          );
                        }
                      },
                    );
                  } else {
                    return const Text('No data');
                  }
                },
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Buildings Shop',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () =>
                          buildingProvider.buildBuilding('COTTAGE', user),
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 134, 150, 103)),
                      child: const Text(
                        'Add Cottage',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () =>
                          buildingProvider.buildBuilding('QUARRY', user),
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 134, 150, 103)),
                      child: const Text('Add Quarry'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () =>
                          buildingProvider.buildBuilding('HUT', user),
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 134, 150, 103)),
                      child: const Text('Add Hut'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () =>
                          buildingProvider.buildBuilding('CAVE', user),
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 134, 150, 103)),
                      child: const Text('Add Cave'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () =>
                          buildingProvider.buildBuilding('PIT', user),
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 134, 150, 103)),
                      child: const Text('Add Pit'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () =>
                          buildingProvider.buildBuilding('CAVERN', user),
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 134, 150, 103)),
                      child: const Text('Add Cavern'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              const Center(
                child: Text(
                  'Buildings',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              StreamBuilder<List<Building>>(
                stream: buildingStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final buildings = snapshot.data!;

                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: buildings.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        final building = buildings[index];
                        final imageName = '${building.type}.png';

                        return SizedBox(
                          width: 40,
                          height: 40,
                          child: Image.asset(
                            'assets/images/$imageName',
                            fit: BoxFit.contain,
                          ),
                        );
                      },
                    );
                  } else {
                    return const Text('No data');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
