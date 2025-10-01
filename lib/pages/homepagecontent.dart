import 'package:MemoCocktail/pages/databasecomunicationpage.dart';
import 'package:MemoCocktail/pages/settings.dart' as app_settings;
import 'package:flutter/material.dart';
import '../models/cocktail.dart';
import '../models/checklist.dart';
import 'package:MemoCocktail/pages/cocktaildetailpage.dart';
import 'dart:async';
import '../services/firestore_service.dart';

class Homepagecontent extends StatefulWidget {
  const Homepagecontent({super.key});

  @override
  State<Homepagecontent> createState() => _HomepagecontentState();
}

enum _Filter { all, todo, done }

class _HomepagecontentState extends State<Homepagecontent> {
  final Set<String> _checked = {};
  bool _isEditing = false;

  // Vista: filtro elementi
  _Filter _filter = _Filter.all;
  final Set<String> _expandedSections = {};

  // Venue selection
  String? _selectedVenue;
  List<String> _venues = [];
  bool _venuesLoaded = false;
  StreamSubscription<ChecklistData?>? _checklistSub;

  // Dynamic checklist data (loaded from Firestore)
  List<String> _topTasks = [
    'Remove cling film and condoms',
    'Request missing wines',
    'Check the bar',
    'Request missing bottles',
    'Fruit (oranges / limes / lemons / grapefruit)',
    'To cut',
    'For peeling',
    'Check soft drinks',
    'Check beers',
  ];

  final Map<String, List<String>> _defaultSections = {
    'Syrups:': [
      'Shrub',
      'Lime cordial',
      'Raspberry',
      'Olive brine',
      'Agave water',
      'Pineapple tea',
      'Granadine',
      'Honey ginger',
      'Orange cordial',
      'Honey chili and sage',
      'Honey water',
      'Passion fruit puree',
      'Double cream',
      'Egg white',
      'Peach & elderflower',
      'Coconut cream',
    ],
    'Juices:': [
      'Orange juice',
      'Grapefruit juice',
      'Cranberry',
      'Pineapple',
      'Apple',
      'Lemon',
      'Lime',
      'Coffee',
    ],
    'Garnish:': [
      'Mint leaves',
      'Mint sprigs',
      'Salt',
      'Tajin',
      'Sugar',
      'Maraschino cherry',
      'Martini olives',
      'Cucumber',
      'Dry pineapple',
      'Peels (orange, lemon, grapefruit, lime)',
    ],
    'Bitters:': [
      'Angostura',
      'Orange Bitter',
      'Absinthe',
      'Peychaud bitter',
      'Boker’s bitter',
      'Tabasco',
    ],
    'Tools:': [
      'Shakers',
      'Mixing glass',
      'Jiggers(20/40, 25/50, 30/60, preciso)',
      'Bamboo skewers',
      'Napkins',
      'Ice pick',
      'Chopping board',
      'Fine strainers',
      'Strainers',
      'Bar spoons',
      'Ice block tongs',
      'Tongs',
      'Muddler',
      'Knives',
      'Pdq rolls small',
      'Peelers',
    ],
    'Soft drinks': [
      'Soda',
      'Tonic',
      'Ginger Beer',
      'Ginger Ale',
      'Lemonade',
      'Slim Tonic',
      'Coca-Cola',
      'Diet Coke',
      'Mandarin & Bergamot Soda',
    ],
  };

  Map<String, List<String>> _sections = {};

  Future<void> _persistChecklist() async {
    if (_selectedVenue == null) return;
    final data = ChecklistData(
      topTasks: List<String>.from(_topTasks),
      sections: Map<String, List<String>>.from(_sections.isEmpty ? _defaultSections : _sections),
      checked: Set<String>.from(_checked),
    );
    await FirestoreService.saveChecklist(_selectedVenue!, data);
  }

  Future<String?> _showTextDialog({required String title, String initialValue = ''}) async {
    final controller = TextEditingController(text: initialValue);
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, controller.text.trim()), child: const Text('OK')),
        ],
      ),
    );
  }

  Future<void> _loadChecklistForVenue() async {
    if (_selectedVenue == null) return;
    // Cancel previous subscription to avoid multiple listeners
    await _checklistSub?.cancel();
    // Ensure a default checklist exists for this venue so the UI can load
    final defaults = ChecklistData(
      topTasks: List<String>.from(_topTasks),
      sections: _sections.isEmpty
          ? Map<String, List<String>>.from(_defaultSections)
          : Map<String, List<String>>.from(_sections),
      checked: <String>{},
    );
    try {
      await FirestoreService.ensureChecklist(_selectedVenue!, defaults);
    } catch (_) {
      // Ignore errors; the stream below will handle existing docs
    }
    _checklistSub = FirestoreService.watchChecklist(_selectedVenue!).listen((data) {
      if (!mounted) return;
      if (data != null) {
        setState(() {
          _topTasks = data.topTasks;
          _sections = data.sections.isEmpty ? Map<String, List<String>>.from(_defaultSections) : data.sections;
          _checked
            ..clear()
            ..addAll(data.checked);
        });
      } else {
        final defaults = ChecklistData(
          topTasks: _topTasks,
          sections: Map<String, List<String>>.from(_defaultSections),
          checked: _checked,
        );
        FirestoreService.saveChecklist(_selectedVenue!, defaults);
      }
    });
  }

  void _renameSection(String oldName, String newName) {
    if (newName.isEmpty || oldName == newName || _sections.containsKey(newName)) return;
    final items = _sections.remove(oldName);
    if (items == null) return;
    _sections[newName] = items;
    final toUpdate = _checked.where((k) => k.startsWith('$oldName::')).toList();
    for (final k in toUpdate) {
      _checked.remove(k);
      _checked.add(k.replaceFirst('$oldName::', '$newName::'));
    }
    // Save changes
    Future.microtask(_persistChecklist);
  }

  void _deleteSection(String section) {
    _sections.remove(section);
    _checked.removeWhere((k) => k.startsWith('$section::'));
    Future.microtask(_persistChecklist);
  }

  void _renameItem(String section, String oldLabel, String newLabel) {
    if (newLabel.isEmpty || oldLabel == newLabel) return;
    final items = _sections[section];
    if (items == null) return;
    final idx = items.indexOf(oldLabel);
    if (idx < 0) return;
    items[idx] = newLabel;
    final oldKey = '$section::$oldLabel';
    final newKey = '$section::$newLabel';
    if (_checked.remove(oldKey)) {
      _checked.add(newKey);
    }
    Future.microtask(_persistChecklist);
  }

  void _deleteItem(String section, String label) {
    final items = _sections[section];
    if (items == null) return;
    items.remove(label);
    _checked.remove('$section::$label');
    Future.microtask(_persistChecklist);
  }

  void _renameTopTask(String oldLabel, String newLabel) {
    if (newLabel.isEmpty || oldLabel == newLabel) return;
    final idx = _topTasks.indexOf(oldLabel);
    if (idx < 0) return;
    _topTasks[idx] = newLabel;
    final oldKey = 'top::$oldLabel';
    final newKey = 'top::$newLabel';
    if (_checked.remove(oldKey)) {
      _checked.add(newKey);
    }
    Future.microtask(_persistChecklist);
  }

  void _deleteTopTask(String label) {
    _topTasks.remove(label);
    _checked.remove('top::$label');
    Future.microtask(_persistChecklist);
  }

  Widget _buildCheckbox(String key, String label) {
    final isChecked = _checked.contains(key);
    return CheckboxListTile(
      value: isChecked,
      onChanged: (_) {
        setState(() {
          if (isChecked) {
            _checked.remove(key);
          } else {
            _checked.add(key);
          }
        });
        if (_selectedVenue != null) {
          FirestoreService.updateChecked(_selectedVenue!, _checked);
        }
      },
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(label),
    );
  }

  Widget _sectionHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurpleAccent,
        ),
      ),
    );
  }

  int _checkedInSection(String sectionTitle) {
    return _checked.where((k) => k.startsWith('$sectionTitle::')).length;
  }

  Widget _buildDynamicSection(String sectionTitle, List<String> items) {
    final completed = _checkedInSection(sectionTitle);
    // Applica filtro agli elementi mostrati
    List<String> visibleItems = items.where((label) {
      final key = '$sectionTitle::$label';
      final isChecked = _checked.contains(key);
      switch (_filter) {
        case _Filter.all:
          return true;
        case _Filter.todo:
          return !isChecked;
        case _Filter.done:
          return isChecked;
      }
    }).toList();

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        key: ValueKey('section-$sectionTitle-${_expandedSections.contains(sectionTitle)}'),
        tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        childrenPadding: const EdgeInsets.only(left: 8, right: 8, bottom: 12),
        initiallyExpanded: _expandedSections.contains(sectionTitle),
        onExpansionChanged: (expanded) {
          setState(() {
            if (expanded) {
              _expandedSections.add(sectionTitle);
            } else {
              _expandedSections.remove(sectionTitle);
            }
          });
        },
        title: Row(
          children: [
            Expanded(
              child: Text(
                sectionTitle,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '$completed/${items.length}',
                style: const TextStyle(color: Colors.deepPurpleAccent, fontSize: 12),
              ),
            ),
          ],
        ),
        trailing: _isEditing
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.deepPurpleAccent),
                    tooltip: 'Add item',
                    onPressed: () async {
                      final text = await _showTextDialog(title: 'New item in $sectionTitle');
                      if (text != null && text.isNotEmpty) {
                        setState(() {
                          items.add(text);
                        });
                      await _persistChecklist();
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.deepPurpleAccent),
                    tooltip: 'Rename section',
                    onPressed: () async {
                      final text = await _showTextDialog(title: 'Rename section', initialValue: sectionTitle);
                      if (text != null && text.isNotEmpty) {
                        setState(() {
                          _renameSection(sectionTitle, text);
                        });
                          await _persistChecklist();
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.deepPurpleAccent),
                    tooltip: 'Delete section',
                    onPressed: () {
                      setState(() {
                        _deleteSection(sectionTitle);
                      });
                      _persistChecklist();
                    },
                  ),
                ],
              )
            : null,
        children: [
          // Progress bar
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: items.isEmpty ? 0 : (completed / items.length),
                minHeight: 8,
                backgroundColor: Colors.deepPurpleAccent.withOpacity(0.1),
                valueColor: const AlwaysStoppedAnimation(Colors.deepPurpleAccent),
              ),
            ),
          ),
          // Seleziona/Deseleziona tutto
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 8,
              children: [
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      for (final label in items) {
                        _checked.add('$sectionTitle::$label');
                      }
                    });
                    if (_selectedVenue != null) {
                      FirestoreService.updateChecked(_selectedVenue!, _checked);
                    }
                      _persistChecklist();
                  },
                  icon: const Icon(Icons.done_all, color: Colors.deepPurpleAccent),
                  label: const Text('Select all'),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _checked.removeWhere((k) => k.startsWith('$sectionTitle::'));
                    });
                    if (_selectedVenue != null) {
                      FirestoreService.updateChecked(_selectedVenue!, _checked);
                    }
                      _persistChecklist();
                  },
                  icon: const Icon(Icons.clear_all, color: Colors.deepPurpleAccent),
                  label: const Text('Clear all'),
                ),
              ],
            ),
          ),
          const Divider(height: 8),
          ...visibleItems.map((label) => Row(
                children: [
                  Expanded(child: _buildCheckbox('$sectionTitle::$label', label)),
                  // Persist checkbox toggle
                  // Hook into checkbox change by mirroring current state after frame
                  if (_isEditing)
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.deepPurpleAccent),
                          onPressed: () async {
                            final text = await _showTextDialog(title: 'Rinomina elemento', initialValue: label);
                            if (text != null && text.isNotEmpty) {
                              setState(() {
                                _renameItem(sectionTitle, label, text);
                              });
                              await _persistChecklist();
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.deepPurpleAccent),
                          onPressed: () {
                            setState(() {
                              _deleteItem(sectionTitle, label);
                            });
                            _persistChecklist();
                          },
                        ),
                      ],
                    ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildTopTasksCard() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    'Tasks',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                if (_isEditing)
                  TextButton.icon(
                    onPressed: () async {
                      final text = await _showTextDialog(title: 'New task');
                      if (text != null && text.isNotEmpty) {
                        setState(() {
                          _topTasks.add(text);
                        });
                        await _persistChecklist();
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add'),
                  ),
              ],
            ),
            const Divider(height: 8),
            ..._topTasks.where((label) {
              final key = 'top::$label';
              final isChecked = _checked.contains(key);
              switch (_filter) {
                case _Filter.all:
                  return true;
                case _Filter.todo:
                  return !isChecked;
                case _Filter.done:
                  return isChecked;
              }
            }).map((label) => Row(
                  children: [
                    Expanded(child: _buildCheckbox('top::$label', label)),
                    if (_isEditing)
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.deepPurpleAccent),
                            onPressed: () async {
                              final text = await _showTextDialog(title: 'Rinomina attività', initialValue: label);
                              if (text != null && text.isNotEmpty) {
                                setState(() {
                                  _renameTopTask(label, text);
                                });
                                await _persistChecklist();
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.deepPurpleAccent),
                            onPressed: () {
                              setState(() {
                                _deleteTopTask(label);
                              });
                              _persistChecklist();
                            },
                          ),
                        ],
                      ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String sectionKey, String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(title),
        ...items.map((label) => _buildCheckbox('$sectionKey::$label', label)),
      ],
    );
  }
  @override
  void initState() {
    super.initState();
    // Load venues first; select a real venue before loading checklist
    _selectedVenue = null;
    _loadVenues();
  }

  @override
  void dispose() {
    _checklistSub?.cancel();
    super.dispose();
  }

  Future<void> _loadVenues() async {
    try {
      final v = await FirestoreService.getVenues();
      if (!mounted) return;
      setState(() {
        // Remove any legacy/default placeholder venues from the list
        _venues = v.where((id) => id.toLowerCase() != 'default').toList();
        _venuesLoaded = true;
        // Select a real venue if available; otherwise keep null
        if (_venues.isEmpty) {
          _selectedVenue = null;
        } else if (_selectedVenue == null || !_venues.contains(_selectedVenue)) {
          _selectedVenue = _venues.first;
        }
      });
      if (_selectedVenue != null) {
        _loadChecklistForVenue();
      }
    } catch (_) {
      // Ignore; keep default
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: appBar(context),
      drawer: drawerBurgerMenu(),
      body: body(),
      floatingActionButton: searchActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, 
    );
  }

  Drawer drawerBurgerMenu() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple
            ),
            child: Text(
              "Menu",
              style: TextStyle(
                color: Colors.white
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.storage),
            title: Text('Data-base'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Databasecomunicationpage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
            Navigator.pop(context); // 👈 close the drawer
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const app_settings.Settings()),
            );
          },

          ),
        ],
      ),
    );
  }

  SizedBox searchActionButton(BuildContext context) {
    return SizedBox(
    width: 70,
    height: 70,
    child: FloatingActionButton(
      onPressed: () {
        showSearch(
          context: context,
          delegate: CustomSearchDelegate(),
        );
      },
      backgroundColor: Colors.deepPurpleAccent, // Background color of the FAB
      foregroundColor: Colors.white, // Default color for the icon (can be overridden below)
      child: Icon(
        Icons.search,
        size: 30,            // Icon size
      ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          const Text(
            "MeMo Cocktail",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: InkWell(
              onTap: _openVenuePicker,
              borderRadius: BorderRadius.circular(999),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.place_outlined, size: 18, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _venuesLoaded
                            ? (_selectedVenue ?? 'Select venue')
                            : 'Loading venues…',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.expand_more, size: 20, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      actions: [
          PopupMenuButton<String>(
          icon: const Icon(Icons.person, color: Colors.white), 
          onSelected: (value) {
            if (value == 'logout') {
            print('Logging out...');
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'logout',
              child: Text('Log out'),
            ),
          ],
        )
      ],
      backgroundColor: Colors.deepPurpleAccent,
    );
  }

  Future<void> _addVenue() async {
    final text = await _showTextDialog(title: 'New venue');
    if (text == null) return;
    final venue = text.trim();
    if (venue.isEmpty) return;
    await FirestoreService.upsertVenues([venue]);
    setState(() {
      if (!_venues.contains(venue)) _venues.add(venue);
      _selectedVenue = venue;
      _venuesLoaded = true;
      _checked.clear();
    });
    await FirestoreService.ensureChecklist(
      venue,
      ChecklistData(
        topTasks: List<String>.from(_topTasks),
        sections: Map<String, List<String>>.from(_defaultSections),
        checked: <String>{},
      ),
    );
    _loadChecklistForVenue();
  }

  Future<void> _openVenuePicker() async {
    if (!_venuesLoaded) return;
    String filter = '';
    final controller = TextEditingController();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final visible = _venues
                .where((v) => v.toLowerCase().contains(filter.toLowerCase()))
                .toList();
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8),
                    Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Search venue',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (v) => setModalState(() => filter = v),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: visible.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final v = visible[index];
                          final selected = v == _selectedVenue;
                          return ListTile(
                            leading: const Icon(Icons.place_outlined),
                            title: Text(v),
                            trailing: selected
                                ? const Icon(Icons.check, color: Colors.deepPurpleAccent)
                                : null,
                            onTap: () {
                              Navigator.pop(context);
                              setState(() {
                                _selectedVenue = v;
                                _checked.clear();
                              });
                              _loadChecklistForVenue();
                            },
                          );
                        },
                      ),
                    ),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                _addVenue();
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Add venue'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Padding body() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: !_venuesLoaded
          ? const Center(child: CircularProgressIndicator())
          : (_selectedVenue == null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('No venue selected', style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: _openVenuePicker,
                        icon: const Icon(Icons.place_outlined),
                        label: const Text('Select venue'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Checklist",
                  style: TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    // Expand/Collapse all
                    IconButton(
                  tooltip: _expandedSections.length < _sections.length ? 'Expand all' : 'Collapse all',
                      icon: Icon(_expandedSections.length < _sections.length ? Icons.unfold_more : Icons.unfold_less),
                      onPressed: () {
                        setState(() {
                          if (_expandedSections.length < _sections.length) {
                            _expandedSections
                              ..clear()
                              ..addAll(_sections.keys);
                          } else {
                            _expandedSections.clear();
                          }
                        });
                      },
                    ),
                    // Edit toggle
                    IconButton(
                      icon: Icon(_isEditing ? Icons.check : Icons.edit),
                      tooltip: _isEditing ? 'Done editing' : 'Edit checklist',
                      onPressed: () {
                        setState(() {
                          _isEditing = !_isEditing;
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 12),

            // Filter chips
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  selected: _filter == _Filter.all,
                  label: const Text('All'),
                  onSelected: (_) => setState(() => _filter = _Filter.all),
                ),
                ChoiceChip(
                  selected: _filter == _Filter.todo,
                  label: const Text('To do'),
                  onSelected: (_) => setState(() => _filter = _Filter.todo),
                ),
                ChoiceChip(
                  selected: _filter == _Filter.done,
                  label: const Text('Done'),
                  onSelected: (_) => setState(() => _filter = _Filter.done),
                ),
              ],
            ),
            const SizedBox(height: 8),

            _buildTopTasksCard(),

            _sectionHeader('Bar checklist:'),

            // Dynamic sections as cards
            ..._sections.entries.map((e) => _buildDynamicSection(e.key, e.value)),
            if (_isEditing)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final text = await _showTextDialog(title: 'Nuova sezione');
                      if (text != null && text.isNotEmpty && !_sections.containsKey(text)) {
                        setState(() {
                          _sections[text] = [];
                        });
                        await _persistChecklist();
                      }
                    },
                    icon: const Icon(Icons.add, color: Colors.deepPurpleAccent),
                    label: const Text('Aggiungi sezione'),
                  ),
                ),
              ),

            const SizedBox(height: 12),

            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _checked.clear();
                  });
                  if (_selectedVenue != null) {
                    FirestoreService.updateChecked(_selectedVenue!, _checked);
                  }
                  _persistChecklist();
                },
                icon: const Icon(Icons.clear_all),
                label: const Text('Clear all checks'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
  Widget _buildTransparentBox({ required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:Colors.white.withAlpha((30)),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withAlpha(60)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            blurRadius: 8,
            offset: const Offset(0, 4)
          )
        ]
      ),
      child: Center(child: child),
    );
  }
}
class CustomSearchDelegate extends SearchDelegate {
  final Stream<List<Cocktail>> _cocktailsStream = FirestoreService.watchCocktails();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildResultsOrSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildResultsOrSuggestions(context);
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData baseTheme = Theme.of(context);
    return baseTheme.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.deepPurpleAccent,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white54),
        border: InputBorder.none,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }


  Widget _buildResultsOrSuggestions(BuildContext context) {
    return StreamBuilder<List<Cocktail>>(
      stream: _cocktailsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final all = snapshot.data!;
        final filteredCocktails = query.isEmpty
            ? all.take(5).toList()
            : (() {
                final lowerQuery = query.toLowerCase();
                final matches = all
                    .where((c) => c.name.toLowerCase().contains(lowerQuery))
                    .toList();
                matches.sort((a, b) {
                  final na = a.name.toLowerCase();
                  final nb = b.name.toLowerCase();
                  final ia = na.indexOf(lowerQuery);
                  final ib = nb.indexOf(lowerQuery);
                  // Priority 1: names that START with query come first
                  final pa = ia == 0 ? 0 : 1;
                  final pb = ib == 0 ? 0 : 1;
                  if (pa != pb) return pa - pb;
                  // Priority 2: earlier match position first
                  if (ia != ib) return ia - ib;
                  // Priority 3: alphabetical fallback
                  return a.name.compareTo(b.name);
                });
                return matches;
              }());

        if (filteredCocktails.isEmpty) {
          return const Center(child: Text("No cocktails found."));
        }

        return ListView.builder(
          itemCount: filteredCocktails.length,
          itemBuilder: (context, index) {
            final cocktail = filteredCocktails[index];
            final name = cocktail.name;
            final lowerQuery = query.toLowerCase();
            final matchIndex = name.toLowerCase().indexOf(lowerQuery);

            Widget titleText;
            if (matchIndex != -1 && query.isNotEmpty) {
              final beforeMatch = name.substring(0, matchIndex);
              final match = name.substring(matchIndex, matchIndex + query.length);
              final afterMatch = name.substring(matchIndex + query.length);
              titleText = RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                  children: [
                    TextSpan(text: beforeMatch),
                    TextSpan(
                      text: match,
                      style: const TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: afterMatch),
                  ],
                ),
              );
            } else {
              titleText = Text(name, style: const TextStyle(fontSize: 18));
            }

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: const Icon(Icons.local_bar, size: 30, color: Colors.deepPurple),
              title: titleText,
              subtitle: Text('${cocktail.methodology} • ${cocktail.glass}'),
              onTap: () {
                close(context, null);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CocktailDetailPage(cocktail: cocktail),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

// class CustomSearchDelegate extends SearchDelegate {
//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: const Icon(Icons.clear),
//         onPressed: () => query = '',
//       ),
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: const Icon(Icons.arrow_back),
//       onPressed: () => close(context, null),
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     return _buildResultsOrSuggestions(context);
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     return _buildResultsOrSuggestions(context);
//   }

//   Widget _buildResultsOrSuggestions(BuildContext context) {
//     final cocktailBox = Hive.box<Cocktail>('cocktails');

//     final cocktails = cocktailBox.values
//         .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
//         .toList();

//     if (cocktails.isEmpty) {
//       return const Center(child: Text("No cocktails found."));
//     }

//     return ListView.builder(
//       itemCount: cocktails.length,
//       itemBuilder: (context, index) {
//         final cocktail = cocktails[index];
//         return ListTile(
//           title: Text(cocktail.name),
//           onTap: () {
//             close(context, null);
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => CocktailDetailPage(cocktail: cocktail),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }