import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riga Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFAF8F5), // Putih Tulang Pastel
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB5EAD7),
          primary: const Color(0xFF96CEB4), // Hijau Mint
          secondary: const Color(0xFFFFDAC1), // Peach Pastel
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List products = [];
  List filteredProducts = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('https://dummyjson.com/products'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          products = data['products'];
          filteredProducts = products;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterSearch(String query) {
    setState(() {
      filteredProducts = products
          .where((product) =>
              product['title'].toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB5EAD7), // Hijau Mint Pastel
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            const Icon(Icons.shopping_bag_rounded, color: Color(0xFF4A4A4A), size: 28),
            const SizedBox(width: 10),
            const Text(
              'Riga Shop',
              style: TextStyle(
                color: Color(0xFF4A4A4A), // Abu-abu gelap agar kontras
                fontWeight: FontWeight.w900,
                fontSize: 22,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF4A4A4A)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Color(0xFF4A4A4A)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar Pastel
          Container(
            color: const Color(0xFFB5EAD7),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              controller: searchController,
              onChanged: filterSearch,
              decoration: InputDecoration(
                hintText: 'Cari barang impianmu...',
                hintStyle: const TextStyle(color: Color(0xFF7B7B7B)),
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF779ECB)), // Biru Pastel
                filled: true,
                fillColor: const Color(0xFFE2F0CB), // Hijau Muda Kekuningan
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // Grid Produk
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF96CEB4)),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final item = filteredProducts[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(product: item),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFDAC1), // Peach Pastel
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Stack(
                                  children: [
                                    Hero(
                                      tag: 'product_image_${item['id']}',
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(16),
                                        ),
                                        child: Container(
                                          color: const Color(0xFFFAF8F5),
                                          width: double.infinity,
                                          child: Image.network(
                                            item['thumbnail'],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['title'],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF4A4A4A),
                                        fontSize: 14,
                                        height: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '\$${item['price']}',
                                      style: const TextStyle(
                                        color: Color(0xFFE07A5F), // Terracotta Lembut
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(Icons.star_rounded,
                                            color: Colors.amber, size: 16),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${item['rating']}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF6B6B6B),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final dynamic product;

  const DetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFB7B2), // Pink Pastel
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF4A4A4A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          product['title'],
          style: const TextStyle(
            color: Color(0xFF4A4A4A),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Color(0xFF4A4A4A)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Image dengan warna background pastel
                  Hero(
                    tag: 'product_image_${product['id']}',
                    child: Container(
                      height: 300,
                      width: double.infinity,
                      color: const Color(0xFFE2F0CB), // Hijau Muda Pastel
                      child: Image.network(
                        product['thumbnail'],
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  // Product Details
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['title'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF4A4A4A),
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFDAC1), // Peach Pastel
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${product['rating']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF4A4A4A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Stok Tersedia: ${product['stock']}',
                              style: const TextStyle(
                                color: Color(0xFF7B7B7B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '\$${product['price']}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFE07A5F), // Terracotta
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Divider(color: Color(0xFFDCDCDC), thickness: 1.5),
                        ),
                        const Text(
                          'Deskripsi Produk',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A4A4A),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          product['description'] ?? 'Tidak ada deskripsi',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF6B6B6B),
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFFAF8F5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF779ECB), width: 2), // Biru Pastel
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.chat_outlined, color: Color(0xFF779ECB)),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF96CEB4), // Hijau Mint Pastel
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Tambah ke Keranjang',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4A4A4A)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}