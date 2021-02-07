import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventrack/config/size_config.dart';

class StoreDetails extends StatefulWidget {
  String name;
  StoreDetails({Key key, this.name}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StoreDetailsState();
}

class _StoreDetailsState extends State<StoreDetails> {
  double _width;
  double _height;
  bool loadedFlag = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    int kDefaultPaddin = 50;
    _height = SizeConfig.screenHeight;
    _width = SizeConfig.screenWidth;

    // TODO: implement build
    return Scaffold(
      // each product have a color
      backgroundColor: Color(0xFF3D82AE),
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: _height,
              child: Stack(
                children: <Widget>[
                  Container(
                    width: _width,
                    margin: EdgeInsets.only(top: _height * 0.1),
                    padding: EdgeInsets.only(
                      top: _height * 0.08,
                      left: 20,
                      right: 20,
                    ),
                    // height: 500,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        Description(
                          description: "See how things are in the store",
                        ),
                        SizedBox(height: kDefaultPaddin / 2),
                        SizedBox(height: kDefaultPaddin / 2),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      widget.name,
                      style: TextStyle(
                          fontSize: this._width * .10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFF3D82AE),
      elevation: 0,
      title: Text("Store Details"),
    );
  }
}

class Description extends StatelessWidget {
  const Description({
    Key key,
    @required this.description,
  }) : super(key: key);

  final String description;
  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      style: TextStyle(fontSize: 20),
    );
  }
}
