import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';
import '../models/mechanic_model.dart';
import '../models/booking_model.dart';
import '../models/payment_model.dart';
import '../models/review_model.dart';
import '../dev/seed_data.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  static Database? _database;

  factory LocalStorageService() => _instance;

  LocalStorageService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'mechkonect.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        username TEXT NOT NULL,
        phone TEXT NOT NULL UNIQUE,
        email TEXT,
        nin TEXT,
        permit_number TEXT,
        date_of_birth TEXT,
        gender TEXT,
        profile_picture_url TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT
      )
    ''');

    // Mechanics table
    await db.execute('''
      CREATE TABLE mechanics (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        phone TEXT NOT NULL,
        email TEXT,
        rating REAL NOT NULL DEFAULT 0,
        total_reviews INTEGER NOT NULL DEFAULT 0,
        distance REAL,
        services TEXT,
        price_range TEXT,
        verified INTEGER NOT NULL DEFAULT 0,
        profile_picture_url TEXT,
        workshop_name TEXT,
        workshop_address TEXT,
        latitude REAL,
        longitude REAL,
        is_available INTEGER NOT NULL DEFAULT 1,
        estimated_arrival_minutes INTEGER,
        specialization TEXT,
        cached_at TEXT NOT NULL
      )
    ''');

    // Bookings table
    await db.execute('''
      CREATE TABLE bookings (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        mechanic_id TEXT NOT NULL,
        mechanic_name TEXT,
        mechanic_phone TEXT,
        mechanic_photo_url TEXT,
        service_type TEXT NOT NULL,
        vehicle_model TEXT,
        special_instructions TEXT,
        cost REAL,
        status TEXT NOT NULL,
        created_at TEXT NOT NULL,
        scheduled_time TEXT,
        completed_at TEXT,
        user_latitude REAL,
        user_longitude REAL,
        user_address TEXT,
        diagnostic_answers TEXT,
        synced INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Payments table
    await db.execute('''
      CREATE TABLE payments (
        id TEXT PRIMARY KEY,
        booking_id TEXT,
        user_id TEXT NOT NULL,
        amount REAL NOT NULL,
        type TEXT NOT NULL,
        status TEXT NOT NULL,
        transaction_id TEXT,
        description TEXT,
        created_at TEXT NOT NULL,
        payment_method TEXT,
        synced INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Reviews table
    await db.execute('''
      CREATE TABLE reviews (
        id TEXT PRIMARY KEY,
        booking_id TEXT NOT NULL,
        user_id TEXT NOT NULL,
        user_name TEXT,
        user_photo_url TEXT,
        mechanic_id TEXT NOT NULL,
        rating INTEGER NOT NULL,
        comment TEXT,
        photo_urls TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT,
        synced INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Create indexes
    await db.execute('CREATE INDEX idx_bookings_user_id ON bookings(user_id)');
    await db.execute('CREATE INDEX idx_bookings_mechanic_id ON bookings(mechanic_id)');
    await db.execute('CREATE INDEX idx_bookings_status ON bookings(status)');
    await db.execute('CREATE INDEX idx_payments_user_id ON payments(user_id)');
    await db.execute('CREATE INDEX idx_reviews_mechanic_id ON reviews(mechanic_id)');

    // Seed sample users and mechanics for development
    await _seedDatabase(db);
  }

  /// Seeds the database with sample users and mechanics.
  /// Can be called on app startup or when user triggers a re-seed.
  Future<void> _seedDatabase(Database db) async {
    // Insert seed users
    for (final u in SeedData.seedUsers) {
      await db.insert('users', u, conflictAlgorithm: ConflictAlgorithm.ignore);
    }

    // Insert seed mechanics
    for (final m in SeedData.seedMechanics) {
      await db.insert('mechanics', m, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
  }

  /// Public method to re-seed the database at runtime (for debug/development).
  /// Clears existing users and mechanics, then re-inserts seed data.
  Future<void> reseedDatabase() async {
    final db = await database;
    
    // Clear existing data
    await db.delete('users');
    await db.delete('mechanics');
    
    // Re-insert seed data
    await _seedDatabase(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database migrations here
  }

  // User DAO methods
  Future<void> insertUser(UserModel user) async {
    final db = await database;
    await db.insert(
      'users',
      _userToMap(user),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<UserModel?> getUser(String id) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return _userFromMap(maps.first);
  }

  Future<UserModel?> getUserByPhone(String phone) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'phone = ?',
      whereArgs: [phone],
    );
    if (maps.isEmpty) return null;
    return _userFromMap(maps.first);
  }

  Future<void> updateUser(UserModel user) async {
    final db = await database;
    await db.update(
      'users',
      _userToMap(user),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // Mechanic DAO methods
  Future<void> insertMechanic(MechanicModel mechanic) async {
    final db = await database;
    await db.insert(
      'mechanics',
      _mechanicToMap(mechanic),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertMechanics(List<MechanicModel> mechanics) async {
    final db = await database;
    final batch = db.batch();
    for (final mechanic in mechanics) {
      batch.insert(
        'mechanics',
        _mechanicToMap(mechanic),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<MechanicModel>> getMechanics({int? limit, int? offset}) async {
    final db = await database;
    final maps = await db.query(
      'mechanics',
      limit: limit,
      offset: offset,
      orderBy: 'cached_at DESC',
    );
    return maps.map((map) => _mechanicFromMap(map)).toList();
  }

  Future<MechanicModel?> getMechanic(String id) async {
    final db = await database;
    final maps = await db.query(
      'mechanics',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return _mechanicFromMap(maps.first);
  }

  Future<List<MechanicModel>> searchMechanics(String query) async {
    final db = await database;
    final maps = await db.query(
      'mechanics',
      where: 'name LIKE ? OR workshop_name LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return maps.map((map) => _mechanicFromMap(map)).toList();
  }

  // Booking DAO methods
  Future<void> insertBooking(BookingModel booking) async {
    final db = await database;
    await db.insert(
      'bookings',
      _bookingToMap(booking),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<BookingModel>> getBookings({String? userId, BookingStatus? status}) async {
    final db = await database;
    String? where;
    List<dynamic>? whereArgs;

    if (userId != null && status != null) {
      where = 'user_id = ? AND status = ?';
      whereArgs = [userId, status.name];
    } else if (userId != null) {
      where = 'user_id = ?';
      whereArgs = [userId];
    } else if (status != null) {
      where = 'status = ?';
      whereArgs = [status.name];
    }

    final maps = await db.query(
      'bookings',
      where: where,
      whereArgs: whereArgs,
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => _bookingFromMap(map)).toList();
  }

  Future<BookingModel?> getBooking(String id) async {
    final db = await database;
    final maps = await db.query(
      'bookings',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return _bookingFromMap(maps.first);
  }

  Future<void> updateBooking(BookingModel booking) async {
    final db = await database;
    await db.update(
      'bookings',
      _bookingToMap(booking),
      where: 'id = ?',
      whereArgs: [booking.id],
    );
  }

  // Payment DAO methods
  Future<void> insertPayment(PaymentModel payment) async {
    final db = await database;
    await db.insert(
      'payments',
      _paymentToMap(payment),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<PaymentModel>> getPayments(String userId) async {
    final db = await database;
    final maps = await db.query(
      'payments',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => _paymentFromMap(map)).toList();
  }

  // Review DAO methods
  Future<void> insertReview(ReviewModel review) async {
    final db = await database;
    await db.insert(
      'reviews',
      _reviewToMap(review),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ReviewModel>> getReviews(String mechanicId) async {
    final db = await database;
    final maps = await db.query(
      'reviews',
      where: 'mechanic_id = ?',
      whereArgs: [mechanicId],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => _reviewFromMap(map)).toList();
  }

  // Helper methods to convert between models and maps
  Map<String, dynamic> _userToMap(UserModel user) {
    return {
      'id': user.id,
      'username': user.username,
      'phone': user.phone,
      'email': user.email,
      'nin': user.nin,
      'permit_number': user.permitNumber,
      'date_of_birth': user.dateOfBirth?.toIso8601String(),
      'gender': user.gender,
      'profile_picture_url': user.profilePictureUrl,
      'created_at': user.createdAt.toIso8601String(),
      'updated_at': user.updatedAt?.toIso8601String(),
    };
  }

  UserModel _userFromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      username: map['username'],
      phone: map['phone'],
      email: map['email'],
      nin: map['nin'],
      permitNumber: map['permit_number'],
      dateOfBirth: map['date_of_birth'] != null
          ? DateTime.parse(map['date_of_birth'])
          : null,
      gender: map['gender'],
      profilePictureUrl: map['profile_picture_url'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> _mechanicToMap(MechanicModel mechanic) {
    return {
      'id': mechanic.id,
      'name': mechanic.name,
      'phone': mechanic.phone,
      'email': mechanic.email,
      'rating': mechanic.rating,
      'total_reviews': mechanic.totalReviews,
      'distance': mechanic.distance,
      'services': mechanic.services.join(','),
      'price_range': mechanic.priceRange,
      'verified': mechanic.verified ? 1 : 0,
      'profile_picture_url': mechanic.profilePictureUrl,
      'workshop_name': mechanic.workshopName,
      'workshop_address': mechanic.workshopAddress,
      'latitude': mechanic.latitude,
      'longitude': mechanic.longitude,
      'is_available': mechanic.isAvailable ? 1 : 0,
      'estimated_arrival_minutes': mechanic.estimatedArrivalMinutes,
      'specialization': mechanic.specialization,
      'cached_at': DateTime.now().toIso8601String(),
    };
  }

  MechanicModel _mechanicFromMap(Map<String, dynamic> map) {
    return MechanicModel(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      rating: map['rating']?.toDouble() ?? 0.0,
      totalReviews: map['total_reviews'] ?? 0,
      distance: map['distance']?.toDouble(),
      services: map['services'] != null
          ? (map['services'] as String).split(',')
          : [],
      priceRange: map['price_range'],
      verified: map['verified'] == 1,
      profilePictureUrl: map['profile_picture_url'],
      workshopName: map['workshop_name'],
      workshopAddress: map['workshop_address'],
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      isAvailable: map['is_available'] == 1,
      estimatedArrivalMinutes: map['estimated_arrival_minutes'],
      specialization: map['specialization'],
    );
  }

  Map<String, dynamic> _bookingToMap(BookingModel booking) {
    return {
      'id': booking.id,
      'user_id': booking.userId,
      'mechanic_id': booking.mechanicId,
      'mechanic_name': booking.mechanicName,
      'mechanic_phone': booking.mechanicPhone,
      'mechanic_photo_url': booking.mechanicPhotoUrl,
      'service_type': booking.serviceType.name,
      'vehicle_model': booking.vehicleModel,
      'special_instructions': booking.specialInstructions,
      'cost': booking.cost,
      'status': booking.status.name,
      'created_at': booking.createdAt.toIso8601String(),
      'scheduled_time': booking.scheduledTime?.toIso8601String(),
      'completed_at': booking.completedAt?.toIso8601String(),
      'user_latitude': booking.userLatitude,
      'user_longitude': booking.userLongitude,
      'user_address': booking.userAddress,
      'diagnostic_answers': booking.diagnosticAnswers != null
          ? jsonEncode(booking.diagnosticAnswers)
          : null,
      'synced': 0,
    };
  }

  BookingModel _bookingFromMap(Map<String, dynamic> map) {
    return BookingModel(
      id: map['id'],
      userId: map['user_id'],
      mechanicId: map['mechanic_id'],
      mechanicName: map['mechanic_name'],
      mechanicPhone: map['mechanic_phone'],
      mechanicPhotoUrl: map['mechanic_photo_url'],
      serviceType: ServiceType.values.firstWhere(
        (e) => e.name == map['service_type'],
      ),
      vehicleModel: map['vehicle_model'],
      specialInstructions: map['special_instructions'],
      cost: map['cost']?.toDouble(),
      status: BookingStatus.values.firstWhere(
        (e) => e.name == map['status'],
      ),
      createdAt: DateTime.parse(map['created_at']),
      scheduledTime: map['scheduled_time'] != null
          ? DateTime.parse(map['scheduled_time'])
          : null,
      completedAt: map['completed_at'] != null
          ? DateTime.parse(map['completed_at'])
          : null,
      userLatitude: map['user_latitude']?.toDouble(),
      userLongitude: map['user_longitude']?.toDouble(),
      userAddress: map['user_address'],
      diagnosticAnswers: map['diagnostic_answers'] != null
          ? jsonDecode(map['diagnostic_answers'])
          : null,
    );
  }

  Map<String, dynamic> _paymentToMap(PaymentModel payment) {
    return {
      'id': payment.id,
      'booking_id': payment.bookingId,
      'user_id': payment.userId,
      'amount': payment.amount,
      'type': payment.type.name,
      'status': payment.status.name,
      'transaction_id': payment.transactionId,
      'description': payment.description,
      'created_at': payment.createdAt.toIso8601String(),
      'payment_method': payment.paymentMethod,
      'synced': 0,
    };
  }

  PaymentModel _paymentFromMap(Map<String, dynamic> map) {
    return PaymentModel(
      id: map['id'],
      bookingId: map['booking_id'],
      userId: map['user_id'],
      amount: map['amount']?.toDouble() ?? 0.0,
      type: TransactionType.values.firstWhere(
        (e) => e.name == map['type'],
      ),
      status: PaymentStatus.values.firstWhere(
        (e) => e.name == map['status'],
      ),
      transactionId: map['transaction_id'],
      description: map['description'],
      createdAt: DateTime.parse(map['created_at']),
      paymentMethod: map['payment_method'],
    );
  }

  Map<String, dynamic> _reviewToMap(ReviewModel review) {
    return {
      'id': review.id,
      'booking_id': review.bookingId,
      'user_id': review.userId,
      'user_name': review.userName,
      'user_photo_url': review.userPhotoUrl,
      'mechanic_id': review.mechanicId,
      'rating': review.rating,
      'comment': review.comment,
      'photo_urls': review.photoUrls?.join(','),
      'created_at': review.createdAt.toIso8601String(),
      'updated_at': review.updatedAt?.toIso8601String(),
      'synced': 0,
    };
  }

  ReviewModel _reviewFromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id'],
      bookingId: map['booking_id'],
      userId: map['user_id'],
      userName: map['user_name'],
      userPhotoUrl: map['user_photo_url'],
      mechanicId: map['mechanic_id'],
      rating: map['rating'],
      comment: map['comment'],
      photoUrls: map['photo_urls'] != null
          ? (map['photo_urls'] as String).split(',')
          : null,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'])
          : null,
    );
  }
}

