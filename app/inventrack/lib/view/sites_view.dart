import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventrack/services/restaurant_service.dart';

class SitesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    RestaurantService restaurantService = new RestaurantService();
    restaurantService.request_site_by_id();
    return Scaffold();
  }
}
