import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/services/store/menu_service.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/menu_management/view_model/menu_management_view_model.dart';
import 'package:queue_station_app/ui/theme/app_theme.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/edit_menu/edit_menu_screen.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/menu_management/widgets/menu_detail.dart';
import 'package:queue_station_app/ui/widgets/delete-menu-pop-up.dart';

class MenuCardWidget extends StatefulWidget {
  final MenuItem menu;
  final VoidCallback? onDelete;
  const MenuCardWidget({super.key, required this.menu, this.onDelete});

  @override
  State<MenuCardWidget> createState() => _MenuCardWidgetState();
}

class _MenuCardWidgetState extends State<MenuCardWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider.value(
              value: context.read<MenuManagementViewModel>(),
              child: Provider.value(
                value: context.read<MenuService>(),
                child: MenuDetail(menu: widget.menu),
              ),
            ),
          ),
        ).then((_) {
          setState(() {
            print('menu Availability ${widget.menu.isAvailable}');
          });
        });
      },
      child: Stack(
        children: [
          Card(
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.naturalBlack.withAlpha(64),
                    offset: Offset(0, 0),
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
                ],
              ),
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          image:  (widget.menu.image != null &&
                                  widget.menu.image!.isNotEmpty)
                              ? DecorationImage(
                                  image: NetworkImage(widget.menu.image!),
                                )
                              : DecorationImage(
                                  image: AssetImage(
                                    'assets/images/default_menu_profile.jpg',
                                  ),
                                ), // - will implement later
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.menu.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                widget.menu.category.name,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                "•",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                "\$${widget.menu.minPrice}",
                                style: TextStyle(
                                  color: const Color.fromRGBO(255, 104, 53, 1),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            widget.menu.isAvailable
                                ? "Available"
                                : "Not Available",
                            style: TextStyle(
                              color: widget.menu.isAvailable
                                  ? Color.fromRGBO(16, 185, 129, 1)
                                  : Color.fromRGBO(230, 57, 70, 1),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          var vm = context.read<MenuManagementViewModel>();
                          MenuItem filledMenuDetails = await vm
                              .getMenuitemDetails(widget.menu);
                          if (context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChangeNotifierProvider.value(
                                  value: context
                                      .read<MenuManagementViewModel>(),
                                  child: EditMenuScreen(
                                    existingMenu: filledMenuDetails,
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        icon: Icon(Icons.create_outlined),
                        color: Color.fromRGBO(13, 71, 161, 1),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                      SizedBox(width: 5),
                      IconButton(
                        onPressed: () async {
                          final deleteConfirmation = await showDialog<bool>(
                            context: context,
                            builder: (context) => DeleteMenuPopUp(
                              message: 'Are you sure you want to delete ',
                              menu: widget.menu,
                            ),
                          );
                          if (deleteConfirmation == true &&
                              widget.onDelete != null) {
                            widget.onDelete!();
                          }
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Color.fromRGBO(230, 57, 70, 1),
                        ),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (!widget.menu.isAvailable)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppTheme.naturalBlack.withAlpha(127),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
