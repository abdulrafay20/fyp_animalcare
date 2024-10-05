import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp_animalcare_app/models/pet_model.dart';
import 'package:fyp_animalcare_app/pages/lost_found_screens/found_pet_report.dart';
import 'package:fyp_animalcare_app/pages/lost_found_screens/lost_pet_report.dart';

class LostAndFoundScreen extends StatefulWidget {
  @override
  _LostAndFoundScreenState createState() => _LostAndFoundScreenState();
}

class _LostAndFoundScreenState extends State<LostAndFoundScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lost and Found Listings'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Lost'),
            Tab(text: 'Found'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          LostListings(), // Screen for lost items
          FoundListings(), // Screen for found items
        ],
      ),
    );
  }
}

class LostListings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('lost_pets')
                  .snapshots(), // Your Firestore collection for lost pets
              // .orderBy('timestamp', descending: true)
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No lost pets listed'));
                }

                List<Pet> pets = snapshot.data!.docs.map((doc) {
                  return Pet(
                      id: doc.id,
                      name: doc['name'],
                      breed: doc['breed'],
                      age: doc['age'],
                      imageUrl: doc['imageUrl'],
                      location: doc['location'],
                      description: doc['description']);
                  // gender: doc['gender']);
                }).toList();

                // Data received, build the list
                return ListView.builder(
                  itemCount: pets.length,
                  itemBuilder: (context, index) {
                    var pet = pets[index];
                    return ListTile(
                      leading: pet.imageUrl != null
                          ? Image.network(pet.imageUrl, width: 50, height: 50)
                          : const Icon(Icons.pets),
                      title: Text(pet.name ?? 'Unknown'),
                      subtitle: Text(pet.description ?? 'No description'),
                      trailing: Icon(Icons.info_outline),
                      onTap: () {
                        // Navigate to the detailed view of the lost pet
                      },
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LostPetReportScreen(),
                  ),
                );
              },
              child: const Text('Report Lost Pet'),
            ),
          ),
        ],
      ),
    );
  }
}

class FoundListings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('found_pets')
                  .snapshots(), // Your Firestore collection for found pets
              // .orderBy('timestamp', descending: true)

              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No found pets listed'));
                }

                List<Pet> pets = snapshot.data!.docs.map((doc) {
                  return Pet(
                      id: doc.id,
                      name: doc['name'],
                      breed: doc['breed'],
                      age: doc['age'],
                      imageUrl: doc['imageUrl'],
                      location: doc['location'],
                      description: doc['description']);
                      // gender: doc['gender']);
                }).toList();

                // Data received, build the list
                return ListView.builder(
                  itemCount: pets.length,
                  itemBuilder: (context, index) {
                    final pet = pets[index];
                    return ListTile(
                      leading: pet.imageUrl != null
                          ? Image.network(pet.imageUrl, width: 50, height: 50)
                          : const Icon(Icons.pets),
                      title: Text(pet.name ?? 'Unknown'),
                      subtitle: Text(pet.description ?? 'No description'),
                      trailing: Icon(Icons.info_outline),
                      onTap: () {
                        // Navigate to the detailed view of the found pet
                      },
                    );
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FoundPetReportScreen(),
                ),
              );
            },
            child: const Text('Report Found Pet'),
          ),
        ],
      ),
    );
  }
}
