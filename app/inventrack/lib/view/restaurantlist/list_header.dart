import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: true,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          "Shop Vision",
          style: TextStyle(color: Colors.white, fontSize: 35),
        ),
        background: Image(
          image: NetworkImage(
              "https://image.freepik.com/free-vector/fashion-store_23-2147563514.jpg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
