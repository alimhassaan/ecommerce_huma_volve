import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_category_entity.dart';

class HomeProductEntity {
   int? id;
   String? title;
   String? slug;
   int? price;
   String? description;
   HomeCategoryEntity? category;
  List<String>? images;

  HomeProductEntity({
    this.id,
    this.title,
    this.slug,
    this.price,
    this.description,
    this.category,
    this.images,
  });

  
}
