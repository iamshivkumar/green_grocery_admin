import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


final indexProvider = StateProvider((ref)=>0);


class ProductImageViewer extends HookWidget {
  final List images;
  ProductImageViewer({required this.images});
  @override
  Widget build(BuildContext context) {
    final _pageController = usePageController();
    final indexState = useProvider(indexProvider);
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: PageView(
            onPageChanged: (value) => indexState.state = value,
            controller: _pageController,
            children: images
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    child: Image.network(
                      e,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ListView.builder(
              itemCount:images.length,
              itemBuilder: (context, index) => Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      indexState.state = index;
                      _pageController.animateToPage(index,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeInCirc);
                    },
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Material(
                        borderRadius: BorderRadius.circular(8),
                        color: indexState.state == index
                            ? Theme.of(context).primaryColor
                            : Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.network(images[index]),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  )
                ],
              ),
              scrollDirection: Axis.horizontal,
            ),
          ),
        ),
      ],
    );
  }
}
