import 'package:hive/hive.dart';

part 'menu.g.dart';

@HiveType(typeId: 1)
class Menu extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final List<String> cocktailsNames;

  Menu({
    required this.title,
    required this.cocktailsNames,
  });
}
 
 