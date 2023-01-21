/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

class StartUp extends _i1.TableRow {
  StartUp({
    int? id,
    required this.name,
    required this.email,
    required this.password,
  }) : super(id);

  factory StartUp.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return StartUp(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      email:
          serializationManager.deserialize<String>(jsonSerialization['email']),
      password: serializationManager
          .deserialize<String>(jsonSerialization['password']),
    );
  }

  static final t = StartUpTable();

  String name;

  String email;

  String password;

  @override
  String get tableName => 'startups';
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

  static Future<List<StartUp>> find(
    _i1.Session session, {
    StartUpExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<StartUp>(
      where: where != null ? where(StartUp.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<StartUp?> findSingleRow(
    _i1.Session session, {
    StartUpExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<StartUp>(
      where: where != null ? where(StartUp.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<StartUp?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<StartUp>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required StartUpExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<StartUp>(
      where: where(StartUp.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    StartUp row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    StartUp row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    StartUp row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    StartUpExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<StartUp>(
      where: where != null ? where(StartUp.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef StartUpExpressionBuilder = _i1.Expression Function(StartUpTable);

class StartUpTable extends _i1.Table {
  StartUpTable() : super(tableName: 'startups');

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

@Deprecated('Use StartUpTable.t instead.')
StartUpTable tStartUp = StartUpTable();
