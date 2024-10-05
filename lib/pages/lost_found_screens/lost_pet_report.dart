import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class LostPetReportScreen extends StatefulWidget {
  @override
  _LostPetReportScreenState createState() => _LostPetReportScreenState();
}

class _LostPetReportScreenState extends State<LostPetReportScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String? imageUrl;
  String? _gender;
  File? _imagePath;

  // Function to pick image (you can use image_picker package)
  Future<void> _pickImage() async {
    final pickImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickImage != null) {
      setState(() {
        _imagePath = File(pickImage.path);
      });
    }
  }

  // method to upload image to firebase storage and extract link

  Future<void> _uploadImage() async {
    if (_imagePath != null) {
      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('lost_pets/${DateTime.now().microsecondsSinceEpoch}.jpg');

        await storageRef.putFile(_imagePath!);

        imageUrl = await storageRef.getDownloadURL();
      } catch (e) {
        Text('Error uploading the image $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Lost Pet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the pet name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _breedController,
                decoration: const InputDecoration(labelText: 'Breed'),
              ),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Age'),
              ),
              TextFormField(
                controller: _colorController,
                decoration: const InputDecoration(labelText: 'Color'),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              TextFormField(
                controller: _locationController,
                decoration:
                    const InputDecoration(labelText: 'Last Seen Location'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: const InputDecoration(labelText: 'Gender'),
                items: const [
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                ],
                onChanged: (value) {
                  setState(() {
                    _gender = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Upload Image'),
              ),
              const SizedBox(height: 10),
              if (_imagePath != null)
                Image.file(
                  _imagePath!,
                  width: 100,
                  height: 100,
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Handle the form submission, saving data to Firestore
                     await _uploadImage();
                    // Then submit the form
                    _submitForm();
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload image of the lost pet')));
    }

    final petData = {
      'name': _nameController.text,
      'breed': _breedController.text,
      'age': int.parse(_ageController.text),
      'location': _locationController.text,
      'description': _descriptionController.text,
      'imageUrl': imageUrl!, // Use the uploaded image URL
    };

    await FirebaseFirestore.instance.collection('lost_pets').add(petData);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Lost pet reported successfully!"),
    ));

    Navigator.pop(context);

    // Clear form after submission
    _formKey.currentState?.reset();
  }
}
