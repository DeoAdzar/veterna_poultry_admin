import 'package:flutter/material.dart';

import 'dimen.dart';

class ShowImage extends StatelessWidget {
  final String imageUrl;

  const ShowImage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Dimen(context).height,
        width: Dimen(context).width,
        color: Colors.black,
        child: Image.network(imageUrl),
      ),
    );
  }
}
