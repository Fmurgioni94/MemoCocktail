import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cocktail.dart';
import '../models/menu.dart';
import '../models/checklist.dart';

class FirestoreService {
  FirestoreService._();
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Collections
  static CollectionReference<Map<String, dynamic>> get _cocktailsCol =>
      _db.collection('cocktails');
  static CollectionReference<Map<String, dynamic>> get _menusCol =>
      _db.collection('menus');
  static DocumentReference<Map<String, dynamic>> _venueDoc(String venueId) =>
      _db.collection('venues').doc(venueId);
  // Checklist is stored directly on the venue document (root fields)
  static DocumentReference<Map<String, dynamic>> _venueChecklistDoc(String venueId) =>
      _venueDoc(venueId);

  static String _safeDocId(String id) => id.replaceAll('/', '-');

  // Cocktails
  static Stream<List<Cocktail>> watchCocktails() {
    return _cocktailsCol
        .orderBy('name')
        .snapshots()
        .map((s) => s.docs.map((d) => Cocktail.fromMap(d.data())).toList());
  }

  static Future<void> upsertCocktail(Cocktail cocktail) async {
    await _cocktailsCol.doc(_safeDocId(cocktail.name)).set(cocktail.toMap(), SetOptions(merge: true));
  }

  static Future<void> upsertCocktailsBatch(List<Cocktail> cocktails) async {
    const int maxBatchSize = 500; // Firestore limit
    for (int i = 0; i < cocktails.length; i += maxBatchSize) {
      final int end = (i + maxBatchSize) > cocktails.length ? cocktails.length : (i + maxBatchSize);
      final slice = cocktails.sublist(i, end);
      final batch = _db.batch();
      for (final cocktail in slice) {
        final docRef = _cocktailsCol.doc(_safeDocId(cocktail.name));
        batch.set(docRef, cocktail.toMap(), SetOptions(merge: true));
      }
      await batch.commit();
    }
  }

  static Future<bool> cocktailsCollectionIsEmpty() async {
    final snap = await _cocktailsCol.limit(1).get();
    return snap.size == 0;
  }

  static Future<Set<String>> getExistingCocktailNames() async {
    final snap = await _cocktailsCol.get();
    final names = <String>{};
    for (final d in snap.docs) {
      final data = d.data();
      final name = data['name'] as String?;
      names.add((name == null || name.isEmpty) ? d.id : name);
    }
    return names;
  }

  static Future<void> deleteCocktailByName(String name) async {
    await _cocktailsCol.doc(_safeDocId(name)).delete();
  }

  static Future<Cocktail?> getCocktailByName(String name) async {
    final doc = await _cocktailsCol.doc(_safeDocId(name)).get();
    if (!doc.exists) return null;
    return Cocktail.fromMap(doc.data()!);
  }

  // Menus
  static Stream<List<Menu>> watchMenus() {
    return _menusCol
        .orderBy('title')
        .snapshots()
        .map((s) => s.docs.map((d) => Menu.fromMap(d.data())).toList());
  }

  static Future<void> upsertMenu(Menu menu) async {
    await _menusCol.doc(menu.title).set(menu.toMap(), SetOptions(merge: true));
  }

  static Future<void> deleteMenuByTitle(String title) async {
    await _menusCol.doc(title).delete();
  }

  static Future<Menu?> getMenuByTitle(String title) async {
    final doc = await _menusCol.doc(title).get();
    if (!doc.exists) return null;
    return Menu.fromMap(doc.data()!);
  }
  // Checklist per venue
  static Stream<ChecklistData?> watchChecklist(String venueId) {
    return _venueChecklistDoc(venueId).snapshots().map((snap) {
      if (!snap.exists) return null;
      return ChecklistData.fromMap(snap.data()!);
    });
  }

  static Future<void> saveChecklist(String venueId, ChecklistData data) async {
    await _venueChecklistDoc(venueId).set(data.toMap(), SetOptions(merge: true));
  }

  static Future<void> updateChecked(String venueId, Set<String> checked) async {
    await _venueChecklistDoc(venueId).set({'checked': checked.toList()}, SetOptions(merge: true));
  }

  static Future<void> ensureChecklist(String venueId, ChecklistData defaultData) async {
    final doc = await _venueChecklistDoc(venueId).get();
    if (!doc.exists) {
      await _venueChecklistDoc(venueId).set(defaultData.toMap(), SetOptions(merge: true));
    }
  }

  static Future<List<String>> getVenues() async {
    final snap = await _db.collection('venues').get();
    return snap.docs.map((d) => d.id).toList();
  }

  static Future<void> upsertVenues(List<String> venueIds) async {
    if (venueIds.isEmpty) return;
    final batch = _db.batch();
    for (final v in venueIds) {
      final doc = _db.collection('venues').doc(v);
      batch.set(doc, {'name': v}, SetOptions(merge: true));
    }
    await batch.commit();
  }
}



