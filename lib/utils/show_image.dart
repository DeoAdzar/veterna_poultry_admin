import 'package:cached_network_image/cached_network_image.dart';
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
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          placeholder: (context, url) => Container(
            child: const SizedBox(
                width: 24,
                height: 24,
                child: Center(child: CircularProgressIndicator())),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }
}
