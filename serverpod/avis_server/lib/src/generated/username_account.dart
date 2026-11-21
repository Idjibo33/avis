/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'package:serverpod/serverpod.dart' as _is;

/// Compte applicatif « pseudo + mot de passe », sans email.
/// Le champ `authUserId` est l'UUID de l'utilisateur anonyme existant :
/// l'élévation ne crée pas de nouvel utilisateur et conserve donc le même UUID.
abstract class UsernameAccount
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  UsernameAccount._({
    this.id,
    required this.authUserId,
    required this.username,
    required this.usernameNormalized,
    required this.passwordHash,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UsernameAccount({
    int? id,
    required _is.UuidValue authUserId,
    required String username,
    required String usernameNormalized,
    required String passwordHash,
    DateTime? createdAt,
  }) = _UsernameAccountImpl;

  factory UsernameAccount.fromJson(Map<String, dynamic> jsonSerialization) {
    return UsernameAccount(
      id: jsonSerialization['id'] as int?,
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      username: jsonSerialization['username'] as String,
      usernameNormalized: jsonSerialization['usernameNormalized'] as String,
      passwordHash: jsonSerialization['passwordHash'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = UsernameAccountTable();

  static const db = UsernameAccountRepository._();

  @override
  int? id;

  /// UUID de l'utilisateur auth (même UUID que le compte anonyme).
  _is.UuidValue authUserId;

  /// Pseudo saisi par l'utilisateur (casse d'origine, pour l'affichage).
  String username;

  /// Pseudo en minuscules, utilisé pour la recherche et l'unicité.
  String usernameNormalized;

  /// Hash Argon2id au format PHC, avec pepper serveur.
  String passwordHash;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [UsernameAccount]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  UsernameAccount copyWith({
    int? id,
    _is.UuidValue? authUserId,
    String? username,
    String? usernameNormalized,
    String? passwordHash,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UsernameAccount',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'username': username,
      'usernameNormalized': usernameNormalized,
      'passwordHash': passwordHash,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static UsernameAccountInclude include() {
    return UsernameAccountInclude._();
  }

  static UsernameAccountIncludeList includeList({
    _is.WhereExpressionBuilder<UsernameAccountTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UsernameAccountTable>? orderBy,
    _is.OrderByListBuilder<UsernameAccountTable>? orderByList,
    UsernameAccountInclude? include,
  }) {
    return UsernameAccountIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UsernameAccount.t),
      orderByList: orderByList?.call(UsernameAccount.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UsernameAccountImpl extends UsernameAccount {
  _UsernameAccountImpl({
    int? id,
    required _is.UuidValue authUserId,
    required String username,
    required String usernameNormalized,
    required String passwordHash,
    DateTime? createdAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         username: username,
         usernameNormalized: usernameNormalized,
         passwordHash: passwordHash,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [UsernameAccount]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  UsernameAccount copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    String? username,
    String? usernameNormalized,
    String? passwordHash,
    DateTime? createdAt,
  }) {
    return UsernameAccount(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      username: username ?? this.username,
      usernameNormalized: usernameNormalized ?? this.usernameNormalized,
      passwordHash: passwordHash ?? this.passwordHash,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class UsernameAccountUpdateTable extends _is.UpdateTable<UsernameAccountTable> {
  UsernameAccountUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<String, String> username(String value) => _is.ColumnValue(
    table.username,
    value,
  );

  _is.ColumnValue<String, String> usernameNormalized(String value) =>
      _is.ColumnValue(
        table.usernameNormalized,
        value,
      );

  _is.ColumnValue<String, String> passwordHash(String value) => _is.ColumnValue(
    table.passwordHash,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class UsernameAccountTable extends _is.Table<int?> {
  UsernameAccountTable({super.tableRelation})
    : super(tableName: 'username_account') {
    updateTable = UsernameAccountUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    username = _is.ColumnString(
      'username',
      this,
    );
    usernameNormalized = _is.ColumnString(
      'usernameNormalized',
      this,
    );
    passwordHash = _is.ColumnString(
      'passwordHash',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final UsernameAccountUpdateTable updateTable;

  /// UUID de l'utilisateur auth (même UUID que le compte anonyme).
  late final _is.ColumnUuid authUserId;

  /// Pseudo saisi par l'utilisateur (casse d'origine, pour l'affichage).
  late final _is.ColumnString username;

  /// Pseudo en minuscules, utilisé pour la recherche et l'unicité.
  late final _is.ColumnString usernameNormalized;

  /// Hash Argon2id au format PHC, avec pepper serveur.
  late final _is.ColumnString passwordHash;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    authUserId,
    username,
    usernameNormalized,
    passwordHash,
    createdAt,
  ];
}

class UsernameAccountInclude extends _is.IncludeObject {
  UsernameAccountInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => UsernameAccount.t;
}

class UsernameAccountIncludeList extends _is.IncludeList {
  UsernameAccountIncludeList._({
    _is.WhereExpressionBuilder<UsernameAccountTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UsernameAccount.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => UsernameAccount.t;
}

class UsernameAccountRepository {
  const UsernameAccountRepository._();

  /// Returns a list of [UsernameAccount]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<UsernameAccount>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UsernameAccountTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UsernameAccountTable>? orderBy,
    _is.OrderByListBuilder<UsernameAccountTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<UsernameAccount>(
      where: where?.call(UsernameAccount.t),
      orderBy: orderBy?.call(UsernameAccount.t),
      orderByList: orderByList?.call(UsernameAccount.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [UsernameAccount]s matching the given query parameters every time the
  /// source tables are modified.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// Use [throttle] to specify the minimum interval between queries. It can
  /// also be set to `null`, in which case the stream will only be throttled
  /// when its subscription is paused.
  ///
  /// Source tables are collected from the queried table, [where], [orderBy],
  /// [orderByList], and the [include] graph. [alsoTriggerOnTables] is added
  /// to that set. Pass [Table] instances such as `UsernameAccount.t`.
  ///
  /// Raw [Expression] SQL is not inspected. Tables referenced only in raw
  /// SQL must be passed via [alsoTriggerOnTables].
  ///
  /// The stream always reads committed state and never joins an ambient
  /// [Transaction]. Emissions for a write fire after that write commits.
  ///
  /// Currently only supported on SQLite. Calling this method on PostgreSQL
  /// throws an [UnsupportedError].
  ///
  /// ```dart
  /// var subscription = Persons.db.watch(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// ).listen((persons) {
  ///   // Handle the latest matching rows.
  /// });
  /// ```
  _ida.Stream<List<UsernameAccount>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UsernameAccountTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UsernameAccountTable>? orderBy,
    _is.OrderByListBuilder<UsernameAccountTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<UsernameAccount>(
      where: where?.call(UsernameAccount.t),
      orderBy: orderBy?.call(UsernameAccount.t),
      orderByList: orderByList?.call(UsernameAccount.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [UsernameAccount] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<UsernameAccount?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UsernameAccountTable>? where,
    int? offset,
    _is.OrderByBuilder<UsernameAccountTable>? orderBy,
    _is.OrderByListBuilder<UsernameAccountTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<UsernameAccount>(
      where: where?.call(UsernameAccount.t),
      orderBy: orderBy?.call(UsernameAccount.t),
      orderByList: orderByList?.call(UsernameAccount.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [UsernameAccount] by its [id] or null if no such row exists.
  Future<UsernameAccount?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<UsernameAccount>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [UsernameAccount]s in the list and returns the inserted rows.
  ///
  /// The returned [UsernameAccount]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UsernameAccount>> insert(
    _is.DatabaseSession session,
    List<UsernameAccount> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<UsernameAccount>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [UsernameAccount] and returns the inserted row.
  ///
  /// The returned [UsernameAccount] will have its `id` field set.
  Future<UsernameAccount> insertRow(
    _is.DatabaseSession session,
    UsernameAccount row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<UsernameAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [UsernameAccount]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [UsernameAccount]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UsernameAccount>> upsert(
    _is.DatabaseSession session,
    List<UsernameAccount> rows, {
    required _is.ColumnSelections<UsernameAccountTable> conflictColumns,
    _is.ColumnSelections<UsernameAccountTable>? updateColumns,
    _is.WhereExpressionBuilder<UsernameAccountTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<UsernameAccount>(
      rows,
      conflictColumns: conflictColumns(UsernameAccount.t),
      updateColumns: updateColumns?.call(UsernameAccount.t),
      updateWhere: updateWhere?.call(UsernameAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [UsernameAccount] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [UsernameAccount] will have its `id` field set.
  Future<UsernameAccount?> upsertRow(
    _is.DatabaseSession session,
    UsernameAccount row, {
    required _is.ColumnSelections<UsernameAccountTable> conflictColumns,
    _is.ColumnSelections<UsernameAccountTable>? updateColumns,
    _is.WhereExpressionBuilder<UsernameAccountTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<UsernameAccount>(
      row,
      conflictColumns: conflictColumns(UsernameAccount.t),
      updateColumns: updateColumns?.call(UsernameAccount.t),
      updateWhere: updateWhere?.call(UsernameAccount.t),
      transaction: transaction,
    );
  }

  /// Updates all [UsernameAccount]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UsernameAccount>> update(
    _is.DatabaseSession session,
    List<UsernameAccount> rows, {
    _is.ColumnSelections<UsernameAccountTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<UsernameAccount>(
      rows,
      columns: columns?.call(UsernameAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [UsernameAccount]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UsernameAccount> updateRow(
    _is.DatabaseSession session,
    UsernameAccount row, {
    _is.ColumnSelections<UsernameAccountTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<UsernameAccount>(
      row,
      columns: columns?.call(UsernameAccount.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UsernameAccount] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UsernameAccount?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<UsernameAccountUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<UsernameAccount>(
      id,
      columnValues: columnValues(UsernameAccount.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UsernameAccount]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UsernameAccount>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<UsernameAccountUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<UsernameAccountTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UsernameAccountTable>? orderBy,
    _is.OrderByListBuilder<UsernameAccountTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<UsernameAccount>(
      columnValues: columnValues(UsernameAccount.t.updateTable),
      where: where(UsernameAccount.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UsernameAccount.t),
      orderByList: orderByList?.call(UsernameAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [UsernameAccount]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UsernameAccount>> delete(
    _is.DatabaseSession session,
    List<UsernameAccount> rows, {
    _is.OrderByBuilder<UsernameAccountTable>? orderBy,
    _is.OrderByListBuilder<UsernameAccountTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<UsernameAccount>(
      rows,
      orderBy: orderBy?.call(UsernameAccount.t),
      orderByList: orderByList?.call(UsernameAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [UsernameAccount].
  Future<UsernameAccount> deleteRow(
    _is.DatabaseSession session,
    UsernameAccount row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UsernameAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UsernameAccount>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UsernameAccountTable> where,
    _is.OrderByBuilder<UsernameAccountTable>? orderBy,
    _is.OrderByListBuilder<UsernameAccountTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<UsernameAccount>(
      where: where(UsernameAccount.t),
      orderBy: orderBy?.call(UsernameAccount.t),
      orderByList: orderByList?.call(UsernameAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UsernameAccountTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<UsernameAccount>(
      where: where?.call(UsernameAccount.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [UsernameAccount] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UsernameAccountTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<UsernameAccount>(
      where: where(UsernameAccount.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
