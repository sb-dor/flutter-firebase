import 'package:flutter/material.dart';
import 'package:flutter_firebase/core/firebase_helpers/firebase_analytics_helper/firebase_analytics_helper.dart';
import 'package:flutter_firebase/core/getit/getit_init.dart';

class FirebaseAnalyticsPage extends StatefulWidget {
  const FirebaseAnalyticsPage({super.key});

  @override
  State<FirebaseAnalyticsPage> createState() => _FirebaseAnalyticsPageState();
}

class _FirebaseAnalyticsPageState extends State<FirebaseAnalyticsPage> {
  late final FirebaseAnalyticsHelper _analyticsHelper;

  @override
  void initState() {
    super.initState();
    _analyticsHelper = getit<FirebaseAnalyticsHelper>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            expandedHeight: 200,
            stretch: true,
            backgroundColor: Colors.amber,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("Firebase analytics"),
              collapseMode: CollapseMode.pin,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            sliver: SliverMainAxisGroup(
              slivers: [
                SliverToBoxAdapter(
                  child: ElevatedButton(
                    onPressed: () async {
                      await _analyticsHelper.analyticsLogEvent(
                        logEvent: "select_content",
                        parameters: {
                          "content_type": "image",
                          "item_id": 1,
                        },
                      );
                    },
                    child: const Text("Analytics Log Event"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
