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

/// Vote d'un utilisateur sur un duel. L'identité vient de la session,
/// jamais d'un paramètre client.
abstract class Vote implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Vote._({
    this.id,
    DateTime? createdAt,
    required this.duelId,
    required this.userId,
    required this.choix,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Vote({
    int? id,
    DateTime? createdAt,
    required int duelId,
    required _is.UuidValue userId,
    required String choix,
  }) = _VoteImpl;

  factory Vote.fromJson(Map<String, dynamic> jsonSerialization) {
    return Vote(
      id: jsonSerialization['id'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      duelId: jsonSerialization['duelId'] as int,
      userId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      choix: jsonSerialization['choix'] as String,
    );
  }

  static final t = VoteTable();

  static const db = VoteRepository._();

  @override
  int? id;

  DateTime createdAt;

  int duelId;

  _is.UuidValue userId;

  /// "a" ou "b".
  String choix;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Vote]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Vote copyWith({
    int? id,
    DateTime? createdAt,
    int? duelId,
    _is.UuidValue? userId,
    String? choix,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Vote',
      if (id != null) 'id': id,
      'createdAt': createdAt.toJson(),
      'duelId': duelId,
      'userId': userId.toJson(),
      'choix': choix,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Vote',
      if (id != null) 'id': id,
      'createdAt': createdAt.toJson(),
      'duelId': duelId,
      'userId': userId.toJson(),
      'choix': choix,
    };
  }

  static VoteInclude include() {
    return VoteInclude._();
  }

  static VoteIncludeList includeList({
    _is.WhereExpressionBuilder<VoteTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<VoteTable>? orderBy,
    _is.OrderByListBuilder<VoteTable>? orderByList,
    VoteInclude? include,
  }) {
    return VoteIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Vote.t),
      orderByList: orderByList?.call(Vote.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VoteImpl extends Vote {
  _VoteImpl({
    int? id,
    DateTime? createdAt,
    required int duelId,
    required _is.UuidValue userId,
    required String choix,
  }) : super._(
         id: id,
         createdAt: createdAt,
         duelId: duelId,
         userId: userId,
         choix: choix,
       );

  /// Returns a shallow copy of this [Vote]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Vote copyWith({
    Object? id = _Undefined,
    DateTime? createdAt,
    int? duelId,
    _is.UuidValue? userId,
    String? choix,
  }) {
    return Vote(
      id: id is int? ? id : this.id,
      createdAt: createdAt ?? this.createdAt,
      duelId: duelId ?? this.duelId,
      userId: userId ?? this.userId,
      choix: choix ?? this.choix,
    );
  }
}

class VoteUpdateTable extends _is.UpdateTable<VoteTable> {
  VoteUpdateTable(super.table);

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<int, int> duelId(int value) => _is.ColumnValue(
    table.duelId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> userId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.userId,
        value,
      );

  _is.ColumnValue<String, String> choix(String value) => _is.ColumnValue(
    table.choix,
    value,
  );
}

class VoteTable extends _is.Table<int?> {
  VoteTable({super.tableRelation}) : super(tableName: 'vote') {
    updateTable = VoteUpdateTable(this);
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
    duelId = _is.ColumnInt(
      'duelId',
      this,
    );
    userId = _is.ColumnUuid(
      'userId',
      this,
    );
    choix = _is.ColumnString(
      'choix',
      this,
    );
  }

  late final VoteUpdateTable updateTable;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnInt duelId;

  late final _is.ColumnUuid userId;

  /// "a" ou "b".
  late final _is.ColumnString choix;

  @override
  List<_is.Column> get columns => [
    id,
    createdAt,
    duelId,
    userId,
    choix,
  ];
}

class VoteInclude extends _is.IncludeObject {
  VoteInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Vote.t;
}

class VoteIncludeList extends _is.IncludeList {
  VoteIncludeList._({
    _is.WhereExpressionBuilder<VoteTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Vote.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Vote.t;
}

class VoteRepository {
  const VoteRepository._();

  /// Returns a list of [Vote]s matching the given query parameters.
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
  Future<List<Vote>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<VoteTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<VoteTable>? orderBy,
    _is.OrderByListBuilder<VoteTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Vote>(
      where: where?.call(Vote.t),
      orderBy: orderBy?.call(Vote.t),
      orderByList: orderByList?.call(Vote.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [Vote]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `Vote.t`.
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
  _ida.Stream<List<Vote>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<VoteTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<VoteTable>? orderBy,
    _is.OrderByListBuilder<VoteTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<Vote>(
      where: where?.call(Vote.t),
      orderBy: orderBy?.call(Vote.t),
      orderByList: orderByList?.call(Vote.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [Vote] matching the given query parameters.
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
  Future<Vote?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<VoteTable>? where,
    int? offset,
    _is.OrderByBuilder<VoteTable>? orderBy,
    _is.OrderByListBuilder<VoteTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Vote>(
      where: where?.call(Vote.t),
      orderBy: orderBy?.call(Vote.t),
      orderByList: orderByList?.call(Vote.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Vote] by its [id] or null if no such row exists.
  Future<Vote?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Vote>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Vote]s in the list and returns the inserted rows.
  ///
  /// The returned [Vote]s will have their `id` fields set.
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
  Future<List<Vote>> insert(
    _is.DatabaseSession session,
    List<Vote> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Vote>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Vote] and returns the inserted row.
  ///
  /// The returned [Vote] will have its `id` field set.
  Future<Vote> insertRow(
    _is.DatabaseSession session,
    Vote row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Vote>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Vote]s in the list and returns the resulting rows.
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
  /// The returned [Vote]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Vote>> upsert(
    _is.DatabaseSession session,
    List<Vote> rows, {
    required _is.ColumnSelections<VoteTable> conflictColumns,
    _is.ColumnSelections<VoteTable>? updateColumns,
    _is.WhereExpressionBuilder<VoteTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Vote>(
      rows,
      conflictColumns: conflictColumns(Vote.t),
      updateColumns: updateColumns?.call(Vote.t),
      updateWhere: updateWhere?.call(Vote.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Vote] and returns the resulting row.
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
  /// The returned [Vote] will have its `id` field set.
  Future<Vote?> upsertRow(
    _is.DatabaseSession session,
    Vote row, {
    required _is.ColumnSelections<VoteTable> conflictColumns,
    _is.ColumnSelections<VoteTable>? updateColumns,
    _is.WhereExpressionBuilder<VoteTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Vote>(
      row,
      conflictColumns: conflictColumns(Vote.t),
      updateColumns: updateColumns?.call(Vote.t),
      updateWhere: updateWhere?.call(Vote.t),
      transaction: transaction,
    );
  }

  /// Updates all [Vote]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Vote>> update(
    _is.DatabaseSession session,
    List<Vote> rows, {
    _is.ColumnSelections<VoteTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Vote>(
      rows,
      columns: columns?.call(Vote.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Vote]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Vote> updateRow(
    _is.DatabaseSession session,
    Vote row, {
    _is.ColumnSelections<VoteTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Vote>(
      row,
      columns: columns?.call(Vote.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Vote] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Vote?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<VoteUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Vote>(
      id,
      columnValues: columnValues(Vote.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Vote]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Vote>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<VoteUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<VoteTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<VoteTable>? orderBy,
    _is.OrderByListBuilder<VoteTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Vote>(
      columnValues: columnValues(Vote.t.updateTable),
      where: where(Vote.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Vote.t),
      orderByList: orderByList?.call(Vote.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Vote]s in the list and returns the deleted rows.
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
  Future<List<Vote>> delete(
    _is.DatabaseSession session,
    List<Vote> rows, {
    _is.OrderByBuilder<VoteTable>? orderBy,
    _is.OrderByListBuilder<VoteTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Vote>(
      rows,
      orderBy: orderBy?.call(Vote.t),
      orderByList: orderByList?.call(Vote.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Vote].
  Future<Vote> deleteRow(
    _is.DatabaseSession session,
    Vote row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Vote>(
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
  Future<List<Vote>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<VoteTable> where,
    _is.OrderByBuilder<VoteTable>? orderBy,
    _is.OrderByListBuilder<VoteTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Vote>(
      where: where(Vote.t),
      orderBy: orderBy?.call(Vote.t),
      orderByList: orderByList?.call(Vote.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<VoteTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Vote>(
      where: where?.call(Vote.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Vote] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<VoteTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Vote>(
      where: where(Vote.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
