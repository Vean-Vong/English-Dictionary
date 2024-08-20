import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppState extends GetxController {
  var list = [].obs;
  var definition = "".obs;
  var word = "".obs;
  var partOfSpeech = "".obs;
  var englishPhonetic = "".obs;
  var khmerPhonetic = "".obs;
  var history = <Map<String, dynamic>>[].obs;
  var bookmarks = <Map<String, dynamic>>[].obs;

  late Database database;

  @override
  void onInit() {
    super.onInit();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    try {
      database = await openDatabase(
        join(await getDatabasesPath(), 'dictionary.db'),
        onCreate: (db, version) {
          db.execute(
            "CREATE TABLE IF NOT EXISTS history(id INTEGER PRIMARY KEY AUTOINCREMENT, englishword TEXT, khmerdef TEXT)",
          );
          db.execute(
            "CREATE TABLE IF NOT EXISTS bookmarks(id INTEGER PRIMARY KEY AUTOINCREMENT, englishword TEXT, khmerdef TEXT)",
          );
        },
        version: 1,
      );
      await loadHistory();
      await loadBookmarks();
    } catch (e) {
      print("Error initializing database: $e");
    }
  }

  Future<void> loadHistory() async {
    try {
      final List<Map<String, dynamic>> maps = await database.query('history');
      history.assignAll(maps);
    } catch (e) {
      print("Error loading history: $e");
    }
  }

  Future<void> addHistory(Map<String, dynamic> item) async {
    try {
      await database.insert(
        'history',
        {
          'englishword': item['englishword'],
          'khmerdef': item['khmerdef'],
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      await loadHistory();
    } catch (e) {
      print("Error adding to history: $e");
    }
  }

  Future<void> removeHistory(Map<String, dynamic> item) async {
    try {
      await database.delete(
        'history',
        where: "id = ?",
        whereArgs: [item['id']],
      );
      await loadHistory();
    } catch (e) {
      print("Error removing from history: $e");
    }
  }

  Future<void> loadBookmarks() async {
    try {
      final List<Map<String, dynamic>> maps = await database.query('bookmarks');
      bookmarks.assignAll(maps);
    } catch (e) {
      print("Error loading bookmarks: $e");
    }
  }

  Future<void> saveBookmark(Map<String, dynamic> item) async {
    try {
      await database.insert(
        'bookmarks',
        {
          'englishword': item['englishword'],
          'khmerdef': item['khmerdef'],
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      await loadBookmarks();
    } catch (e) {
      print("Error saving bookmark: $e");
    }
  }

  Future<void> removeBookmark(Map<String, dynamic> item) async {
    try {
      await database.delete(
        'bookmarks',
        where: "englishword = ?",
        whereArgs: [item['englishword']],
      );
      await loadBookmarks();
    } catch (e) {
      print("Error removing bookmark: $e");
    }
  }

  void toggleBookmark(Map<String, dynamic> item) {
    if (isBookmarked(item)) {
      removeBookmark(item);
    } else {
      saveBookmark(item);
    }
  }

  bool isBookmarked(Map<String, dynamic> item) {
    return bookmarks
        .any((bookmark) => bookmark['englishword'] == item['englishword']);
  }
  
  void clearHistory() async {
    // Clear the in-memory list
    history.clear();
    // Clear the history from the database
    await database.delete('history');
  }

  void clearBookmark() async {
    // Clear the in-memory list
    bookmarks.clear();
    // Clear the history from the database
    await database.delete('bookmarks');
  }

}
