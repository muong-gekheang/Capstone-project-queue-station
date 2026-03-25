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
                      return viewModel.restaurants.map((rest) {
                        final waitingCount =
                            viewModel.peopleWaitingPerRestaurant[rest.id] ?? 0;

                        return RestaurantTile(
                          rest: rest,
                          peopleWaiting: waitingCount,
                        );
                      }).toList();
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: Colors.black,
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 200,
              child: CarouselView.weighted(
                scrollDirection: Axis.horizontal,
                itemSnapping: true,
                flexWeights: const <int>[10],
                children: const [
                  Image(
                    image: AssetImage("assets/home_screen/MOMO.png"),
                    fit: BoxFit.cover,
                  ),
                  Image(
                    image: AssetImage("assets/home_screen/MOMO.png"),
                    fit: BoxFit.cover,
                  ),
                  Image(
                    image: AssetImage("assets/home_screen/MOMO.png"),
                    fit: BoxFit.cover,
                  ),
                  Image(
                    image: AssetImage("assets/home_screen/MOMO.png"),
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),

            const Text(
              "Restaurants",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            Expanded(
              child: CustomScrollView(
                clipBehavior: Clip.antiAlias,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Loading state
                  if (viewModel.isLoading)
                    const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  // Error state
                  else if (viewModel.errorMessage != null)
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              viewModel.errorMessage!,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => viewModel.refresh(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else ...[
                    // Joined tile
                    if (viewModel.shouldShowJoinedTile &&
                        viewModel.currentRestaurant != null)
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(8, 2, 8, 10),
                        sliver: SliverToBoxAdapter(
                          child: RestaurantJoinedTile(
                            queueEntry: viewModel.currentQueueEntry!,
                            restaurant: viewModel.currentRestaurant!,
                            peopleWaiting:
                                viewModel.peopleWaitingPerRestaurant[viewModel
                                    .currentRestaurant!
                                    .id] ??
                                0,
                          ),
                        ),
                      ),

                    // Restaurants list
                    if (restaurants.isEmpty)
                      const SliverFillRemaining(
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
                            final rest = restaurants[index];
                            final waitingCount =
                                viewModel.peopleWaitingPerRestaurant[rest.id] ??
                                0;

                            return RestaurantTile(
                              rest: rest,
                              peopleWaiting: waitingCount,
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
