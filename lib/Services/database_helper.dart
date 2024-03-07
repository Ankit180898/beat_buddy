import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static const String playlistTable = 'playlist';
  static const String songTable = 'song';

  // Initialize database
  static Future<void> initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'playlist_database.db'),
      onCreate: (db, version) async {
        await db.execute(
          '''CREATE TABLE $playlistTable(id INTEGER PRIMARY KEY, name TEXT)''',
        );
        await db.execute(
          '''CREATE TABLE $songTable(id INTEGER PRIMARY KEY, name TEXT, playlist_id INTEGER, FOREIGN KEY (playlist_id) REFERENCES $playlistTable(id))''',
        );
      },
      version: 1,
    );
  }

  // Add new playlist
  static Future<void> addPlaylist(String name) async {
    final db = await _getDatabase();
    await db.insert(
      playlistTable,
      {'name': name},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all playlists
  static Future<List<Map<String, dynamic>>> getAllPlaylists() async {
    final db = await _getDatabase();
    return db.query(playlistTable);
  }

  // Add song to playlist
  static Future<void> addSongToPlaylist(int playlistId, String songName) async {
    final db = await _getDatabase();
    await db.insert(
      songTable,
      {'name': songName, 'playlist_id': playlistId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all songs in a playlist
  static Future<List<Map<String, dynamic>>> getSongsInPlaylist(int playlistId) async {
    final db = await _getDatabase();
    return db.query(
      songTable,
      where: 'playlist_id = ?',
      whereArgs: [playlistId],
    );
  }
  static Future<void> renamePlaylist(int playlistId, String newName) async {
    final db = await _getDatabase();
    await db.update(
      playlistTable,
      {'name': newName},
      where: 'id = ?',
      whereArgs: [playlistId],
    );
  }


  // Helper function to get the database instance
  static Future<Database> _getDatabase() async {
    if (_database == null) {
      await initDatabase();
    }
    return _database!;
  }
}


