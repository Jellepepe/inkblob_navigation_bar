// Copyright 2022 Pepe Tiebosch (byme.dev/Jellepepe). All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:inkblob_navigation_bar/inkblob_navigation_bar.dart';

import 'spiri_icons.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inkblob Navigation Bar Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late PageController _pageController;
  bool _animatingPage = false;
  int _selectedIndex = 0;
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _animatingPage = true;
      _previousIndex = _selectedIndex;
      _selectedIndex = index;
      _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.easeOut).then((value) {
          _animatingPage = false;
          _previousIndex = _selectedIndex;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inkblob Navigation Bar Demo')),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            if(!_animatingPage) {
              setState(() {
              _previousIndex = _selectedIndex;
              _selectedIndex = index;
            });
            }
          },
          children: <Widget>[
            Container(color: Colors.blue,),
            Container(color: Colors.red,),
            Container(color: Colors.green,),
            Container(color: Colors.yellow,),
            Container(color: Colors.purple,),
          ],
        ),
      ),
      bottomNavigationBar: InkblobNavigationBar(
        selectedIndex: _selectedIndex,
        previousIndex: _previousIndex,
        onItemSelected: _onItemTapped,
        //curve: Curves.bounceOut,
        //animationDuration: const Duration(milliseconds: 500),
        items: <InkblobBarItem>[
          InkblobBarItem(
            title: const Text('User', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.blue)),
            filledIcon: const Icon(SpiriIcons.fi_sr_user),
            emptyIcon: const Icon(SpiriIcons.fi_rr_user),
            color: Colors.blue
          ),
          InkblobBarItem(
            title: const Text('Cube', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.red)),
            filledIcon: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(5)
              )
            ),
            emptyIcon: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.red, width: 2)
              )
            ),
          ),
          InkblobBarItem(
            filledIcon: const Icon(SpiriIcons.fi_sr_home),
            emptyIcon: const Icon(SpiriIcons.fi_rr_home),
            color: Colors.purple
          ),
          InkblobBarItem(
            title: const Text('Heart', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.red)),
            filledIcon: const Text('❤️', style: TextStyle(fontSize: 20)),
            emptyIcon: const Text('🖤', style: TextStyle(fontSize: 20)),
            color: Colors.red
          ),
          InkblobBarItem(
            title: const Text('Message', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.green)),
            filledIcon: const Icon(SpiriIcons.fi_sr_comment),
            emptyIcon: const Icon(SpiriIcons.fi_rr_comment),
            color: Colors.green
          ),
        ],
      ),
    );
  }
}
