import 'package:flutter/material.dart';

class NavigationButton extends StatelessWidget {
  final IconData icon;
  final Function onTap;
  final Color hoverColor;

  NavigationButton({this.icon, this.onTap, this.hoverColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Icon(icon),
    );
  }
}
