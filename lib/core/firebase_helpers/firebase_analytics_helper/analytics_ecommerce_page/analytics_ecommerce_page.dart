import 'package:flutter/material.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_analytics_helper/analytics_product/analytics_product.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_analytics_helper/firebase_analytics_helper.dart';
import 'package:flutter_firebase/core/getit/getit_init.dart';

class AnalyticsEcommercePage extends StatefulWidget {
  const AnalyticsEcommercePage({super.key});

  @override
  State<AnalyticsEcommercePage> createState() => _AnalyticsEcommercePageState();
}

class _AnalyticsEcommercePageState extends State<AnalyticsEcommercePage> {
  final ScrollController scrollController = ScrollController();

  List<AnalyticsProduct> products = [];

  bool slideText = false;

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    products = AnalyticsProductData.data;
    scrollController.addListener(funcForSlideText);
  }

  void funcForSlideText() {
    debugPrint("scroll offset: ${scrollController.offset}");
    if (_isAppBarExpanded) {
      slideText = false;
    } else {
      slideText = true;
    }
    setState(() {});
  }

  bool get _isAppBarExpanded {
    return scrollController.hasClients && scrollController.offset < (200 - kToolbarHeight);
  }

  @override
  void dispose() {
    scrollController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        controller: scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            stretch: true,
            pinned: true,
            scrolledUnderElevation: 0,
            leadingWidth: slideText ? null : 0,
            leading: AnimatedOpacity(
              opacity: slideText ? 1 : 0,
              duration: const Duration(milliseconds: 360),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.arrow_back,
                ),
              ),
            ) ,
            centerTitle: false,
            backgroundColor: Colors.amber,
            onStretchTrigger: () async {
              debugPrint("scratching");
            },
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              titlePadding: const EdgeInsets.only(left: 10),
              title: AnimatedSlide(
                offset: slideText ? const Offset(0.2, 0) : Offset.zero,
                duration: const Duration(milliseconds: 250),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Analytics e-commerce page ",
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
              expandedTitleScale: 1.5,
              centerTitle: false,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final item = products[index];
                return ListTile(
                  onTap: () async {
                    await showDialog(
                      context: context,
                      builder: (context) =>
                          _AnalyticsProductAbout(
                            analyticsProduct: item,
                          ),
                    );
                  },
                  title: Text("Name: ${item.name}"),
                  subtitle: Text("Price: ${item.price}"),
                );
              },
              childCount: products.length,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnalyticsProductAbout extends StatefulWidget {
  final AnalyticsProduct analyticsProduct;

  const _AnalyticsProductAbout({
    super.key,
    required this.analyticsProduct,
  });

  @override
  State<_AnalyticsProductAbout> createState() => _AnalyticsProductAboutState();
}

class _AnalyticsProductAboutState extends State<_AnalyticsProductAbout> {
  @override
  void initState() {
    super.initState();
    getit<FirebaseAnalyticsHelper>().analyticsLogViewItemOwnEvent(
      product: widget.analyticsProduct,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Name: ${widget.analyticsProduct.name}"),
      content: Text("Price: ${widget.analyticsProduct.price}"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close"),
        ),
      ],
    );
  }
}
