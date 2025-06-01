import 'package:hive/hive.dart';
import 'cocktail.dart';
 
part 'menu.g.dart';
 
@HiveType(typeId: 2)
class Menu {
  @HiveField(0)
  final String title;
 
  @HiveField(1)
  final List<Cocktail> cocktails;
 
  Menu({
    required this.title,
    required this.cocktails,
  });
}
 
 