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

/// Un duel du feed (anciennement « post » dans l'app Flutter).
abstract class Duel implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Duel._({
    this.id,
    DateTime? createdAt,
    required this.authorId,
    required this.authorName,
    required this.question,
    required this.type,
    this.optionAText,
    this.optionAUrl,
    this.optionBText,
    this.optionBUrl,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Duel({
    int? id,
    DateTime? createdAt,
    required _is.UuidValue authorId,
    required String authorName,
    required String question,
    required String type,
    String? optionAText,
    String? optionAUrl,
    String? optionBText,
    String? optionBUrl,
  }) = _DuelImpl;

  factory Duel.fromJson(Map<String, dynamic> jsonSerialization) {
    return Duel(
      id: jsonSerialization['id'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      authorId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authorId'],
      ),
      authorName: jsonSerialization['authorName'] as String,
      question: jsonSerialization['question'] as String,
      type: jsonSerialization['type'] as String,
      optionAText: jsonSerialization['optionAText'] as String?,
      optionAUrl: jsonSerialization['optionAUrl'] as String?,
      optionBText: jsonSerialization['optionBText'] as String?,
      optionBUrl: jsonSerialization['optionBUrl'] as String?,
    );
  }

  static final t = DuelTable();

  static const db = DuelRepository._();

  @override
  int? id;

  DateTime createdAt;

  /// UUID de l'auteur, jamais fourni par le client en écriture.
  _is.UuidValue authorId;

  /// Pseudo de l'auteur au moment de la création (lecture seule pour le feed).
  String authorName;

  String question;

  /// "text" ou "image".
  String type;

  String? optionAText;

  String? optionAUrl;

  String? optionBText;

  String? optionBUrl;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Duel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Duel copyWith({
    int? id,
    DateTime? createdAt,
    _is.UuidValue? authorId,
    String? authorName,
    String? question,
    String? type,
    String? optionAText,
    String? optionAUrl,
    String? optionBText,
    String? optionBUrl,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Duel',
      if (id != null) 'id': id,
      'createdAt': createdAt.toJson(),
      'authorId': authorId.toJson(),
      'authorName': authorName,
      'question': question,
      'type': type,
      if (optionAText != null) 'optionAText': optionAText,
      if (optionAUrl != null) 'optionAUrl': optionAUrl,
      if (optionBText != null) 'optionBText': optionBText,
      if (optionBUrl != null) 'optionBUrl': optionBUrl,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Duel',
      if (id != null) 'id': id,
      'createdAt': createdAt.toJson(),
      'authorId': authorId.toJson(),
      'authorName': authorName,
      'question': question,
      'type': type,
      if (optionAText != null) 'optionAText': optionAText,
      if (optionAUrl != null) 'optionAUrl': optionAUrl,
      if (optionBText != null) 'optionBText': optionBText,
      if (optionBUrl != null) 'optionBUrl': optionBUrl,
    };
  }

  static DuelInclude include() {
    return DuelInclude._();
  }

  static DuelIncludeList includeList({
    _is.WhereExpressionBuilder<DuelTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DuelTable>? orderBy,
    _is.OrderByListBuilder<DuelTable>? orderByList,
    DuelInclude? include,
  }) {
    return DuelIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Duel.t),
      orderByList: orderByList?.call(Duel.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DuelImpl extends Duel {
  _DuelImpl({
    int? id,
    DateTime? createdAt,
    required _is.UuidValue authorId,
    required String authorName,
    required String question,
    required String type,
    String? optionAText,
    String? optionAUrl,
    String? optionBText,
    String? optionBUrl,
  }) : super._(
         id: id,
         createdAt: createdAt,
         authorId: authorId,
         authorName: authorName,
         question: question,
         type: type,
         optionAText: optionAText,
         optionAUrl: optionAUrl,
         optionBText: optionBText,
         optionBUrl: optionBUrl,
       );

  /// Returns a shallow copy of this [Duel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Duel copyWith({
    Object? id = _Undefined,
    DateTime? createdAt,
    _is.UuidValue? authorId,
    String? authorName,
    String? question,
    String? type,
    Object? optionAText = _Undefined,
    Object? optionAUrl = _Undefined,
    Object? optionBText = _Undefined,
    Object? optionBUrl = _Undefined,
  }) {
    return Duel(
      id: id is int? ? id : this.id,
      createdAt: createdAt ?? this.createdAt,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      question: question ?? this.question,
      type: type ?? this.type,
      optionAText: optionAText is String? ? optionAText : this.optionAText,
      optionAUrl: optionAUrl is String? ? optionAUrl : this.optionAUrl,
      optionBText: optionBText is String? ? optionBText : this.optionBText,
      optionBUrl: optionBUrl is String? ? optionBUrl : this.optionBUrl,
    );
  }
}

class DuelUpdateTable extends _is.UpdateTable<DuelTable> {
  DuelUpdateTable(super.table);

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authorId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.authorId,
        value,
      );

  _is.ColumnValue<String, String> authorName(String value) => _is.ColumnValue(
    table.authorName,
    value,
  );

  _is.ColumnValue<String, String> question(String value) => _is.ColumnValue(
    table.question,
    value,
  );

  _is.ColumnValue<String, String> type(String value) => _is.ColumnValue(
    table.type,
    value,
  );

  _is.ColumnValue<String, String> optionAText(String? value) => _is.ColumnValue(
    table.optionAText,
    value,
  );

  _is.ColumnValue<String, String> optionAUrl(String? value) => _is.ColumnValue(
    table.optionAUrl,
    value,
  );

  _is.ColumnValue<String, String> optionBText(String? value) => _is.ColumnValue(
    table.optionBText,
    value,
  );

  _is.ColumnValue<String, String> optionBUrl(String? value) => _is.ColumnValue(
    table.optionBUrl,
    value,
  );
}

class DuelTable extends _is.Table<int?> {
  DuelTable({super.tableRelation}) : super(tableName: 'duel') {
    updateTable = DuelUpdateTable(this);
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
    authorId = _is.ColumnUuid(
      'authorId',
      this,
    );
    authorName = _is.ColumnString(
      'authorName',
      this,
    );
    question = _is.ColumnString(
      'question',
      this,
    );
    type = _is.ColumnString(
      'type',
      this,
    );
    optionAText = _is.ColumnString(
      'optionAText',
      this,
    );
    optionAUrl = _is.ColumnString(
      'optionAUrl',
      this,
    );
    optionBText = _is.ColumnString(
      'optionBText',
      this,
    );
    optionBUrl = _is.ColumnString(
      'optionBUrl',
      this,
    );
  }

  late final DuelUpdateTable updateTable;

  late final _is.ColumnDateTime createdAt;

  /// UUID de l'auteur, jamais fourni par le client en écriture.
  late final _is.ColumnUuid authorId;

  /// Pseudo de l'auteur au moment de la création (lecture seule pour le feed).
  late final _is.ColumnString authorName;

  late final _is.ColumnString question;

  /// "text" ou "image".
  late final _is.ColumnString type;

  late final _is.ColumnString optionAText;

  late final _is.ColumnString optionAUrl;

  late final _is.ColumnString optionBText;

  late final _is.ColumnString optionBUrl;

  @override
  List<_is.Column> get columns => [
    id,
    createdAt,
    authorId,
    authorName,
    question,
    type,
    optionAText,
    optionAUrl,
    optionBText,
    optionBUrl,
  ];
}

class DuelInclude extends _is.IncludeObject {
  DuelInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Duel.t;
}

class DuelIncludeList extends _is.IncludeList {
  DuelIncludeList._({
    _is.WhereExpressionBuilder<DuelTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Duel.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Duel.t;
}

class DuelRepository {
  const DuelRepository._();

  /// Returns a list of [Duel]s matching the given query parameters.
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
  Future<List<Duel>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DuelTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DuelTable>? orderBy,
    _is.OrderByListBuilder<DuelTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Duel>(
      where: where?.call(Duel.t),
      orderBy: orderBy?.call(Duel.t),
      orderByList: orderByList?.call(Duel.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [Duel]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `Duel.t`.
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
  _ida.Stream<List<Duel>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DuelTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DuelTable>? orderBy,
    _is.OrderByListBuilder<DuelTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<Duel>(
      where: where?.call(Duel.t),
      orderBy: orderBy?.call(Duel.t),
      orderByList: orderByList?.call(Duel.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [Duel] matching the given query parameters.
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
  Future<Duel?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DuelTable>? where,
    int? offset,
    _is.OrderByBuilder<DuelTable>? orderBy,
    _is.OrderByListBuilder<DuelTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Duel>(
      where: where?.call(Duel.t),
      orderBy: orderBy?.call(Duel.t),
      orderByList: orderByList?.call(Duel.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Duel] by its [id] or null if no such row exists.
  Future<Duel?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Duel>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Duel]s in the list and returns the inserted rows.
  ///
  /// The returned [Duel]s will have their `id` fields set.
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
  Future<List<Duel>> insert(
    _is.DatabaseSession session,
    List<Duel> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Duel>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Duel] and returns the inserted row.
  ///
  /// The returned [Duel] will have its `id` field set.
  Future<Duel> insertRow(
    _is.DatabaseSession session,
    Duel row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Duel>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Duel]s in the list and returns the resulting rows.
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
  /// The returned [Duel]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Duel>> upsert(
    _is.DatabaseSession session,
    List<Duel> rows, {
    required _is.ColumnSelections<DuelTable> conflictColumns,
    _is.ColumnSelections<DuelTable>? updateColumns,
    _is.WhereExpressionBuilder<DuelTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Duel>(
      rows,
      conflictColumns: conflictColumns(Duel.t),
      updateColumns: updateColumns?.call(Duel.t),
      updateWhere: updateWhere?.call(Duel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Duel] and returns the resulting row.
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
  /// The returned [Duel] will have its `id` field set.
  Future<Duel?> upsertRow(
    _is.DatabaseSession session,
    Duel row, {
    required _is.ColumnSelections<DuelTable> conflictColumns,
    _is.ColumnSelections<DuelTable>? updateColumns,
    _is.WhereExpressionBuilder<DuelTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Duel>(
      row,
      conflictColumns: conflictColumns(Duel.t),
      updateColumns: updateColumns?.call(Duel.t),
      updateWhere: updateWhere?.call(Duel.t),
      transaction: transaction,
    );
  }

  /// Updates all [Duel]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Duel>> update(
    _is.DatabaseSession session,
    List<Duel> rows, {
    _is.ColumnSelections<DuelTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Duel>(
      rows,
      columns: columns?.call(Duel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Duel]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Duel> updateRow(
    _is.DatabaseSession session,
    Duel row, {
    _is.ColumnSelections<DuelTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Duel>(
      row,
      columns: columns?.call(Duel.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Duel] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Duel?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<DuelUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Duel>(
      id,
      columnValues: columnValues(Duel.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Duel]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Duel>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<DuelUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<DuelTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DuelTable>? orderBy,
    _is.OrderByListBuilder<DuelTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Duel>(
      columnValues: columnValues(Duel.t.updateTable),
      where: where(Duel.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Duel.t),
      orderByList: orderByList?.call(Duel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Duel]s in the list and returns the deleted rows.
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
  Future<List<Duel>> delete(
    _is.DatabaseSession session,
    List<Duel> rows, {
    _is.OrderByBuilder<DuelTable>? orderBy,
    _is.OrderByListBuilder<DuelTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Duel>(
      rows,
      orderBy: orderBy?.call(Duel.t),
      orderByList: orderByList?.call(Duel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Duel].
  Future<Duel> deleteRow(
    _is.DatabaseSession session,
    Duel row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Duel>(
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
  Future<List<Duel>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DuelTable> where,
    _is.OrderByBuilder<DuelTable>? orderBy,
    _is.OrderByListBuilder<DuelTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Duel>(
      where: where(Duel.t),
      orderBy: orderBy?.call(Duel.t),
      orderByList: orderByList?.call(Duel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DuelTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Duel>(
      where: where?.call(Duel.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Duel] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DuelTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Duel>(
      where: where(Duel.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
