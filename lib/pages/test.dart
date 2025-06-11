import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/menu.dart';
import '../models/cocktail.dart';
import 'package:string_similarity/string_similarity.dart'; // Add this package to pubspec.yaml

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {

  
  Menu? selectedMenu;
  List<Cocktail> testCocktails = [];
  int currentIndex = 0;
  int score = 0;
  String _searchQuery = '';

  // User's answers for current cocktail
  String selectedMethod = '';
  String selectedGlass = '';
  String selectedIce = '';
  String selectedGarnish = '';
  final TextEditingController _ingredientsController = TextEditingController();

  // Predefined options
  final List<String> methodOptions = [
  'Stir',
  'Shaken',
  'Build',
  'Double shake',
  'Throw',
  'Batched',
  'Pour',
  'Swizzle',
  'Muddle, crushed, shaken',
  'Shaken (crushed)',
];
  
  final List<String> glassOptions = [
  'Nick & Nora',
  'Rocks',
  'Highball',
  'Coupe',
  'Thin Highball',
  'Thin Rock',
  'Flute',
  'Wine Glass',
  'Toddy Glass',
  'Coupette',
  'Bellini glass',
  'Julep tin',
  'Hurricane',
  'Atlantic Mini Martini',
  'Goblet',
];
  
  final List<String> iceOptions = [
  'Up',
  'Block',
  'Crushed',
  'Cube',
  'Ice Ball',
  'Block/2',
];
  
  final List<String> garnishOptions = [
  'Lime wheel',
  'Dehydrated Pineapple',
  'Half salt rim',
  'Cucumber slice',
  'Grapefruit twist',
  'Slice of orange bottom & one on top',
  'No garnish',
  'Long lemon peel',
  'Star anice & 3 drops of peychaud',
  'Discarded Grapefruit & Grapefruit coin',
  'Lavander Spring',
  'Lemon twist',
  'Orange Slice',
  'Orange twist',
  'Orange peel',
  'Cherry',
  'Grated Nutmeg',
  'Sugar rim & long lemon twist',
  'Lemon Wedge',
  'Two half orange wheels',
  'Flamed orange coin',
  'Dehydrate Lime',
  'Lemon wedge and straw',
  'Mint spring',
  'Mint leaf',
  'Lemon wedge',
  'Two pickled onions',
  'Olives',
  'Lemon twist and cherry',
  'Pineapple wedge & Cherry',
  '3 Drops of angostura',
  'Cherry and pineapple wedge',
  'Pineapple leaf',
  'Lime Wedge',
  'Lime wedge',
  'Sugar half-rim',
  'Red Currant on rim',
  'Coconut shard',
  'Rose Petal',
  'Sesame Oil & Ponzu sauce',
  'Shiso Leaf',
  'Dry Yuzu powder',
  '3 white grapes on stick',
  'Dehydrated Rhubarb Glued on the glass',
  'Spent half lime and mint spring',
  'A lot of mint spring',
  'Orange wheel & cherry',
  'Lemon wedge with 4 cloves and cinnamon stick',
  'Orange wedge and cherry',
  'Lemon wedge and Blackbarry',
  'No Garnish, no straw',
  'Lime wedge and straw',
  'Lemon twist or two olives',
  'Grapefruit coin',
  'Grapefruit slice',
  'Orange wedge',
  'Lemon slice',
  'Coconut Salt rim',
  'Cherry on rim',
  'Cherry on a stick',
  'Pimento olive',
  'Lemon twist discard',
  'Orange coin',
  'Mint Leaves',
];
  Widget _buildStartTest() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Test your knowledge of ${selectedMenu!.title}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            setState(() {
              final cocktailBox = Hive.box<Cocktail>('cocktails');
              testCocktails = selectedMenu!.cocktailsNames
                  .map((name) => cocktailBox.get(name))
                  .whereType<Cocktail>()
                  .toList();
              testCocktails.shuffle();
              currentIndex = 0;
              score = 0;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurpleAccent,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
          child: const Text(
            'Start Test',
            style: TextStyle(
              color: Colors.white
            ),
            ),
        ),
      ],
    ),
  );
}

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: selectedMenu != null ? AppBar(
      title: Text(
        selectedMenu!.title,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.deepPurpleAccent,
      iconTheme: const IconThemeData(color: Colors.white),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          setState(() {
            selectedMenu = null;
            testCocktails = [];
          });
        },
      ),
    ) : null,
    body: ValueListenableBuilder(
      valueListenable: Hive.box<Menu>('menus').listenable(),
      builder: (context, Box<Menu> menuBox, _) {
        if (menuBox.isEmpty) {
          return const Center(child: Text('No menus available for testing'));
        }

        if (selectedMenu == null) {
          return _buildMenuSelection(menuBox);
        }

        if (testCocktails.isEmpty) {
          return _buildStartTest();
        }

        return _buildTestQuestion();
      },
    ),
  );
}

  @override
  void dispose() {
    _ingredientsController.dispose();
    super.dispose();
  }

  // ... keep existing menu selection code ...

  Widget _buildTestQuestion() {
    final cocktail = testCocktails[currentIndex];
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Question ${currentIndex + 1}/${testCocktails.length}',
            style: const TextStyle(fontSize: 18, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            cocktail.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          _buildDropdown('Method', selectedMethod, methodOptions, (value) {
            setState(() => selectedMethod = value!);
          }),
          const SizedBox(height: 16),
          _buildDropdown('Glass', selectedGlass, glassOptions, (value) {
            setState(() => selectedGlass = value!);
          }),
          const SizedBox(height: 16),
          _buildDropdown('Ice', selectedIce, iceOptions, (value) {
            setState(() => selectedIce = value!);
          }),
          const SizedBox(height: 16),
          _buildDropdown('Garnish', selectedGarnish, garnishOptions, (value) {
            setState(() => selectedGarnish = value!);
          }),
          const SizedBox(height: 16),
          TextField(
            controller: _ingredientsController,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Ingredients (one per line with quantity)',
              hintText: 'Example:\nVodka - 50ml\nLime Juice - 25ml',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => _checkAnswer(cocktail),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Check Answer',
              style: TextStyle(color: Colors.white,
              ),
            ),          
          ),
        ],
      ),
    );
  }
  Widget _buildMenuSelection(Box<Menu> menuBox) {
    // Separate menus into categories

    final signatureMenus = menuBox.values.where((menu) =>
      menu.title.length > 1
    ).toList();
    
    final classicMenus = menuBox.values.where((menu) =>
      menu.title.length == 1 && RegExp(r'^[a-zA-Z]$').hasMatch(menu.title)
    ).toList();

    

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search menus...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (signatureMenus.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Signature Menus',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                ),
                ...signatureMenus.where((menu) => 
                  _searchQuery.isEmpty || 
                  menu.title.toLowerCase().contains(_searchQuery.toLowerCase())
                ).map((menu) => _buildMenuCard(menu)),
                const SizedBox(height: 24),
              ],
              if (classicMenus.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Classic Menus',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                ),
                ...classicMenus.where((menu) => 
                  _searchQuery.isEmpty || 
                  menu.title.toLowerCase().contains(_searchQuery.toLowerCase())
                ).map((menu) => _buildMenuCard(menu)),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuCard(Menu menu) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(menu.title),
        subtitle: Text('${menu.cocktailsNames.length} cocktails'),
        onTap: () {
          setState(() {
            selectedMenu = menu;
          });
        },
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> options, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value.isEmpty ? null : value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      isExpanded: true,
      items: options.map((String option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(
            option,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  void _checkAnswer(Cocktail cocktail) {
    // Check method, glass, ice, and garnish (exact match)
    bool methodCorrect = selectedMethod.toLowerCase() == cocktail.methodology.toLowerCase();
    bool glassCorrect = selectedGlass.toLowerCase() == cocktail.glass.toLowerCase();
    bool iceCorrect = selectedIce.toLowerCase() == cocktail.ice.toLowerCase();
    bool garnishCorrect = selectedGarnish.toLowerCase() == cocktail.garnish.toLowerCase();

    // Check ingredients using string similarity
    List<String> userIngredients = _ingredientsController.text
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .toList();
    
    List<String> correctIngredients = cocktail.ingredients
        .map((i) => '${i.name} - ${i.quantity}')
        .toList();

    // Calculate similarity score for ingredients
    double similarityScore = _calculateIngredientsSimilarity(
      userIngredients,
      correctIngredients
    );

    // Show results dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Your Answer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Method: ${methodCorrect ? '✓' : '✗'}'),
            Text('Glass: ${glassCorrect ? '✓' : '✗'}'),
            Text('Ice: ${iceCorrect ? '✓' : '✗'}'),
            Text('Garnish: ${garnishCorrect ? '✓' : '✗'}'),
            Text('Ingredients: ${(similarityScore * 100).toStringAsFixed(1)}% match'),
            const SizedBox(height: 16),
            const Text('Correct Answer:'),
            const SizedBox(height: 8),
            Text('Method: ${cocktail.methodology}'),
            Text('Glass: ${cocktail.glass}'),
            Text('Ice: ${cocktail.ice}'),
            Text('Garnish: ${cocktail.garnish}'),
            const Text('Ingredients:'),
            ...cocktail.ingredients.map((i) => Text('• ${i.name} - ${i.quantity}')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _nextQuestion();
            },
            child: const Text('Next Question'),
          ),
        ],
      ),
    );

    // Update score
    if (methodCorrect && glassCorrect && iceCorrect && garnishCorrect && similarityScore > 0.8) {
      score++;
    }
  }

  double _calculateIngredientsSimilarity(List<String> userIngredients, List<String> correctIngredients) {
    if (userIngredients.isEmpty || correctIngredients.isEmpty) return 0.0;

    double totalSimilarity = 0.0;
    for (String userIngredient in userIngredients) {
      double bestSimilarity = 0.0;
      for (String correctIngredient in correctIngredients) {
        double similarity = userIngredient.similarityTo(correctIngredient);
        if (similarity > bestSimilarity) {
          bestSimilarity = similarity;
        }
      }
      totalSimilarity += bestSimilarity;
    }

    return totalSimilarity / correctIngredients.length;
  }

  void _nextQuestion() {
    if (currentIndex < testCocktails.length - 1) {
      setState(() {
        currentIndex++;
        // Reset answers for next question
        selectedMethod = '';
        selectedGlass = '';
        selectedIce = '';
        selectedGarnish = '';
        _ingredientsController.clear();
      });
    } else {
      // Show final score
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Test Complete!'),
          content: Text(
            'Your score: $score/${testCocktails.length}\n'
            'Percentage: ${(score / testCocktails.length * 100).toStringAsFixed(1)}%',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  selectedMenu = null;
                  testCocktails = [];
                });
              },
              child: const Text('Back to Menu Selection'),
            ),
          ],
        ),
      );
    }
  }
}
