import 'package:flutter/material.dart';
import 'package:fyp_animalcare_app/models/pet_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_animalcare_app/pages/adoption_post.dart';
import 'package:fyp_animalcare_app/pages/pet_detail_screen.dart';

class PetListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Pets for Adoption'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('adoption_pets').snapshots(),
              builder: (context, snapshot) {

                // If data is loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // If snapshot has no data
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No pets available for adoption.'));
                }

                // List of Pets mapped from the firestore documents
                List<Pet> pets = snapshot.data!.docs.map((doc) {
                  return Pet(
                    id: doc.id,
                    name: doc['name'],
                    breed: doc['breed'],
                    age: doc['age'],
                    imageUrl: doc['imageUrl'],
                    location: doc['location'],
                    description: doc['description'],
                    // gender: doc['gender']
                  );  
                }).toList();
            
                return ListView.builder(
                  itemCount: pets.length,
                  itemBuilder: (context, index) {
                    final pet = pets[index];
                    return ListTile(
                      leading: Image.network(pet.imageUrl),
                      title: Text(pet.name),
                      subtitle: Text('${pet.breed}, Age: ${pet.age}'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PetDetailScreen(pet: pet)));
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
                  MaterialPageRoute(builder: (context) => PostAdoptionScreen()),
                );
              },
              child: const Text('Post a Pet for Adoption'),
            ),
      )],
      ),
    );
  }
}
