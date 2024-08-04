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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            expandedHeight: 150,
            stretch: true,
            pinned: true,
            scrolledUnderElevation: 0,
            // leadingWidth: 0,
            // leading: IconButton(onPressed: (){}, icon: Icon(Icons.back_hand)),
            centerTitle: false,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              titlePadding: EdgeInsets.only(left: 10),
              title: Text("Analytics e-commerce page"),
              expandedTitleScale: 1.5,
              centerTitle: false,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final item = AnalyticsProductData.data[index];
                return ListTile(
                  onTap: () async {
                    await showDialog(
                      context: context,
                      builder: (context) => _AnalyticsProductAbout(
                        analyticsProduct: item,
                      ),
                    );
                  },
                  title: Text("Name: ${item.name}"),
                  subtitle: Text("Price: ${item.price}"),
                );
              },
              childCount: AnalyticsProductData.data.length,
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
          child: Text("Close"),
        ),
      ],
    );
  }
}
