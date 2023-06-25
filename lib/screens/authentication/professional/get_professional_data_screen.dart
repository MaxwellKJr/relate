import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:relate/constants/colors.dart';
import 'package:relate/constants/size_values.dart';
import 'package:relate/constants/text_string.dart';
import 'package:relate/screens/authentication/get_user_data_screen.dart';
import 'package:relate/services/auth.dart';
import 'package:relate/components/form_text_field.dart';
import 'package:google_fonts/google_fonts.dart';

class GetProfessionalDataScreen extends StatefulWidget {
  const GetProfessionalDataScreen({super.key});

  @override
  State<GetProfessionalDataScreen> createState() =>
      _GetProfessionalDataScreenState();
}

class _GetProfessionalDataScreenState extends State<GetProfessionalDataScreen> {
  final Auth auth = Auth();

  final _bioController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _locationController = TextEditingController();

  String imageUrl = '';

  final _formKey = GlobalKey<FormState>();

  final _focusNode1 = FocusNode();
  final _focusNode2 = FocusNode();
  final _focusNode3 = FocusNode();

  bool _isLoading = false;

  void onButtonPressed() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(layoutPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "We need to know you more...",
                      style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: primaryColor),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: elementSpacing),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () async {
                            ImagePicker imagePicker = ImagePicker();
                            XFile? file = await imagePicker.pickImage(
                                source: ImageSource.gallery);
                            print('${file?.path}');

                            if (file == null) return;
                            String uniqueImageName = DateTime.now()
                                .millisecondsSinceEpoch
                                .toString();

                            Reference referenceRoot =
                                FirebaseStorage.instance.ref();
                            Reference referenceDirImages =
                                referenceRoot.child('images');

                            Reference imageReferenceToUpload =
                                referenceDirImages.child(uniqueImageName);

                            await imageReferenceToUpload
                                .putFile(File(file.path));
                            imageUrl =
                                await imageReferenceToUpload.getDownloadURL();
                          },
                          icon: const Icon(Icons.camera_alt),
                        ),
                      ],
                    ),
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            FormTextField(
                              controller: _bioController,
                              hintText: "Bio",
                              obscureText: false,
                              prefixIcon: const Icon(Icons.person),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.name,
                              focusNode: _focusNode1,
                              onFieldSubmitted: (value) =>
                                  FocusScope.of(context)
                                      .requestFocus(_focusNode2),
                            ),
                            const SizedBox(height: elementSpacing),
                            FormTextField(
                              controller: _phoneNumberController,
                              hintText: "Phone number",
                              obscureText: false,
                              prefixIcon: const Icon(Icons.phone),
                              textInputAction: TextInputAction.next,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: true, decimal: false),
                              focusNode: _focusNode2,
                              onFieldSubmitted: (value) =>
                                  FocusScope.of(context)
                                      .requestFocus(_focusNode3),
                            ),
                            const SizedBox(height: elementSpacing),
                            FormTextField(
                              controller: _locationController,
                              hintText:
                                  "Where do you work from (Residence or Workplace)",
                              obscureText: false,
                              prefixIcon: const Icon(Icons.location_pin),
                              textInputAction: TextInputAction.send,
                              keyboardType: TextInputType.text,
                              focusNode: _focusNode3,
                              onFieldSubmitted: (value) =>
                                  auth.updateProfessionalDetails(
                                      context,
                                      _bioController,
                                      _phoneNumberController,
                                      _locationController,
                                      imageUrl),
                            ),
                          ],
                        )),
                    const SizedBox(height: 30),
                    Column(
                      children: [
                        SizedBox(
                          height: tButtonHeight,
                          width: _isLoading ? tButtonHeight : double.infinity,
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : FilledButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      onButtonPressed();
                                      _focusNode1.unfocus();
                                      _focusNode2.unfocus();
                                      _focusNode3.unfocus();
                                    }
                                  },
                                  child: Text(
                                    "Proceed".toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            )),
      )),
    );
  }
}