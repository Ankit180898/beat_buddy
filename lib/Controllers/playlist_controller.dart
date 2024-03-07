import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PlaylistController extends GetxController {
  late Database _database;

  @override
  void onInit() {
    super.onInit();
    _initDatabase();
  }

  void _initDatabase() async {
    final path = await getDatabasesPath();
    _database = await openDatabase(
      join(path, 'playlist_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE playlists(id INTEGER PRIMARY KEY, name TEXT, songIds TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> addPlaylist(String name, List<int> songIds) async {
    await _database.insert(
      'playlists',
      {'name': name, 'songIds': songIds.join(',')},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAllPlaylists() async {
    return await _database.query('playlists');
  }

  Future<void> deletePlaylist(int id) async {
    await _database.delete(
      'playlists',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updatePlaylist(int id, String name, List<int> songIds) async {
    await _database.update(
      'playlists',
      {'name': name, 'songIds': songIds.join(',')},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
