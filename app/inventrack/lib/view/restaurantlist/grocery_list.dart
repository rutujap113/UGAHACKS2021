import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventrack/config/size_config.dart';
import 'package:inventrack/model/site_model.dart';
import 'package:inventrack/viewmodels/site_viewModel.dart';

import 'grocery_card.dart';
import 'list_header.dart';

class GroceryStoreList extends StatefulWidget {
  GroceryStoreList({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GroceryStoreListState();
}

/// This class keeps track of the nearby grocery stores.
/// The Azure Maps Api is used to get the list of nearby grocery stores based on entered
/// location.
///
/// @author Aditya Varun Pratap
/// @version 1.0
class _GroceryStoreListState extends State<GroceryStoreList> {
  double _height;
  double _width;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    this._height = SizeConfig.screenHeight;
    this._width = SizeConfig.screenWidth;

    SiteViewModel _siteViewModel = new SiteViewModel();
    return Scaffold(
        appBar: AppBar(
          title: Center(
              child: Text(
            "InvenTrack",
            style: TextStyle(fontSize: _height * .05),
          )),
        ),
        body: FutureBuilder(
            future: _siteViewModel.getSiteList(),
            builder: (context, snapshot) {
              return Container(
                child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return GroceryCard(
                        address: snapshot.data[index].address,
                        contact: "Aditya Pratap",
                        description: snapshot.data[index].description,
                        name: snapshot.data[index].siteName,
                        status: snapshot.data[index].status,
                      );
                    }),
              );
            }));
  }
}
