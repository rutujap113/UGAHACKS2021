import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventrack/services/restaurant_service.dart';
import 'package:inventrack/viewmodels/site_viewModel.dart';

class SitesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    RestaurantService restaurantService = new RestaurantService();
    SiteViewModel siteViewModel = new SiteViewModel();
    siteViewModel.get_sites_list();
    restaurantService.request_site_by_id();
    return Scaffold();
  }
}
