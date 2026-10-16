import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_product_entity.dart';

import 'category_model.dart';

class HomeProductModel extends HomeProductEntity {

  HomeProductModel({
    super.id,
   super.title,
   super.slug,
   super.price,
   super.description,
   super.category,
   super.images,
  });

  HomeProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    price = (json['price'] as num?)?.toInt();
    description = json['description'];
    category = (json['category'] != null
        ? HomeCategoryModel.fromJson(json['category'])
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
}
