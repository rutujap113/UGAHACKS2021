import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventrack/config/size_config.dart';

class GroceryCard extends StatelessWidget {
  double _width;
  double _height;
  String name;
  String contact;
  String address;
  String description;
  String status;

  GroceryCard(
      {this.contact, this.name, this.description, this.address, this.status});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    this._height = SizeConfig.screenHeight;
    this._width = SizeConfig.screenWidth;
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            _width * .03, _height * .02, _width * .03, _width * .005),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 1.0,
                spreadRadius: 0.0,
                offset: Offset(2.0, 2.0), // shadow direction: bottom right
              )
            ],
          ),
          height: _height * .25,
          width: _width * .70,
          child: Container(
            child: Stack(
              children: [
                ClipRect(
                  child: Container(
                    color: Color.fromARGB(200, 98, 207, 87),
                    height: 80,
                  ),
                ),
                _showGroceryStoreName(name),
                _showOccupancyAndAddress(20, address)
              ],
            ),
          ),
        ),
      ),
      onTap: () => Navigator.of(context)
          .pushNamed('/details', arguments: {'name': name}),
    );
  }

  Widget _showGroceryStoreName(String name) {
    return Padding(
      padding: EdgeInsets.only(top: .04 * _height),
      child: Align(
        alignment: Alignment.topCenter,
        child: Text(
          name,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: _width * .08),
        ),
      ),
    );
  }

  Widget _showOccupancyAndAddress(int occupancy, String address) {
    return Padding(
      padding: EdgeInsets.only(top: .11 * _height, left: .02 * _width),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            FittedBox(
              child: Text(
                "Address: " + address,
                maxLines: 1,
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w300,
                    fontSize: _width * .06),
              ),
            ),
            Text(
              "Description " + description.toString(),
              maxLines: 1,
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w300,
                  fontSize: _width * .06),
            ),
            FittedBox(
              child: Text(
                "Contact: " + contact,
                maxLines: 1,
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w300,
                    fontSize: _width * .06),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
