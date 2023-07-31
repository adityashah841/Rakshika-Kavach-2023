import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class BlogSlider extends StatelessWidget {
  final List<String> imageList;

  const BlogSlider({Key? key, required this.imageList});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 1),
        height: MediaQuery.of(context).size.height * 0.3,
        initialPage: 0,
        enableInfiniteScroll: true,
        viewportFraction: 0.95,
      ),
      itemCount: imageList.length,
      itemBuilder: (BuildContext context, int index, int realIndex) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Image.asset(imageList[index]),
          ),
        );
      },
    );
  }
}
