import 'package:flutter/material.dart';
import '../widgets/category_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TOKO DERYKO', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue[200],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),
            // GridView for Categories
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: const [
                  CategoryCard(title: 'SEMBAKO'),
                  CategoryCard(title: 'ROKOK'),
                  CategoryCard(title: 'SNACK'),
                  CategoryCard(title: 'MINUMAN'),
                  CategoryCard(title: 'PERALATAN MANDI & RUMAH'),
                  CategoryCard(title: 'LAIN-LAIN', showImage: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
