import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class PostAdoptionScreen extends StatefulWidget {
  @override
  _PostAdoptionScreenState createState() => _PostAdoptionScreenState();
}

class _PostAdoptionScreenState extends State<PostAdoptionScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form field controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _imageUrl; // Store the image URL after uploading to Firebase
  File? _imagePath; // Local file path for the picked image

  // Method to pick image using ImagePicker
  Future<void> _pickImage() async {
    // picking up image from gallery and storing in pickedfile variable
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        // storing file path into _imagefile variable
        _imagePath = File(pickedFile.path);
      });
    }
  }

  // Method to upload image to Firebase Storage and get the URL
  Future<void> _uploadImage() async {
    if (_imagePath != null) {
      try {
        // Upload to Firebase Storage

        // getting a storage reference of Firebase
        final storageRef = FirebaseStorage.instance.ref().child(
            'adoption_pets/${DateTime.now().millisecondsSinceEpoch}.jpg');

        // uploading file
        await storageRef.putFile(_imagePath!);

        // Get download URL
        _imageUrl = await storageRef.getDownloadURL();
      } catch (e) {
        Text('Error uploading image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post a Pet for Adoption"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Pet Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a pet name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _breedController,
                decoration: const InputDecoration(labelText: "Breed"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the breed';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: "Age"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the pet\'s age';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: "Location"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your location';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              if (_imagePath != null)
                Center(
                  child: Image.file(
                    _imagePath!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                )
              else
                const Text("No image selected"),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text("Upload Pet Image"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Upload the image first before submitting the form
                    await _uploadImage();
                    // Then submit the form
                    _submitForm();
                  }
                },
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    // Ensure the image URL is available after uploading
    if (_imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please upload a pet image"),
      ));
      return;
    }

    // Collect form data and the image URL
    final petData = {
      'name': _nameController.text,
      'breed': _breedController.text,
      'age': int.parse(_ageController.text),
      'location': _locationController.text,
      'description': _descriptionController.text,
      'imageUrl': _imageUrl!, // Use the uploaded image URL
    };

    // Firestore add function
    await FirebaseFirestore.instance.collection('adoption_pets').add(petData);

    // Show success message or navigate back
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Pet posted for adoption successfully!"),
    ));

    Navigator.pop(context);

    // Clear form after submission
    _formKey.currentState?.reset();
  }
}
