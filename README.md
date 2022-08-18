# Inkblob_navigation_bar

A custom navigation bar with smooth & dynamic ink blob transition effect.<br>


## Overview

This packages was inspired by this [post from Dribbble](https://dribbble.com/shots/14390074-Tab-Bar-Switches-Interaction)

Implemented:<br>
<img src="https://raw.githubusercontent.com/jellepepe/inkblob_navigation_bar/master/screenshot/1.gif" width="500">

## Gallery

### Dynamic Movement
<img src="https://raw.githubusercontent.com/jellepepe/inkblob_navigation_bar/master/screenshot/2.gif" width="500">

### Customizable Curve
<img src="https://raw.githubusercontent.com/jellepepe/inkblob_navigation_bar/master/screenshot/3.gif" width="500">

### Custom Colors
<img src="https://raw.githubusercontent.com/jellepepe/inkblob_navigation_bar/master/screenshot/4.gif" width="500">

### Optional Titles
<img src="https://raw.githubusercontent.com/jellepepe/inkblob_navigation_bar/master/screenshot/5.gif" width="500">

### Works with any widgets
<img src="https://raw.githubusercontent.com/jellepepe/inkblob_navigation_bar/master/screenshot/6.gif" width="500">

## How to install
Simply add the package to your dependencies! No other steps required :)

## Documentation

To use the `InkblobNavigationBar` you can simply use it in the `bottomNavigationBar` field of your material scaffold:
```dart
Scaffold(
  ...
  bottomNavigationBar: InkblobNavigationBar(
    ...
  )
)
```

### You can customize these attributes in the navigation bar.<br>

| Attributes | Type | Description | Default |
| -------------------- | -------------- | ---------------- | --------------- |
| `showElevation`   | `bool` | Enable subtle shadow effect | `true` |
| `items`   | `List<InkblobBarItem>` | item data for NavigationBar  | required |
| `onItemSelected`  | `Function(int)` | callback function when item tapped | `null` |
| `selectedIndex`  | `int` | selected item index of navigation bar. | required |
| `previousIndex`  | `int` | previously selected item index of navigation bar. | `selectedIndex` |
| `iconSize`  | `double` | size of icons. | `24.0` |
| `backgroundColor`  | `Color` | Background color of [CustomNavigationBar] | `Theme.bottomAppBarColor` |
| `containerHeight`  | `double` | height of the NavigationBar | `60` |
| `itemWidth`  | `double` | total width of each item | `2*containerHeight` |
| `curve`  | `Curve` | animation curve of scale effect | `Curves.easInOutExpo` |
| `animationDuration`  | `Duration` | Duration of the total animation | `Duration(milliseconds: 270)` |


**Attention**: Both the `selectedIndex` **and** `previousIndex` are required for the animation to perform, an example of how to implement this is shown in the provided example app.

To customize the items in the navigation bar, just supply a list of ```InkblobBarItem``` like this.
```dart
InkblobNavigationBar(
  ...
  items: [
    // Simple Icon with a Title & Color
    InkblobBarItem(
      title: const Text('User'),
      filledIcon: const Icon(SpiriIcons.fi_sr_user),
      emptyIcon: const Icon(SpiriIcons.fi_rr_user),
      color: Colors.blue
    ),
    // Custom Containers
    InkblobBarItem(
      filledIcon: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12)
        )
      ),
      emptyIcon: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black, width: 2)
        )
      ),
    ),
    // Even Text Widgets
    InkblobBarItem(
      filledIcon: const Text('❤️', style: TextStyle(fontSize: 20)),
      emptyIcon: const Text('🖤', style: TextStyle(fontSize: 20)),
      color: Colors.red
    ),
  ],
)
```


## Example
Check the example app for a full implementation example.

## Contribute
Issues and pull requests are always welcome!  
If you found this project helpful, consider buying me a cup of :coffee:
- [PayPal](https://www.paypal.me/bymedev)
