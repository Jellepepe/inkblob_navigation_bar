// Copyright 2022 Pepe Tiebosch (byme.dev/Jellepepe). All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

library inkblob_navigation_bar;

import 'dart:math';

import 'package:flutter/material.dart';

import 'animated_fill_icon.dart';

class InkblobNavigationBar extends StatelessWidget {
  const InkblobNavigationBar({
    super.key,
    this.showElevation = true,
    this.iconSize = 24,
    this.backgroundColor,
    this.containerHeight = 60,
    double? itemWidth,
    this.animationDuration = const Duration(milliseconds: 270),
    required this.selectedIndex,
    int? previousIndex,
    required this.items,
    required this.onItemSelected,
    this.curve = Curves.easeInOutExpo,
  })  : assert(items.length >= 2),
        previousIndex = previousIndex ?? selectedIndex,
        itemWidth = itemWidth ?? containerHeight * 2;

  /// Defines the width of each item. Defaults to twice the [containerHeight].
  final double itemWidth;

  /// The selected item index. Changing this property will change and animate
  /// the item being selected.
  final int selectedIndex;

  /// The previous item index. Changing this property is required to trigger the proper animation. Defaults to [selectedIndex].
  final int previousIndex;

  /// The icon size of all items. Defaults to 24.
  final double iconSize;

  /// The background color of the navigation bar. It defaults to
  /// [Theme.bottomAppBarColor] if not provided.
  final Color? backgroundColor;

  /// Whether this navigation bar should show an elevation. Defaults to true.
  final bool showElevation;

  /// Use this to change the animation duration. Defaults to 270ms.
  final Duration animationDuration;

  /// Defines the appearance of the buttons that are displayed in the bottom
  /// navigation bar. This should have at least two items.
  final List<InkblobBarItem> items;

  /// A callback that will be called when a item is pressed.
  final ValueChanged<int> onItemSelected;

  /// Defines the bottom navigation bar height. Defaults to 56.
  final double containerHeight;

  /// Defines the animation curve. Defaults to [Curves.easeInOutExpo].
  final Curve curve;

  double _opacity(double value, double percentageDist) {
    if (percentageDist.isInfinite) return 0;
    if (value < percentageDist / 8) return 0;
    if (value > 1 - (percentageDist / 4)) return 0;
    if (value < percentageDist / 2) {
      return (value - (percentageDist / 8)) * (1 / ((percentageDist / 8) * 3));
    }
    if (value > 1 - (percentageDist / 2)) {
      return (1 - (value + (percentageDist / 4))) * (1 / (percentageDist / 4));
    }
    return 1;
  }

  /// Calculates the (left) offset of an icon based on its index
  double _iconOffset(double maxWidth, double index) {
    return ((maxWidth - items.length * itemWidth) / (items.length + 1)) * (index + 1) + (index * itemWidth);
  }

  /// Calculates the (left) offset of the inkblob based on the animation value
  double _blobOffset(double maxWidth, double value) => _iconOffset(maxWidth, value) + ((itemWidth - iconSize) / 2);

  /// Calculates the proportion of the inkblob animation distance it is covered by an icon
  double _percentageDist(double maxWidth) {
    return iconSize /
        (((maxWidth - items.length * itemWidth) / (items.length + 1) + (itemWidth - iconSize)) *
            (selectedIndex - previousIndex).abs());
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? Theme.of(context).bottomAppBarColor;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          if (showElevation)
            const BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
              spreadRadius: 2,
            ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: containerHeight,
          child: LayoutBuilder(
            builder: (context, constraints) {
              double percentageDist = _percentageDist(constraints.maxWidth);
              return Stack(
                alignment: Alignment.center,
                children: [
                  TweenAnimationBuilder(
                    duration: animationDuration,
                    curve: curve,
                    tween: Tween<double>(
                      begin: previousIndex.toDouble(),
                      end: selectedIndex.toDouble(),
                    ),
                    builder: (context, double value, child) {
                      double anim =
                          (value - min(previousIndex, selectedIndex)) / max(1, (previousIndex - selectedIndex).abs());
                      anim = previousIndex > selectedIndex ? 1 - anim : anim;
                      Color color = Color.lerp(
                            items[previousIndex].color,
                            items[selectedIndex].color,
                            anim,
                          ) ??
                          Colors.black;
                      if (anim == 1) return const SizedBox();
                      return Positioned(
                        left: _blobOffset(constraints.maxWidth, value),
                        child: Transform.scale(
                          scaleX: 0.9 + (anim > 0.5 ? 1 - anim : anim) * (selectedIndex - previousIndex).abs(),
                          child: Opacity(
                            opacity: _opacity(anim, percentageDist),
                            child: Container(
                              width: iconSize,
                              height: iconSize * 0.8,
                              decoration: BoxDecoration(
                                color: color,
                                boxShadow: [
                                  BoxShadow(
                                    color: color,
                                    blurRadius: 1,
                                    spreadRadius: 1,
                                  ),
                                ],
                                borderRadius: const BorderRadius.all(
                                  Radius.elliptical(50, 40),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  ...items.map(
                    (item) {
                      int index = items.indexOf(item);
                      bool isSelected = index == selectedIndex;

                      return Positioned(
                        left: _iconOffset(constraints.maxWidth, index.toDouble()),
                        child: GestureDetector(
                          onTap: () => onItemSelected(index),
                          child: (isSelected) ^ (index == previousIndex)
                              ? TweenAnimationBuilder<double>(
                                  tween: isSelected ? Tween<double>(begin: 0, end: 1) : Tween<double>(begin: 1, end: 0),
                                  duration: animationDuration,
                                  curve: curve,
                                  builder: (context, value, child) {
                                    return _ItemWidget(
                                      item: item,
                                      fillValue: max(
                                        1 - (1 - value) * (1 / percentageDist),
                                        0,
                                      ),
                                      iconSize: iconSize,
                                      selectionDirection:
                                          (index > selectedIndex) || (isSelected && index > previousIndex)
                                              ? TextDirection.ltr
                                              : TextDirection.rtl,
                                      itemWidth: itemWidth,
                                      itemHeight: containerHeight,
                                    );
                                  },
                                )
                              : _ItemWidget(
                                  item: item,
                                  fillValue: isSelected ? 1 : 0,
                                  iconSize: iconSize,
                                  itemWidth: itemWidth,
                                  itemHeight: containerHeight,
                                ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  const _ItemWidget({
    super.key,
    required this.item,
    required this.fillValue,
    required this.iconSize,
    this.selectionDirection = TextDirection.ltr,
    required this.itemWidth,
    required this.itemHeight,
  });

  final double iconSize;
  final double fillValue;
  final InkblobBarItem item;
  final TextDirection selectionDirection;
  final double itemWidth;
  final double itemHeight;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      selected: fillValue == 1,
      child: Container(
        width: itemWidth,
        height: itemHeight,
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Column(
          children: [
            const Spacer(),
            AnimatedFillIcon(
              fillValue: fillValue,
              size: iconSize,
              fillDirection: selectionDirection,
              emptyIcon: item.emptyIcon,
              filledIcon: item.filledIcon,
              color: item.color,
            ),
            if (item.title != null && fillValue != 0)
              Expanded(
                child: fillValue == 1
                    ? Align(
                        alignment: Alignment.topCenter,
                        child: item.title,
                      )
                    : Transform(
                        alignment: Alignment.topCenter,
                        transform: Matrix4.translationValues(fillValue, fillValue, 1)..scale(fillValue, fillValue, 1),
                        child: item.title,
                      ),
              )
            else
              const Spacer()
          ],
        ),
      ),
    );
  }
}

/// The [InkblobNavigationBar.items] definition.
class InkblobBarItem {
  InkblobBarItem({
    required this.emptyIcon,
    required this.filledIcon,
    this.title,
    this.color = Colors.black,
  });

  /// Defines this item's icon shown when not selected.
  final Widget emptyIcon;

  /// Defines this item's icon shown when selected. For optimal results this should be a filled version of [emptyIcon].
  final Widget filledIcon;

  /// Defines this item's title which placed below the [icon] when selected.
  final Widget? title;

  /// The [icon] color defined, also used to color the blob in transit. Defaults
  /// to [Colors.black].
  final Color color;
}
