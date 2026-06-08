import 'package:cached_network_image/cached_network_image.dart';
import 'package:elior/constatnt/assets_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget getImage({String? url, required double height, required double width}) {
  try {
    if (url == null || url.isEmpty) {
      return Image.asset(AssetsScreen.elior, height: height, width: width);
    }
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      placeholder: (context, url) => const CupertinoActivityIndicator(),
      errorWidget: (context, url, error) => Image.asset(AssetsScreen.elior),
      fit: BoxFit.cover,
    );
  } catch (e) {
    return Image.asset(AssetsScreen.elior, height: height, width: width);
  }
}