import 'package:flutter/material.dart';
import '../../../../core/dummy_data.dart';
import 'category_model.dart';

class ProductModel {
  int? id;
  String? title;
  String? slug;
  int? price;
  String? description;
  CategoryModel? category;
  List<String>? images;

  ProductModel({
    this.id,
    this.title,
    this.slug,
    this.price,
    this.description,
    this.category,
    this.images,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    price = (json['price'] as num?)?.toInt();
    description = json['description'];
    category = (json['category'] != null
        ? CategoryModel.fromJson(json['category'])
        : null);
    if (json['images'] != null && json['images'] is List) {
      images = (json['images'] as List)
          .map((e) => e.toString().replaceAll(RegExp(r'[\[\]"]'), '').trim())
          .where((e) => e.isNotEmpty)
          .toList();
    } else {
      images = [];
    }
  }

  Product toProduct() {
    String validImageUrl = '';
    if (images != null && images!.isNotEmpty) {
      for (final img in images!) {
        final clean = img.trim();
        if (clean.isNotEmpty &&
            (clean.startsWith('http://') || clean.startsWith('https://')) &&
            !clean.contains('placeimg.com')) {
          validImageUrl = clean;
          break;
        }
      }
      if (validImageUrl.isEmpty && images!.first.isNotEmpty) {
        validImageUrl = images!.first;
      }
    }

    return Product(
      id: id?.toString() ?? '',
      name: title ?? 'No Title',
      description: description ?? '',
      price: (price ?? 0).toDouble(),
      imageUrl: validImageUrl.isNotEmpty
          ? validImageUrl
          : 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600',
      colors: const [Colors.black, Colors.blue, Colors.grey],
      sizes: const ['S', 'M', 'L', 'XL'],
    );
  }
}
