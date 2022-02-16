import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro_nullsafety/carousel_pro_nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:theme_looks/functions/custom_size.dart';
import 'package:theme_looks/functions/custom_toast.dart';
import 'package:theme_looks/variables/constants.dart';

class ProductDetailsPage extends StatefulWidget {
  final String? title, description, bl_price, wl_price, bs_price, ws_price;
  List<dynamic>? imageUrl = [];
  ProductDetailsPage({
    Key? key,
    this.title,
    this.description,
    this.bl_price,
    this.wl_price,
    this.bs_price,
    this.ws_price,
    this.imageUrl,
  }) : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  static List<Widget>? imageSliders;
  int _depositRadioSelected = 1;
  String _radioVal = 'Black';

  List productSize = ["Large", "Small"];

  String? _size;
  int indx = 0;

  String? selectedPrice;
  @override
  void initState() {
    // TODO: implement initState

    selectedPrice = widget.bl_price!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Product Details"),
      ),
      body: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            children: [
              Center(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: screenSize(context, .02)),
                  child: SizedBox(
                    height: screenSize(context, .5),
                    width: screenSize(context, .95),
                    child: Carousel(
                        boxFit: BoxFit.none,
                        autoplay: true,
                        autoplayDuration: const Duration(seconds: 4),
                        animationCurve: Curves.fastOutSlowIn,
                        animationDuration: const Duration(milliseconds: 1000),
                        dotSize: 6.0,
                        dotIncreasedColor: Colors.green,
                        dotBgColor: Colors.transparent,
                        dotPosition: DotPosition.bottomCenter,
                        dotVerticalPadding: 10.0,
                        showIndicator: true,
                        indicatorBgPadding: 7.0,
                        images: bannerSlider(context)),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenSize(context, .02)),
                    child: Text(
                      widget.title!,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: screenSize(context, .06)),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(
                          screenSize(context, 0.02),
                        ),
                        child: Text(
                          'Price: ৳ $selectedPrice',
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: screenSize(context, .045)),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),

                  ///product size, color
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      productSize.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenSize(context, .02)),
                              child: Container(
                                width: screenSize(context, .25),
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenSize(context, .01),
                                  vertical: screenSize(context, .01),
                                ),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: kPrimaryColor, width: 1),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5))),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    isDense: true,
                                    isExpanded: true,
                                    value: _size,
                                    hint: Text('Size',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'OpenSans',
                                          fontSize: screenSize(context, .04),
                                        )),
                                    items: productSize.map((sizes) {
                                      return DropdownMenuItem(
                                        child: Text(sizes,
                                            style: TextStyle(
                                                color: Colors.grey[900],
                                                fontSize:
                                                    screenSize(context, .04),
                                                fontFamily: 'OpenSans')),
                                        value: sizes.toString(),
                                      );
                                    }).toList(),
                                    onChanged: (newVal) {
                                      setState(() {
                                        _size = newVal as String;
                                      });
                                      if (_size == "Large" &&
                                          _radioVal == "Black") {
                                        setState(() {
                                          selectedPrice = widget.bl_price;
                                        });
                                      }
                                      if (_size == "Large" &&
                                          _radioVal == "White") {
                                        setState(() {
                                          selectedPrice = widget.wl_price;
                                        });
                                      }
                                      if (_size == "Small" &&
                                          _radioVal == "White") {
                                        setState(() {
                                          selectedPrice = widget.ws_price;
                                        });
                                      }
                                      if (_size == "Small" &&
                                          _radioVal == "Black") {
                                        setState(() {
                                          selectedPrice = widget.bs_price;
                                        });
                                      }
                                    },
                                    dropdownColor: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenSize(context, .02)),
                        child: Row(
                          children: [
                            Text('Color: ',
                                style: TextStyle(
                                    color: Colors.grey[900],
                                    fontSize: screenSize(context, .04),
                                    fontFamily: 'OpenSans')),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Radio(
                                      value: 1,
                                      groupValue: _depositRadioSelected,
                                      activeColor: Colors.pink,
                                      onChanged: (value) {
                                        setState(() {
                                          _depositRadioSelected = value as int;
                                          _radioVal = 'Black';
                                        });
                                        if (_size == "Large" &&
                                            _radioVal == "Black") {
                                          setState(() {
                                            selectedPrice = widget.bl_price;
                                          });
                                        }
                                        if (_size == "Small" &&
                                            _radioVal == "Black") {
                                          setState(() {
                                            selectedPrice = widget.bs_price;
                                          });
                                        }
                                      },
                                    ),
                                    const Text(
                                      'Black',
                                      // scale: 40,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Radio(
                                      value: 2,
                                      groupValue: _depositRadioSelected,
                                      activeColor: Colors.yellowAccent.shade700,
                                      onChanged: (value) {
                                        setState(() {
                                          _depositRadioSelected = value as int;
                                          _radioVal = 'White';
                                        });
                                        if (_size == "Large" &&
                                            _radioVal == "White") {
                                          setState(() {
                                            selectedPrice = widget.wl_price;
                                          });
                                        }
                                        if (_size == "Small" &&
                                            _radioVal == "White") {
                                          setState(() {
                                            selectedPrice = widget.ws_price;
                                          });
                                        }
                                      },
                                    ),
                                    const Text(
                                      'White',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: screenSize(context, .02)),

                  Padding(
                    padding: EdgeInsets.all(
                      screenSize(context, .02),
                    ),
                    child: Text(
                      widget.description!,
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: screenSize(context, .04)),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                  onPressed: () {
                    showToast("Your task has been completed");
                  },
                  child: const Text("Add To Cart")))
        ],
      ),
    ));
  }

  List<Widget> bannerSlider(BuildContext context) {
    return imageSliders = widget.imageUrl!
        .map<dynamic>((item) => SizedBox(
              height: MediaQuery.of(context).size.height * .06,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                child: item == null
                    ? Container()
                    : Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6)),
                        child: CachedNetworkImage(
                          imageUrl: item,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
              ),
            ))
        .cast<Widget>()
        .toList();
  }
}
