import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/ui/screens/user_side/home/view_models/home_view_model.dart';
import 'package:queue_station_app/ui/screens/user_side/home/widgets/restaurant_joined_tile.dart';
import 'package:queue_station_app/ui/screens/user_side/home/widgets/restaurant_tile.dart';
import 'package:queue_station_app/ui/widgets/search_widget.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();
    final restaurants = viewModel.filteredRestaurants;

    return RefreshIndicator(
      onRefresh: viewModel.refresh,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              spacing: 7,
              children: [
                Expanded(
                  child: SearchWidget<Restaurant>(
                    filterLogic: (String search) {
                      viewModel.searchRestaurants(search);
                      return viewModel.restaurants
                          .map((e) => RestaurantTile(rest: e))
                          .toList();
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.notifications_outlined, color: Colors.black),
                ),
              ],
            ),

            SizedBox(
              height: 200,
              child: CarouselView.weighted(
                scrollDirection: Axis.horizontal,
                itemSnapping: true,
                flexWeights: const <int>[10],
                children: [
                  Image.asset("assets/home_screen/MOMO.png", fit: BoxFit.cover),
                  Image.asset("assets/home_screen/MOMO.png", fit: BoxFit.cover),
                  Image.asset("assets/home_screen/MOMO.png", fit: BoxFit.cover),
                  Image.asset("assets/home_screen/MOMO.png", fit: BoxFit.cover),
                ],
              ),
            ),

            Text(
              "Restaurants",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            Expanded(
              child: CustomScrollView(
                clipBehavior: Clip.antiAlias,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  if (viewModel.shouldShowJoinedTile)
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(8, 2, 8, 10),
                      sliver: SliverToBoxAdapter(
                        child: RestaurantJoinedTile(
                          queueEntry: viewModel.currentQueueEntry!,
                          restaurant: viewModel.currentRestaurant!,
                        ),
                      ),
                    ),

                  if (restaurants.isEmpty && !viewModel.isLoading)
                    SliverFillRemaining(
                      child: Center(child: Text('No restaurants found')),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 2,
                      ),
                      sliver: SliverList.separated(
                        itemCount: restaurants.length,
                        itemBuilder: (context, index) {
                          return RestaurantTile(rest: restaurants[index]);
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 10),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


  

