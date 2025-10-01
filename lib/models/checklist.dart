class ChecklistData {
  final List<String> topTasks;
  final Map<String, List<String>> sections;
  final Set<String> checked;

  ChecklistData({
    required this.topTasks,
    required this.sections,
    required this.checked,
  });

  Map<String, dynamic> toMap() {
    return {
      'topTasks': topTasks,
      'sections': sections,
      'checked': checked.toList(),
    };
  }

  factory ChecklistData.fromMap(Map<String, dynamic> map) {
    final rawTop = map['topTasks'] as List<dynamic>? ?? const [];
    final rawSections = map['sections'] as Map<String, dynamic>? ?? const {};
    final rawChecked = map['checked'] as List<dynamic>? ?? const [];

    final sections = <String, List<String>>{};
    rawSections.forEach((k, v) {
      final list = (v as List<dynamic>? ?? const []).map((e) => e.toString()).toList();
      sections[k] = list;
    });

    return ChecklistData(
      topTasks: rawTop.map((e) => e.toString()).toList(),
      sections: sections,
      checked: rawChecked.map((e) => e.toString()).toSet(),
    );
  }
}

