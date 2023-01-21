/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

class Investor extends _i1.TableRow {
  Investor({
    int? id,
    required this.name,
    required this.email,
    required this.password,
  }) : super(id);

  factory Investor.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Investor(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      email:
          serializationManager.deserialize<String>(jsonSerialization['email']),
      password: serializationManager
          .deserialize<String>(jsonSerialization['password']),
    );
  }

  static final t = InvestorTable();

  String name;

  String email;

  String password;

  @override
  String get tableName => 'investors';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
    };
  }

  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
    };
  }

  @override
  void setColumn(
    String columnName,
    value,
  ) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'name':
        name = value;
        return;
      case 'email':
        email = value;
        return;
      case 'password':
        password = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<Investor>> find(
    _i1.Session session, {
    InvestorExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Investor>(
      where: where != null ? where(Investor.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<Investor?> findSingleRow(
    _i1.Session session, {
    InvestorExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<Investor>(
      where: where != null ? where(Investor.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<Investor?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<Investor>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required InvestorExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Investor>(
      where: where(Investor.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    Investor row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    Investor row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    Investor row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    InvestorExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Investor>(
      where: where != null ? where(Investor.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef InvestorExpressionBuilder = _i1.Expression Function(InvestorTable);

class InvestorTable extends _i1.Table {
  InvestorTable() : super(tableName: 'investors');

  final id = _i1.ColumnInt('id');

  final name = _i1.ColumnString('name');

  final email = _i1.ColumnString('email');

  final password = _i1.ColumnString('password');

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        email,
        password,
      ];
}

@Deprecated('Use InvestorTable.t instead.')
InvestorTable tInvestor = InvestorTable();
