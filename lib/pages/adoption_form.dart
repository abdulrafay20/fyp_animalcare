import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdoptionForm extends StatefulWidget {
  final String petId; // Reference to the pet the user wants to adopt

  AdoptionForm({required this.petId});

  @override
  _AdoptionFormState createState() => _AdoptionFormState();
}

class _AdoptionFormState extends State<AdoptionForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  // Function to handle form submission
  void submitAdoptionInquiry() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Retrieve data from controllers
      final name = _nameController.text;
      final email = _emailController.text;
      final message = _messageController.text;

      // Save the inquiry in Firestore
      await FirebaseFirestore.instance.collection('adoption_enquiries').add({
        'name': name,
        'email': email,
        'message': message,
        'petId': widget.petId, // Reference to the pet
        'timestamp': Timestamp.now(),
      });

      // Show confirmation
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Adoption inquiry submitted successfully!'),
      ));

      // Optionally, navigate back
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    // Dispose controllers when not needed
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adopt a Pet')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(labelText: 'Message'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: submitAdoptionInquiry,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
