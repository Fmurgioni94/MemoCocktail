import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/menu.dart';
import '../models/cocktail.dart';

// Menus that should always be treated as Signature (case-insensitive title match)
const Set<String> kSignatureMenuTitleOverrides = {
  'attic',
  'circle & parlour',
  'negroni menu',
  'sushi',
  'tavern',
  'terrace',
  'virgin & low abv',
  'weekly selection',
};

class Training extends StatelessWidget {
  const Training({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Training',
            style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.deepPurpleAccent,
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.star, color: Colors.white), text: 'Signature'),
              Tab(icon: Icon(Icons.menu_book, color: Colors.white), text: 'Classics A–Z'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _SignatureMenusTab(),
            _ClassicsByLetterTab(),
          ],
        ),
      ),
    );
  }
}

class _SignatureMenusTab extends StatefulWidget {
  const _SignatureMenusTab();

  @override
  State<_SignatureMenusTab> createState() => _SignatureMenusTabState();
}

class _SignatureMenusTabState extends State<_SignatureMenusTab> {
  String? _selectedMenuTitle;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Menu>>(
      stream: FirestoreService.watchMenus(),
      builder: (context, menuSnap) {
        if (!menuSnap.hasData) return const Center(child: CircularProgressIndicator());
        final menus = menuSnap.data!;
        return StreamBuilder<List<Cocktail>>(
          stream: FirestoreService.watchCocktails(),
          builder: (context, cockSnap) {
            if (!cockSnap.hasData) return const Center(child: CircularProgressIndicator());
            final cocktails = cockSnap.data!;

            bool isSignatureMenu(Menu m) {
              if (kSignatureMenuTitleOverrides.contains(m.title.toLowerCase())) return true;
              final set = m.cocktailsNames.toSet();
              final inMenu = cocktails.where((c) => set.contains(c.name)).toList();
              return inMenu.any((c) => c.levelTag.toLowerCase().contains('signature'));
            }

            final sigMenus = menus.where(isSignatureMenu).toList();
            if (sigMenus.isEmpty) return const Center(child: Text('No signature menus'));

            _selectedMenuTitle ??= sigMenus.first.title;
            final selected = sigMenus.firstWhere((m) => m.title == _selectedMenuTitle, orElse: () => sigMenus.first);
            final set = selected.cocktailsNames.toSet();
            // Show ALL cocktails of the selected signature menu (classification handled by menu selection)
            final list = cocktails.where((c) => set.contains(c.name)).toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.deepPurpleAccent.withOpacity(0.2)),
                            ),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: _selectedMenuTitle,
                              items: sigMenus
                                  .map((m) => DropdownMenuItem<String>(value: m.title, child: Text(m.title)))
                                  .toList(),
                              onChanged: (v) => setState(() => _selectedMenuTitle = v),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: list.isEmpty
                      ? const Center(child: Text('No signature cocktails in this menu'))
                      : ListView.separated(
                          itemCount: list.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (_, i) => ListTile(
                            leading: const Icon(Icons.local_bar, color: Colors.deepPurpleAccent),
                            title: Text(list[i].name),
                            subtitle: Text('${list[i].methodology} • ${list[i].glass}'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => _FlashcardsPage(title: selected.title, cocktails: list)),
                            ),
                          ),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _ClassicsByLetterTab extends StatefulWidget {
  const _ClassicsByLetterTab();

  @override
  State<_ClassicsByLetterTab> createState() => _ClassicsByLetterTabState();
}

class _ClassicsByLetterTabState extends State<_ClassicsByLetterTab> {
  String? _selectedMenuTitle;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Menu>>(
      stream: FirestoreService.watchMenus(),
      builder: (context, menuSnap) {
        if (!menuSnap.hasData) return const Center(child: CircularProgressIndicator());
        final menus = menuSnap.data!;
        return StreamBuilder<List<Cocktail>>(
          stream: FirestoreService.watchCocktails(),
          builder: (context, cockSnap) {
            if (!cockSnap.hasData) return const Center(child: CircularProgressIndicator());
            final cocktails = cockSnap.data!;

            bool isSignatureMenu(Menu m) {
              if (kSignatureMenuTitleOverrides.contains(m.title.toLowerCase())) return true;
              final set = m.cocktailsNames.toSet();
              final inMenu = cocktails.where((c) => set.contains(c.name)).toList();
              return inMenu.any((c) => c.levelTag.toLowerCase().contains('signature'));
            }

            final classicMenus = menus.where((m) => !isSignatureMenu(m)).toList();
            if (classicMenus.isEmpty) return const Center(child: Text('No classic menus'));

            _selectedMenuTitle ??= classicMenus.first.title;
            final selected = classicMenus.firstWhere((m) => m.title == _selectedMenuTitle, orElse: () => classicMenus.first);
            final set = selected.cocktailsNames.toSet();
            // Show ALL cocktails belonging to the classic menu (menu already filtered to classics)
            final list = cocktails.where((c) => set.contains(c.name)).toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.deepPurpleAccent.withOpacity(0.2)),
                            ),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: _selectedMenuTitle,
                              items: classicMenus
                                  .map((m) => DropdownMenuItem<String>(value: m.title, child: Text(m.title)))
                                  .toList(),
                              onChanged: (v) => setState(() => _selectedMenuTitle = v),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: list.isEmpty
                      ? const Center(child: Text('No classics in this menu'))
                      : ListView.separated(
                          itemCount: list.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (_, i) => ListTile(
                            leading: const Icon(Icons.local_bar, color: Colors.deepPurpleAccent),
                            title: Text(list[i].name),
                            subtitle: Text('${list[i].methodology} • ${list[i].glass}'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => _FlashcardsPage(title: selected.title, cocktails: list)),
                            ),
                          ),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _FlashcardsPage extends StatefulWidget {
  final String title;
  final List<Cocktail> cocktails;
  const _FlashcardsPage({required this.title, required this.cocktails});

  @override
  State<_FlashcardsPage> createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends State<_FlashcardsPage> {
  final PageController _pageController = PageController();
  final ValueNotifier<bool> _showBack = ValueNotifier<bool>(false);
  final Map<int, bool> _answers = {};
  bool _shuffle = false;
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    _showBack.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final list = _shuffle ? (widget.cocktails.toList()..shuffle()) : widget.cocktails;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurpleAccent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFFF6F1FF),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                FilterChip(
                  selected: _shuffle,
                  label: const Text('Shuffle'),
                  onSelected: (s) {
                    setState(() => _shuffle = s);
                    _pageController.jumpToPage(0);
                    _showBack.value = false;
                    _answers.clear();
                    _currentIndex = 0;
                  },
                ),
                const SizedBox(width: 12),
                Chip(
                  avatar: const Icon(Icons.checklist, size: 18, color: Colors.white),
                  label: Text('${_answers.length}/${list.length}'),
                  backgroundColor: Colors.deepPurpleAccent,
                  labelStyle: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: list.length,
              onPageChanged: (i) {
                _showBack.value = false;
                setState(() => _currentIndex = i);
              },
              itemBuilder: (_, i) => _FlashCard(cocktail: list[i], showBack: _showBack),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, size: 28, color: Colors.deepPurpleAccent),
                      onPressed: () {
                        final prev = (_pageController.page ?? 0).floor() - 1;
                        if (prev >= 0) {
                          _pageController.animateToPage(prev, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
                        }
                      },
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: _showBack,
                      builder: (_, isBack, __) => ElevatedButton.icon(
                        onPressed: () => _showBack.value = !isBack,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent, foregroundColor: Colors.white),
                        icon: const Icon(Icons.flip),
                        label: Text(isBack ? 'Show Front' : 'Show Back'),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right, size: 28, color: Colors.deepPurpleAccent),
                      onPressed: () {
                        final next = (_pageController.page ?? 0).floor() + 1;
                        if (next < list.length) {
                          _pageController.animateToPage(next, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _answers[_currentIndex] = true;
                          if (_currentIndex == list.length - 1) {
                            _showResults(list);
                          } else {
                            _pageController.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
                          }
                        },
                        icon: const Icon(Icons.thumb_up_alt_outlined),
                        label: const Text('I knew it'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _answers[_currentIndex] = false;
                          if (_currentIndex == list.length - 1) {
                            _showResults(list);
                          } else {
                            _pageController.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
                          }
                        },
                        icon: const Icon(Icons.thumb_down_alt_outlined),
                        label: const Text("I didn't know"),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: _answers.isEmpty ? null : () => _showResults(list),
                  icon: const Icon(Icons.bar_chart),
                  label: const Text('View results'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showResults(List<Cocktail> cocktails) {
    final total = cocktails.length;
    final known = _answers.values.where((v) => v == true).length;
    final unknown = total - known;
    final missed = <Cocktail>[];
    for (int i = 0; i < total; i++) {
      if (_answers[i] != true) missed.add(cocktails[i]);
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.bar_chart, color: Colors.deepPurpleAccent),
                    const SizedBox(width: 8),
                    Text('Result: $known / $total', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Chip(label: Text('Correct: $known'), backgroundColor: Colors.green.withOpacity(0.15)),
                    const SizedBox(width: 8),
                    Chip(label: Text('Incorrect: $unknown'), backgroundColor: Colors.redAccent.withOpacity(0.15)),
                  ],
                ),
                const SizedBox(height: 12),
                if (missed.isNotEmpty) const Text('To review:', style: TextStyle(fontWeight: FontWeight.w700)),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: missed.length,
                    itemBuilder: (_, i) => ListTile(
                      leading: const Icon(Icons.local_bar, color: Colors.deepPurpleAccent),
                      title: Text(missed[i].name),
                      subtitle: Text('${missed[i].methodology} • ${missed[i].glass}'),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close),
                        label: const Text('Close'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            _answers.clear();
                            _currentIndex = 0;
                          });
                          _pageController.jumpToPage(0);
                          _showBack.value = false;
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent, foregroundColor: Colors.white),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Restart'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FlashCard extends StatelessWidget {
  final Cocktail cocktail;
  final ValueNotifier<bool> showBack;
  const _FlashCard({required this.cocktail, required this.showBack});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => showBack.value = !showBack.value,
        child: ValueListenableBuilder<bool>(
          valueListenable: showBack,
          builder: (context, isBack, _) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
              child: Container(
                key: ValueKey(isBack),
                width: MediaQuery.of(context).size.width - 32,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 6)),
                  ],
                  border: Border.all(color: Colors.deepPurpleAccent.withOpacity(0.15)),
                ),
                child: isBack ? _back() : _front(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _front() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.local_bar, size: 40, color: Colors.deepPurpleAccent),
        const SizedBox(height: 12),
        Text(
          cocktail.name,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        const Text('Tap to flip', style: TextStyle(color: Colors.black54)),
      ],
    );
  }

  Widget _back() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.science_outlined, color: Colors.deepPurpleAccent),
              const SizedBox(width: 6),
              Text(cocktail.methodology),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.wine_bar, color: Colors.deepPurpleAccent),
              const SizedBox(width: 6),
              Text(cocktail.glass),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.ac_unit_outlined, color: Colors.deepPurpleAccent),
              const SizedBox(width: 6),
              Text(cocktail.ice),
            ],
          ),
          const SizedBox(height: 8),
          if (cocktail.garnish.isNotEmpty)
            Row(
              children: [
                const Icon(Icons.spa_outlined, color: Colors.deepPurpleAccent),
                const SizedBox(width: 6),
                Expanded(child: Text(cocktail.garnish)),
              ],
            ),
          const SizedBox(height: 12),
          const Text('Ingredients', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          ...cocktail.ingredients.map((ing) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    const Icon(Icons.circle, size: 6, color: Colors.deepPurpleAccent),
                    const SizedBox(width: 8),
                    Expanded(child: Text('${ing.name} — ${ing.quantity}')),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}