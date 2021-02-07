import 'package:inventrack/model/site_model.dart';
import 'package:inventrack/services/restaurant_service.dart';

class SiteViewModel {
  RestaurantService _restaurantService = new RestaurantService();

  List<SiteModel> get_sites_list() {
    List<SiteModel> list = new List();
    _restaurantService.request_nearby_sites().then((value) {
      for (int i = 0; i < value['sites'].length; i++) {
        SiteModel siteModel = new SiteModel();
        siteModel.siteName = value['sites'][i]['siteName'];
        siteModel.address = value['sites'][i]['address']['city'];
        siteModel.contact = value['sites'][i]['contact'].toString();
        siteModel.description = value['sites'][i]['description'];
        siteModel.status = value['sites'][i]['status'];
        list.add(siteModel);
      }
    });

    return list;
  }
}
