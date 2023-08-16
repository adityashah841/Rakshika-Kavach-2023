import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:Rakshika/utils/color.dart';

class BlogSlider extends StatelessWidget {
  final List<String> imageList;
  final List<String> sloganList; // List of text slogans

  // ignore: use_key_in_widget_constructors
  const BlogSlider({
    Key? key,
    required this.imageList,
    required this.sloganList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.25,
          width: MediaQuery.of(context).size.width * 1,
          child: CarouselSlider.builder(
            options: CarouselOptions(
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 4),
              enableInfiniteScroll: true,
              viewportFraction: 0.95,
            ),
            itemCount: imageList.length,
            itemBuilder: (BuildContext context, int index, int realIndex) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: rBackground,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.asset(imageList[index]),
                ),
              );
            },
          ),
        ),
        // SizedBox(
        //   height: MediaQuery.of(context).size.height * 0.1,
        //   width: MediaQuery.of(context).size.width * 1,
        //   child: CarouselSlider.builder(
        //     options: CarouselOptions(
        //       autoPlay: true,
        //       autoPlayInterval: const Duration(seconds: 2),
        //       enableInfiniteScroll: true,
        //       viewportFraction: 0.9,
        //     ),
        //     itemCount: sloganList.length,
        //     itemBuilder: (BuildContext context, int index, int realIndex) {
        //       return Padding(
        //         padding: const EdgeInsets.symmetric(horizontal: 5),
        //         child: DecoratedBox(
        //           decoration: BoxDecoration(
        //             borderRadius: BorderRadius.circular(5),
        //           ),
        //           child: Center(
        //             child: Text(
        //               sloganList[index],
        //               style: const TextStyle(
        //                 fontSize: 18,
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             ),
        //           ),
        //         ),
        //       );
        //     },
        //   ),
        // ),
      ],
    );
  }
}
