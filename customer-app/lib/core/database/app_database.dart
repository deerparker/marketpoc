import 'dart:convert';
import 'package:drift/drift.dart';
import 'connection/connection.dart'
    if (dart.library.io) 'connection/native.dart'
    if (dart.library.html) 'connection/web.dart'
    if (dart.library.js_interop) 'connection/web.dart';

import '../../features/financial_events/models/financial_event.dart';

part 'app_database.g.dart';

class ListTodoConverter extends TypeConverter<List<TodoItem>, String> {
  const ListTodoConverter();
  @override
  List<TodoItem> fromSql(String fromDb) {
    if (fromDb.isEmpty) return [];
    final List<dynamic> json = jsonDecode(fromDb);
    return json.map((e) => TodoItem.fromJson(e)).toList();
  }

  @override
  String toSql(List<TodoItem> value) {
    return jsonEncode(value.map((e) => e.toJson()).toList());
  }
}

class ListGuideConverter extends TypeConverter<List<Guide>, String> {
  const ListGuideConverter();
  @override
  List<Guide> fromSql(String fromDb) {
    if (fromDb.isEmpty) return [];
    final List<dynamic> json = jsonDecode(fromDb);
    return json.map((e) => Guide.fromJson(e)).toList();
  }

  @override
  String toSql(List<Guide> value) {
    return jsonEncode(value.map((e) => e.toJson()).toList());
  }
}

class FinancialEventTypeConverter
    extends TypeConverter<FinancialEventType, String> {
  const FinancialEventTypeConverter();

  @override
  FinancialEventType fromSql(String fromDb) {
    return FinancialEventType.values.firstWhere(
      (e) => e.toString() == fromDb,
      orElse: () => FinancialEventType.buyingHouse,
    );
  }

  @override
  String toSql(FinancialEventType value) {
    return value.toString();
  }
}

class LifeEvents extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get type => text().map(const FinancialEventTypeConverter())();
  DateTimeColumn get date => dateTime()();
  TextColumn get location => text()();
  TextColumn get selectedTodos => text().map(const ListTodoConverter())();
  TextColumn get guides => text().map(const ListGuideConverter())();
  RealColumn get budget => real().nullable()();
  RealColumn get depositAmount => real().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class OwnedProducts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get type => text()(); // 'loan', 'credit_card', 'savings'
  RealColumn get amount => real().nullable()(); // Loan amount, Credit limit
  RealColumn get balance => real().nullable()();
  RealColumn get interestRate => real().nullable()();
  DateTimeColumn get startDate => dateTime()();
}

@DriftDatabase(tables: [OwnedProducts, LifeEvents])
class AppDatabase extends _$AppDatabase {
  AppDatabase({String dbName = 'db'}) : super(openConnection(dbName));

  @override
  int get schemaVersion => 2; // Incremented version

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(lifeEvents);
        }
      },
    );
  }

  // READ
  Stream<List<OwnedProduct>> watchOwnedProducts() {
    return select(ownedProducts).watch();
  }

  Future<List<OwnedProduct>> getAllOwnedProducts() {
    return select(ownedProducts).get();
  }

  // Life Events CRUD
  Stream<List<LifeEvent>> watchLifeEvents() {
    return select(lifeEvents).watch();
  }

  Future<int> addLifeEvent(LifeEventsCompanion entry) {
    return into(lifeEvents).insert(entry, mode: InsertMode.replace);
  }

  Future<bool> updateLifeEvent(LifeEvent entry) {
    return update(lifeEvents).replace(entry);
  }

  Future<int> deleteLifeEvent(String id) {
    return (delete(lifeEvents)..where((t) => t.id.equals(id))).go();
  }

  // CREATE
  Future<int> addOwnedProduct(OwnedProductsCompanion entry) {
    return into(ownedProducts).insert(entry);
  }

  // UPDATE
  Future<int> updateOwnedProduct(
    int id, {
    String? name,
    double? balance,
    double? amount,
    double? interestRate,
  }) {
    return (update(ownedProducts)..where((t) => t.id.equals(id))).write(
      OwnedProductsCompanion(
        name: name != null ? Value(name) : const Value.absent(),
        balance: balance != null ? Value(balance) : const Value.absent(),
        amount: amount != null ? Value(amount) : const Value.absent(),
        interestRate: interestRate != null
            ? Value(interestRate)
            : const Value.absent(),
      ),
    );
  }

  // DELETE
  Future<int> deleteOwnedProduct(int id) {
    return (delete(ownedProducts)..where((t) => t.id.equals(id))).go();
  }
}
