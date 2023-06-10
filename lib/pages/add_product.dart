import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:veterna_poultry_admin/widget/button_blue_radius_25.dart';
import 'package:veterna_poultry_admin/widget/show_snackbar.dart';

import '../db/database_methods.dart';
import '../utils/dimen.dart';
import '../utils/my_colors.dart';
import '../utils/validation_input.dart';
import '../widget/input_text.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController _controllerName = TextEditingController();

  final TextEditingController _controllerPrice = TextEditingController();
  File? imageFile;
  takePicture() async {
    ImagePicker picker = ImagePicker();

    await picker.pickImage(source: ImageSource.gallery, imageQuality: 25).then(
      (xFile) {
        if (xFile != null) {
          setState(() {
            imageFile = File(xFile.path);
          });
        }
      },
    );
  }

  sendToDB() async {
    String fileName = const Uuid().v1();
    String? imageUrl;
    try {
      var ref = FirebaseStorage.instance
          .ref()
          .child('content/images')
          .child("$fileName.jpg");
      if (imageFile != null) {
        await ref.putFile(imageFile!);
        imageUrl = await ref.getDownloadURL();
      }
      var sendData = {
        "img_path": imageUrl,
        "title": _controllerName.text,
        "price": int.parse(_controllerPrice.text),
      };
      await DatabaseMethod()
          .firestore
          .collection('products')
          .add(sendData)
          .then((value) {
        _controllerName.clear();
        _controllerPrice.clear();
        imageFile = null;
        Get.back();
        Get.back();
        ShowSnackbar.snackBarSuccess("Successfully add product");
      }).catchError((e) {
        Get.back();
        ShowSnackbar.snackBarError("Terjadi kesalahan menambah product");
      });
    } on FirebaseException catch (e) {
      ShowSnackbar.snackBarError(e.message.toString());
    }
  }

  bool validation() {
    return imageFile != null &&
        ValidationInput.validationInputNotEmpty(_controllerName.text) &&
        ValidationInput.validationInputNotEmpty(_controllerPrice.text);
  }

  void showErrorSnackbar() {
    if (_controllerName.text.isEmpty) {
      ShowSnackbar.snackBarError('Name is required');
    } else if (_controllerPrice.text.isEmpty) {
      ShowSnackbar.snackBarError('Price is required');
    } else if (imageFile == null) {
      ShowSnackbar.snackBarError('Please insert picture');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
        ),
        title: Text("Tambah Produk",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: const EdgeInsets.all(20),
                  height: 150,
                  width: Get.width,
                  //show captured image
                  child: imageFile == null
                      ? InkWell(
                          onTap: () => takePicture(),
                          child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                //ini buat custom warnanya sama rounded nya button
                                color: MyColors.bottomNavColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(Icons.photo_camera)),
                        )
                      : InkWell(
                          onTap: () {
                            takePicture();
                          },
                          child: Image.file(
                            File(imageFile!.path),
                            width: Get.width,
                            height: 300,
                          ),
                        )

                  //display captured image
                  ),
              SizedBox(
                height: Dimen(context).height * 0.03,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: InputText(
                    controller: _controllerName,
                    text: "Nama Produk *",
                    textInputType: TextInputType.name,
                    height: 55,
                    verticalCenter: false),
              ),
              SizedBox(
                height: Dimen(context).height * 0.03,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: InputText(
                  controller: _controllerPrice,
                  text: "Harga Produk *",
                  textInputType: TextInputType.number,
                  height: 55,
                  verticalCenter: false,
                ),
              ),
              SizedBox(height: Dimen(context).height * 0.05),
              Center(
                  child: ButtonBlueRadius25(
                      text: "Simpan",
                      onTap: () {
                        if (validation()) {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (_) {
                                return const Dialog(
                                  // The background colordire
                                  backgroundColor: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // The loading indicator
                                        CircularProgressIndicator(),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        // Some text
                                        Text('Loading...')
                                      ],
                                    ),
                                  ),
                                );
                              });
                          sendToDB();
                        } else {
                          showErrorSnackbar();
                        }
                      })),
            ],
          ),
        ),
      ),
    );
  }
}
