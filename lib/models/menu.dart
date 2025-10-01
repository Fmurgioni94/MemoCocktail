class Menu {
  final String title;
  final List<String> cocktailsNames;

  Menu({
    required this.title,
    required this.cocktailsNames,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'cocktailsNames': cocktailsNames,
    };
  }

  factory Menu.fromMap(Map<String, dynamic> map) {
    final names = (map['cocktailsNames'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList();
    return Menu(title: map['title'] as String? ?? '', cocktailsNames: names);
  }
}
 
 