import 'package:flutter/material.dart';

class CategoriesContainer extends StatelessWidget {
  final List<String> categories;

  const CategoriesContainer({Key key, @required this.categories})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: _CategoryBox(item: categories[index]),
            );
          },
        ),
      ),
    );
  }
}

class _CategoryBox extends StatelessWidget {
  final String item;

  const _CategoryBox({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      onPressed: () {},
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      color: Colors.white,
      borderSide: BorderSide(
        width: 3,
        color: Colors.redAccent,
      ),
      textColor: Colors.black,
      child: Row(
        children: [
          //Icon(Icons.category),
          //const SizedBox(width: 4),
          Text(item),
        ],
      ),
    );
  }
}
