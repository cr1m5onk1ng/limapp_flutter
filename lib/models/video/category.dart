import 'package:flutter/material.dart';

class Category {
  final String categoryName;
  final IconData categoryIcon;

  Category(this.categoryName, this.categoryIcon);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    if (o is Category && this.categoryName == o.categoryName) return true;
    return false;
  }

  @override
  int get hashCode => this.categoryName.hashCode;
}
