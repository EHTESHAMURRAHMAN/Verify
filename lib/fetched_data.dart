import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ImageSlider extends StatefulWidget {
  final File? firstimg;
  final File? secondimg;

  const ImageSlider(
      {super.key, required this.firstimg, required this.secondimg});
  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  // Controller for the PageView
  PageController _pageController = PageController(initialPage: 0);

  // Current index of the displayed image
  int _currentIndex = 0;

  // Method to navigate to the next image
  void _slideImage() {
    setState(() {
      // Toggle between 0 and 1 for two images
      _currentIndex = _currentIndex == 0 ? 1 : 0;
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Image Slider"),
        ),
        body: Center(
            child: Column(children: [
          Stack(alignment: Alignment.center, children: [
            SizedBox(
                height: 300,
                width: MediaQuery.of(context).size.width,
                child: PageView(controller: _pageController, children: [
                  Image.file(widget.firstimg!, fit: BoxFit.contain),
                  Image.file(widget.secondimg!, fit: BoxFit.contain)
                ])),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              InkWell(
                  onTap: _slideImage, child: const Icon(Icons.arrow_back_ios)),
              InkWell(
                  onTap: _slideImage,
                  child: const Icon(Icons.arrow_forward_ios))
            ])
          ]),
          const SizedBox(height: 20)
        ])));
  }
}
