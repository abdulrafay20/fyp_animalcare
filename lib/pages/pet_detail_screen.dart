import 'package:flutter/material.dart';
import 'package:fyp_animalcare_app/models/pet_model.dart';
import 'package:fyp_animalcare_app/pages/adoption_form.dart';

class PetDetailScreen extends StatelessWidget {
  final Pet pet;

  PetDetailScreen({required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pet.name)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.network(pet.imageUrl),
          const SizedBox(height: 10),
          Text(pet.breed, style: const TextStyle(fontSize: 24)),
          Text('${pet.age} years old', style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(pet.description),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
             Navigator.push(
              context,
              MaterialPageRoute(
              builder: (context) => AdoptionForm(petId: pet.id),
      ),
    );
  },
  child: const Text('Adopt Me'),
),
        ],
      ),
    );
  }
}
