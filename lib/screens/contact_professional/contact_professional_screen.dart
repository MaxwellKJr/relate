import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class ContactProfessionalScreen extends StatefulWidget {
  const ContactProfessionalScreen({Key? key}) : super(key: key);

  @override
  _ContactProfessionalScreenState createState() =>
      _ContactProfessionalScreenState();
}

class _ContactProfessionalScreenState extends State<ContactProfessionalScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _specializationController =
  TextEditingController();
  XFile? _imageFile;
  final TextEditingController _descriptionController =
  TextEditingController();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imageFile = pickedImage;
      });
    }
  }

  void _addProfessional() async {
    final name = _nameController.text;
    final specialization = _specializationController.text;
    final description = _descriptionController.text;

    if (name.isEmpty || specialization.isEmpty || description.isEmpty) {
      return;
    }

    final docRef = await FirebaseFirestore.instance
        .collection('professionals')
        .add({
      'name': name,
      'specialization': specialization,
      'image': _imageFile?.path,
      'description': description,
    });

    // Clear input fields and image
    _nameController.clear();
    _specializationController.clear();
    _descriptionController.clear();
    setState(() {
      _imageFile = null;
    });

    // Show success message or navigate to the next screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Professional added successfully!'),
      ),
    );
  }

  void _navigateToSendMessage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessageDetailPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Professional'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _specializationController,
                decoration: const InputDecoration(labelText: 'Specialization'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
              if (_imageFile != null)
                Image.file(File(_imageFile!.path)),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _addProfessional,
                child: const Text('Add Professional'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _navigateToSendMessage,
                child: const Text('Send Message'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Message'),
      ),
      body: const Center(
        child: Text('Send a message to the professional'),
      ),
    );
  }
}
