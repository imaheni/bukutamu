import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Model Guest (Tamu)
class Guest {
  final int? id;
  final String name;
  final String institution;
  final String purpose;
  final String recipient;
  final String phone;

  Guest({
    this.id,
    required this.name,
    required this.institution,
    required this.purpose,
    required this.recipient,
    required this.phone,
  });

  // Konversi Guest ke Map untuk SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'institution': institution,
      'purpose': purpose,
      'recipient': recipient,
      'phone': phone,
    };
  }

  // Mengonversi Map dari SQLite ke Object Guest
  static Guest fromMap(Map<String, dynamic> map) {
    return Guest(
      id: map['id'],
      name: map['name'],
      institution: map['institution'],
      purpose: map['purpose'],
      recipient: map['recipient'],
      phone: map['phone'],
    );
  }
}

// Kelas untuk Database Helper
class GuestDatabase {
  static final GuestDatabase _instance = GuestDatabase._internal();
  static Database? _database;

  factory GuestDatabase() {
    return _instance;
  }

  GuestDatabase._internal();

  // Mendapatkan instance database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inisialisasi database SQLite
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'guest_book.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE guests(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            institution TEXT,
            purpose TEXT,
            recipient TEXT,
            phone TEXT
          )
          ''',
        );
      },
    );
  }

  // Fungsi untuk memasukkan data tamu ke database
  Future<void> insertGuest(Guest guest) async {
    final db = await database;
    await db.insert(
      'guests',
      guest.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fungsi untuk mengambil semua tamu dari database
  Future<List<Guest>> getGuests() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('guests');
    return List.generate(maps.length, (i) {
      return Guest.fromMap(maps[i]);
    });
  }

  // Fungsi untuk menghapus tamu berdasarkan ID
  Future<void> deleteGuest(int id) async {
    final db = await database;
    await db.delete(
      'guests',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
