import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:theme_looks/Screen/developer_info.dart';
import 'package:theme_looks/Screen/product_details.dart';
import 'package:theme_looks/Screen/upload_screen.dart';
import 'package:theme_looks/functions/custom_size.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:theme_looks/model/product_model.dart';
import 'package:theme_looks/providers/firebase_provider.dart';
import 'package:theme_looks/variables/constants.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({Key? key, this.context}) : super(key: key);

  final BuildContext? context;

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  TextEditingController searchController = TextEditingController();

  final FirebaseProvider fProvider = FirebaseProvider();
  int _itemCount = 100;

  void _onRefresh() async {
    _itemCount = 100;
    await fProvider.getProducts();
    setState(() {});
    _refreshController.refreshCompleted();
    customInit(fProvider);
  }

  void _onLoading() async {
    _itemCount = _itemCount + 100;
    debugPrint('Item: $_itemCount');
    await fProvider.getProducts();
    if (mounted) {
      setState(() {});
    }
    _refreshController.loadComplete();
    setState(() {
      _viewProductList = fProvider.productList;
    });
  }

  int counter = 0;

  List<ProductModel> _viewProductList = [];
  List<ProductModel> _ProductList = [];
  customInit(FirebaseProvider firebaseProvider) async {
    setState(() {
      counter++;
    });
    if (firebaseProvider.productList.isEmpty) {
      await firebaseProvider.getProducts().then((value) {
        setState(() {
          _ProductList = firebaseProvider.productList;
        });
      });
      setState(() {
        _viewProductList = _ProductList;
      });
    } else {
      setState(() {
        _ProductList = firebaseProvider.productList;
        _viewProductList = _ProductList;
      });
    }
  }

  void onSearch(String item) {
    setState(() {
      _viewProductList = _ProductList.where((element) => (element.productTitle!
          .toLowerCase()
          .contains(item.toLowerCase()))).toList();
    });
    setState(() {
      //  _viewProductList = _searchProductList;
    });
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseProvider firebaseProvider =
        Provider.of<FirebaseProvider>(context);
    if (counter == 0) {
      customInit(firebaseProvider);
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            setState(() {
              if (_scaffoldKey.currentState!.isDrawerOpen == false) {
                _scaffoldKey.currentState!.openDrawer();
              } else if (_scaffoldKey.currentState!.isDrawerOpen == true) {
                Navigator.pop(context);
              }
            });
          },
          icon: _scaffoldKey.currentState != null
              ? _scaffoldKey.currentState!.isDrawerOpen == false
                  ? const Icon(Icons.menu_outlined)
                  : const Icon(Icons.arrow_back)
              : const Icon(Icons.menu_outlined),
        ),
        title: customInputField(
            "Search", searchController, context, 1, firebaseProvider),
        actions: const [],
      ),
      body: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          key: _scaffoldKey,
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: screenSize(context, .03),
                ),
                Container(
                  height: screenSize(context, .3),
                  width: screenSize(context, .3),
                  decoration: const BoxDecoration(
                    color: Colors.white70,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset("assets/theme_looks.png"),
                ),
                SizedBox(height: screenSize(context, .05)),
                Center(
                  child: Text(
                    'Theme looks',
                    style: TextStyle(
                      fontSize: screenSize(context, .06),
                    ),
                  ),
                ),
                const Divider(),
                InkWell(
                  onTap: () async {
                    await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ProductUploadScreen()))
                        .then((value) => Navigator.pop(context));
                  },
                  child: const ListTile(
                    title: Text('Upload Product'),
                    leading:
                        Icon(Icons.cloud_upload_outlined, color: Colors.grey),
                  ),
                ),
                const Divider(),
                InkWell(
                  onTap: () async {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const DeveloperInfo()))
                        .then((value) => Navigator.pop(context));
                  },
                  child: const ListTile(
                    title: Text('Developer Info'),
                    leading: Icon(Icons.info_outlined, color: Colors.grey),
                  ),
                ),
                const Divider(),
              ],
            ),
          ),
          body: _bodyUI(context, firebaseProvider),
        ),
      ),
    );
  }

  Widget _bodyUI(BuildContext context, FirebaseProvider firebaseProvider) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: const WaterDropHeader(waterDropColor: Colors.green),
      footer: CustomFooter(
        builder: (context, mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = const Text("pull up load");
          } else if (mode == LoadStatus.loading) {
            body = const CircularProgressIndicator();
          } else if (mode == LoadStatus.failed) {
            body = const Text("Load Failed!Click retry!");
          } else if (mode == LoadStatus.canLoading) {
            body = const Text("release to load more");
          } else {
            body = const Text("No more Data");
          }
          return SizedBox(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: firebaseProvider.productList.isEmpty
          ? const Center(child: Text("You haven't added any products"))
          : ListView(
              physics: const ClampingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              shrinkWrap: true,
              children: [
                //SizedBox(height: getProportionateScreenWidth(context,10)),

                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 3 / 5,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      shrinkWrap: true,
                      itemCount: _viewProductList.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductDetailsPage(
                                          title: _viewProductList[index]
                                              .productTitle,
                                          description: _viewProductList[index]
                                              .description,
                                          bl_price: _viewProductList[index]
                                              .blackLargePrice,
                                          wl_price: _viewProductList[index]
                                              .whiteLargePrice,
                                          bs_price: _viewProductList[index]
                                              .blackSmallPrice,
                                          ws_price: _viewProductList[index]
                                              .whiteSmallPrice,
                                          imageUrl:
                                              _viewProductList[index].image,
                                        )));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF19B52B).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        Container(
                                          height: screenSize(context, .35),
                                          decoration: BoxDecoration(
                                            color: kSecondaryColor
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: _viewProductList[index]
                                                .image![0]!,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                            progressIndicatorBuilder: (context,
                                                    url, downloadProgress) =>
                                                Center(
                                              child: CircularProgressIndicator(
                                                  value: downloadProgress
                                                      .progress),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Text(
                                        _viewProductList[index].productTitle!,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize:
                                                screenSize(context, .035)),
                                        maxLines: 2,
                                      ),
                                    ),
                                    Text(
                                      "\৳: ${_viewProductList[index].blackLargePrice!} - ${firebaseProvider.productList[index].whiteSmallPrice!} ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: screenSize(context, .04)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                //SizedBox(width: getProportionateScreenWidth(20)),
              ],
            ),
    );
  }

  Widget customInputField(
      String labelText,
      TextEditingController textEditingController,
      BuildContext context,
      int maxLine,
      FirebaseProvider firebaseProvider) {
    return TextFormField(
        controller: textEditingController,
        cursorColor: Colors.black,
        autofocus: false,
        maxLines: maxLine,
        decoration: InputDecoration(
          suffixIcon: const Icon(
            Icons.search,
            color: Colors.white,
          ),
          contentPadding: EdgeInsets.symmetric(
              horizontal: screenSize(context, .03),
              vertical: screenSize(context, .02)),
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.white),
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
        onChanged: (value) {
          print(value);
          onSearch(value);
        });
  }
}
