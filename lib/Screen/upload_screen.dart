import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:theme_looks/Screen/product_list_screen.dart';
import 'package:theme_looks/functions/custom_size.dart';
import 'package:theme_looks/functions/custom_toast.dart';

import 'package:theme_looks/providers/firebase_provider.dart';
import 'package:theme_looks/variables/constants.dart';
import 'package:uuid/uuid.dart';

class ProductUploadScreen extends StatefulWidget {
  const ProductUploadScreen({Key? key}) : super(key: key);

  @override
  _ProductUploadScreenState createState() => _ProductUploadScreenState();
}

class _ProductUploadScreenState extends State<ProductUploadScreen> {
  TextEditingController blackLargePriceController = TextEditingController();
  TextEditingController blackSmallPriceController = TextEditingController();
  TextEditingController whiteSmallPriceController = TextEditingController();
  TextEditingController whiteLargePriceController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
  TextEditingController titleTextController = TextEditingController();
  List imageUrl = [];
  List<XFile>? _imageFileList = [];
  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : [value];
  }

  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();
  int selectedImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final FirebaseProvider firebaseProvider =
        Provider.of<FirebaseProvider>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Product Upload"),
          centerTitle: true,
          actions: const [],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                      width: screenSize(context, 1),
                      height: screenSize(context, .6),
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                      ),
                      child: _imageFileList!.isEmpty
                          ? Image.asset('assets/theme_looks.png')
                          : Image.file(
                              File(_imageFileList![selectedImageIndex].path))),
                  IconButton(
                    onPressed: () async {
                      FirebaseStorage fs = FirebaseStorage.instance;
                      final pickedFileList = await _picker.pickMultiImage();
                      setState(() {
                        _imageFileList = pickedFileList;
                      });

                      for (var image in _imageFileList!) {
                        var snapshot = await fs
                            .ref()
                            .child('ProductImage')
                            .child(image.name)
                            .putFile(File(image.path));
                        String downloadUrl =
                            await snapshot.ref.getDownloadURL();
                        setState(() {
                          imageUrl.add(downloadUrl);
                        });
                      }

                      debugPrint("${imageUrl.length}");
                    },
                    icon: Icon(
                      Icons.file_upload,
                      size: screenSize(context, .1),
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      child: SizedBox(
                        width: screenSize(context, 1),
                        height: screenSize(context, .15),
                        child: ListView.builder(
                          itemCount: _imageFileList!.isEmpty
                              ? 0
                              : _imageFileList!.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectedImageIndex = index;
                                });
                              },
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        screenSize(context, .02))),
                                color: Colors.white,
                                child: SizedBox(
                                    height: screenSize(context, .15),
                                    width: screenSize(context, .15),
                                    child: _imageFileList!.isEmpty
                                        ? Image.asset('assets/theme_looks.png')
                                        : Image.file(
                                            File(_imageFileList![index].path))),
                              ),
                            );
                          },
                        ),
                      ))
                ],
              ),
              SizedBox(height: screenSize(context, .02)),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextFormField(
                  controller: titleTextController,
                  cursorColor: Colors.black,
                  autofocus: false,
                  maxLines: 1,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: screenSize(context, .03),
                        vertical: screenSize(context, .02)),
                    labelText: "Title",
                    border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(screenSize(context, .02)),
                        borderSide: const BorderSide(
                            color: Colors.lightGreen,
                            style: BorderStyle.solid)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(screenSize(context, .02)),
                        borderSide: const BorderSide(color: Colors.lightGreen)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(screenSize(context, .02)),
                        borderSide: const BorderSide(color: Colors.lightGreen)),
                    disabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(screenSize(context, .02)),
                        borderSide: const BorderSide(color: Colors.lightGreen)),
                  ),
                ),
              ),
              SizedBox(height: screenSize(context, .02)),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextFormField(
                  controller: descriptionTextController,
                  cursorColor: Colors.black,
                  autofocus: false,
                  maxLines: 5,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: screenSize(context, .03),
                        vertical: screenSize(context, .02)),
                    labelText: "Description",
                    border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(screenSize(context, .02)),
                        borderSide: const BorderSide(
                            color: Colors.lightGreen,
                            style: BorderStyle.solid)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(screenSize(context, .02)),
                        borderSide: const BorderSide(color: Colors.lightGreen)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(screenSize(context, .02)),
                        borderSide: const BorderSide(color: Colors.lightGreen)),
                    disabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(screenSize(context, .02)),
                        borderSide: const BorderSide(color: Colors.lightGreen)),
                  ),
                ),
              ),
              SizedBox(height: screenSize(context, .03)),
              Container(
                width: screenSize(context, 1),
                color: Colors.green,
                child: Padding(
                  padding: EdgeInsets.all(screenSize(context, .010)),
                  child: Center(
                    child: Text(
                      "Large",
                      style: TextStyle(
                          fontSize: screenSize(context, .05),
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          border: Border.all(color: kPrimaryColor),
                          color: Colors.white,
                          shape: BoxShape.rectangle),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Colors.black,
                              shape: BoxShape.rectangle),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenSize(context, .03),
                    ),
                    Text(
                      "Black",
                      style: TextStyle(
                          fontSize: screenSize(context, .04),
                          color: Colors.black),
                    ),
                    SizedBox(
                      width: screenSize(context, .07),
                    ),
                    customInputField("Large Black Price",
                        blackLargePriceController, context, 1),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          border: Border.all(color: kPrimaryColor),
                          color: Colors.white,
                          shape: BoxShape.rectangle),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Colors.white,
                              shape: BoxShape.rectangle),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenSize(context, .03),
                    ),
                    Text(
                      "White",
                      style: TextStyle(
                          fontSize: screenSize(context, .04),
                          color: Colors.black),
                    ),
                    SizedBox(
                      width: screenSize(context, .07),
                    ),
                    customInputField("Large White Price",
                        whiteLargePriceController, context, 1),
                  ],
                ),
              ),
              Container(
                width: screenSize(context, 1),
                color: Colors.green,
                child: Padding(
                  padding: EdgeInsets.all(screenSize(context, .010)),
                  child: Center(
                    child: Text(
                      "Small",
                      style: TextStyle(
                          fontSize: screenSize(context, .05),
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          border: Border.all(color: kPrimaryColor),
                          color: Colors.white,
                          shape: BoxShape.rectangle),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Colors.black,
                              shape: BoxShape.rectangle),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenSize(context, .03),
                    ),
                    Text(
                      "Black",
                      style: TextStyle(
                          fontSize: screenSize(context, .05),
                          color: Colors.black),
                    ),
                    SizedBox(
                      width: screenSize(context, .07),
                    ),
                    customInputField("Small Black Price",
                        blackSmallPriceController, context, 1),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          border: Border.all(color: kPrimaryColor),
                          color: Colors.white,
                          shape: BoxShape.rectangle),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Colors.white,
                              shape: BoxShape.rectangle),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenSize(context, .03),
                    ),
                    Text(
                      "White",
                      style: TextStyle(
                          fontSize: screenSize(context, .05),
                          color: Colors.black),
                    ),
                    SizedBox(
                      width: screenSize(context, .07),
                    ),
                    customInputField("Small White Price",
                        whiteSmallPriceController, context, 1),
                  ],
                ),
              ),
              SizedBox(
                height: screenSize(context, .07),
              ),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        String uuid = const Uuid().v4();

                        if (imageUrl.isNotEmpty) {
                          setState(() {
                            _isLoading = true;
                          });
                          _submitData(firebaseProvider, uuid).then((value) {
                            setState(() {
                              _isLoading = false;
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const ProductListPage()));
                          });
                        } else {
                          showToast('Product Photo is Required');
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenSize(context, .2)),
                        child: const Text("Upload"),
                      )),
              SizedBox(
                height: screenSize(context, .05),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitData(
      FirebaseProvider firebaseProvider, String uuid) async {
    DateTime date = DateTime.now();
    String dateData = '${date.month}-${date.day}-${date.year}';
    setState(() => _isLoading = true);
    Map<String, dynamic> map = {
      'date': dateData,
      'id': uuid,
      'image': imageUrl,
      'productTitle': titleTextController.text,
      'blackLargePrice': blackLargePriceController.text,
      'whiteLargePrice': whiteLargePriceController.text,
      'blackSmallPrice': blackSmallPriceController.text,
      'whiteSmallPrice': whiteSmallPriceController.text,
      'description': descriptionTextController.text,
    };

    await firebaseProvider.addProductData(map).then((value) async {
      if (value) {
        showToast('Product Uploaded Successfully');
        _emptyFildCreator();
        _isLoading = false;
      } else {
        setState(() => _isLoading = false);
        showToast('Failed');
      }
    });
  }

  Widget customInputField(
      String labelText,
      TextEditingController textEditingController,
      BuildContext context,
      int maxLine) {
    return Expanded(
      child: TextFormField(
        controller: textEditingController,
        cursorColor: Colors.black,
        autofocus: false,
        maxLines: maxLine,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
              horizontal: screenSize(context, .03),
              vertical: screenSize(context, .02)),
          labelText: labelText,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(screenSize(context, .02)),
              borderSide: const BorderSide(
                  color: Colors.lightGreen, style: BorderStyle.solid)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(screenSize(context, .02)),
              borderSide: const BorderSide(color: Colors.lightGreen)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(screenSize(context, .02)),
              borderSide: const BorderSide(color: Colors.lightGreen)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(screenSize(context, .02)),
              borderSide: const BorderSide(color: Colors.lightGreen)),
        ),
      ),
    );
  }

  _emptyFildCreator() {
    blackLargePriceController.clear();
    descriptionTextController.clear();
    whiteLargePriceController.clear();
    blackSmallPriceController.clear();
    whiteSmallPriceController.clear();
    _imageFileList!.clear();
    imageUrl.clear();
  }
}
