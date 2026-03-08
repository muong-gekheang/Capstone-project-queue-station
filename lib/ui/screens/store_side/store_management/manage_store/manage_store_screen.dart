import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/manage_store/view_model/manage_store_view_model.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/manage_store/widgets/manage_store_content.dart';

class ManageStoreScreen extends StatelessWidget {
  const ManageStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ManageStoreViewModel(),
      child: ManageStoreContent(),
    );
  }
}
