import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

Widget customLoadingIndicator(context) {
  return LoadingAnimationWidget.flickr(
    leftDotColor: const Color.fromARGB(255, 245, 131, 1),
    rightDotColor: Theme.of(context).primaryColor,
    size: 30,
  );
}
