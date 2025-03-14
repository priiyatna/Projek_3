import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final bool showImage;

  const CategoryCard({super.key, required this.title, this.showImage = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
