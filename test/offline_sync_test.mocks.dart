// Mocks generated by Mockito 5.4.4 from annotations
// in offline_sync/test/offline_sync_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;
import 'dart:convert' as _i7;
import 'dart:typed_data' as _i8;

import 'package:connectivity_plus/connectivity_plus.dart' as _i9;
import 'package:connectivity_plus_platform_interface/connectivity_plus_platform_interface.dart'
    as _i10;
import 'package:http/http.dart' as _i4;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i5;
import 'package:offline_sync/src/offline_sync.dart' as _i12;
import 'package:shared_preferences/shared_preferences.dart' as _i11;
import 'package:sqflite/sqflite.dart' as _i2;
import 'package:sqflite_common/sql.dart' as _i6;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeDatabase_0 extends _i1.SmartFake implements _i2.Database {
  _FakeDatabase_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFuture_1<T1> extends _i1.SmartFake implements _i3.Future<T1> {
  _FakeFuture_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeQueryCursor_2 extends _i1.SmartFake implements _i2.QueryCursor {
  _FakeQueryCursor_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeBatch_3 extends _i1.SmartFake implements _i2.Batch {
  _FakeBatch_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeResponse_4 extends _i1.SmartFake implements _i4.Response {
  _FakeResponse_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeStreamedResponse_5 extends _i1.SmartFake
    implements _i4.StreamedResponse {
  _FakeStreamedResponse_5(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [Database].
///
/// See the documentation for Mockito's code generation for more information.
class MockDatabase extends _i1.Mock implements _i2.Database {
  MockDatabase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get path => (super.noSuchMethod(
        Invocation.getter(#path),
        returnValue: _i5.dummyValue<String>(
          this,
          Invocation.getter(#path),
        ),
      ) as String);

  @override
  bool get isOpen => (super.noSuchMethod(
        Invocation.getter(#isOpen),
        returnValue: false,
      ) as bool);

  @override
  _i2.Database get database => (super.noSuchMethod(
        Invocation.getter(#database),
        returnValue: _FakeDatabase_0(
          this,
          Invocation.getter(#database),
        ),
      ) as _i2.Database);

  @override
  _i3.Future<void> close() => (super.noSuchMethod(
        Invocation.method(
          #close,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<T> transaction<T>(
    _i3.Future<T> Function(_i2.Transaction)? action, {
    bool? exclusive,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #transaction,
          [action],
          {#exclusive: exclusive},
        ),
        returnValue: _i5.ifNotNull(
              _i5.dummyValueOrNull<T>(
                this,
                Invocation.method(
                  #transaction,
                  [action],
                  {#exclusive: exclusive},
                ),
              ),
              (T v) => _i3.Future<T>.value(v),
            ) ??
            _FakeFuture_1<T>(
              this,
              Invocation.method(
                #transaction,
                [action],
                {#exclusive: exclusive},
              ),
            ),
      ) as _i3.Future<T>);

  @override
  _i3.Future<T> readTransaction<T>(
          _i3.Future<T> Function(_i2.Transaction)? action) =>
      (super.noSuchMethod(
        Invocation.method(
          #readTransaction,
          [action],
        ),
        returnValue: _i5.ifNotNull(
              _i5.dummyValueOrNull<T>(
                this,
                Invocation.method(
                  #readTransaction,
                  [action],
                ),
              ),
              (T v) => _i3.Future<T>.value(v),
            ) ??
            _FakeFuture_1<T>(
              this,
              Invocation.method(
                #readTransaction,
                [action],
              ),
            ),
      ) as _i3.Future<T>);

  @override
  _i3.Future<T> devInvokeMethod<T>(
    String? method, [
    Object? arguments,
  ]) =>
      (super.noSuchMethod(
        Invocation.method(
          #devInvokeMethod,
          [
            method,
            arguments,
          ],
        ),
        returnValue: _i5.ifNotNull(
              _i5.dummyValueOrNull<T>(
                this,
                Invocation.method(
                  #devInvokeMethod,
                  [
                    method,
                    arguments,
                  ],
                ),
              ),
              (T v) => _i3.Future<T>.value(v),
            ) ??
            _FakeFuture_1<T>(
              this,
              Invocation.method(
                #devInvokeMethod,
                [
                  method,
                  arguments,
                ],
              ),
            ),
      ) as _i3.Future<T>);

  @override
  _i3.Future<T> devInvokeSqlMethod<T>(
    String? method,
    String? sql, [
    List<Object?>? arguments,
  ]) =>
      (super.noSuchMethod(
        Invocation.method(
          #devInvokeSqlMethod,
          [
            method,
            sql,
            arguments,
          ],
        ),
        returnValue: _i5.ifNotNull(
              _i5.dummyValueOrNull<T>(
                this,
                Invocation.method(
                  #devInvokeSqlMethod,
                  [
                    method,
                    sql,
                    arguments,
                  ],
                ),
              ),
              (T v) => _i3.Future<T>.value(v),
            ) ??
            _FakeFuture_1<T>(
              this,
              Invocation.method(
                #devInvokeSqlMethod,
                [
                  method,
                  sql,
                  arguments,
                ],
              ),
            ),
      ) as _i3.Future<T>);

  @override
  _i3.Future<void> execute(
    String? sql, [
    List<Object?>? arguments,
  ]) =>
      (super.noSuchMethod(
        Invocation.method(
          #execute,
          [
            sql,
            arguments,
          ],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<int> rawInsert(
    String? sql, [
    List<Object?>? arguments,
  ]) =>
      (super.noSuchMethod(
        Invocation.method(
          #rawInsert,
          [
            sql,
            arguments,
          ],
        ),
        returnValue: _i3.Future<int>.value(0),
      ) as _i3.Future<int>);

  @override
  _i3.Future<int> insert(
    String? table,
    Map<String, Object?>? values, {
    String? nullColumnHack,
    _i6.ConflictAlgorithm? conflictAlgorithm,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #insert,
          [
            table,
            values,
          ],
          {
            #nullColumnHack: nullColumnHack,
            #conflictAlgorithm: conflictAlgorithm,
          },
        ),
        returnValue: _i3.Future<int>.value(0),
      ) as _i3.Future<int>);

  @override
  _i3.Future<List<Map<String, Object?>>> query(
    String? table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #query,
          [table],
          {
            #distinct: distinct,
            #columns: columns,
            #where: where,
            #whereArgs: whereArgs,
            #groupBy: groupBy,
            #having: having,
            #orderBy: orderBy,
            #limit: limit,
            #offset: offset,
          },
        ),
        returnValue: _i3.Future<List<Map<String, Object?>>>.value(
            <Map<String, Object?>>[]),
      ) as _i3.Future<List<Map<String, Object?>>>);

  @override
  _i3.Future<List<Map<String, Object?>>> rawQuery(
    String? sql, [
    List<Object?>? arguments,
  ]) =>
      (super.noSuchMethod(
        Invocation.method(
          #rawQuery,
          [
            sql,
            arguments,
          ],
        ),
        returnValue: _i3.Future<List<Map<String, Object?>>>.value(
            <Map<String, Object?>>[]),
      ) as _i3.Future<List<Map<String, Object?>>>);

  @override
  _i3.Future<_i2.QueryCursor> rawQueryCursor(
    String? sql,
    List<Object?>? arguments, {
    int? bufferSize,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #rawQueryCursor,
          [
            sql,
            arguments,
          ],
          {#bufferSize: bufferSize},
        ),
        returnValue: _i3.Future<_i2.QueryCursor>.value(_FakeQueryCursor_2(
          this,
          Invocation.method(
            #rawQueryCursor,
            [
              sql,
              arguments,
            ],
            {#bufferSize: bufferSize},
          ),
        )),
      ) as _i3.Future<_i2.QueryCursor>);

  @override
  _i3.Future<_i2.QueryCursor> queryCursor(
    String? table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
    int? bufferSize,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #queryCursor,
          [table],
          {
            #distinct: distinct,
            #columns: columns,
            #where: where,
            #whereArgs: whereArgs,
            #groupBy: groupBy,
            #having: having,
            #orderBy: orderBy,
            #limit: limit,
            #offset: offset,
            #bufferSize: bufferSize,
          },
        ),
        returnValue: _i3.Future<_i2.QueryCursor>.value(_FakeQueryCursor_2(
          this,
          Invocation.method(
            #queryCursor,
            [table],
            {
              #distinct: distinct,
              #columns: columns,
              #where: where,
              #whereArgs: whereArgs,
              #groupBy: groupBy,
              #having: having,
              #orderBy: orderBy,
              #limit: limit,
              #offset: offset,
              #bufferSize: bufferSize,
            },
          ),
        )),
      ) as _i3.Future<_i2.QueryCursor>);

  @override
  _i3.Future<int> rawUpdate(
    String? sql, [
    List<Object?>? arguments,
  ]) =>
      (super.noSuchMethod(
        Invocation.method(
          #rawUpdate,
          [
            sql,
            arguments,
          ],
        ),
        returnValue: _i3.Future<int>.value(0),
      ) as _i3.Future<int>);

  @override
  _i3.Future<int> update(
    String? table,
    Map<String, Object?>? values, {
    String? where,
    List<Object?>? whereArgs,
    _i6.ConflictAlgorithm? conflictAlgorithm,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #update,
          [
            table,
            values,
          ],
          {
            #where: where,
            #whereArgs: whereArgs,
            #conflictAlgorithm: conflictAlgorithm,
          },
        ),
        returnValue: _i3.Future<int>.value(0),
      ) as _i3.Future<int>);

  @override
  _i3.Future<int> rawDelete(
    String? sql, [
    List<Object?>? arguments,
  ]) =>
      (super.noSuchMethod(
        Invocation.method(
          #rawDelete,
          [
            sql,
            arguments,
          ],
        ),
        returnValue: _i3.Future<int>.value(0),
      ) as _i3.Future<int>);

  @override
  _i3.Future<int> delete(
    String? table, {
    String? where,
    List<Object?>? whereArgs,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #delete,
          [table],
          {
            #where: where,
            #whereArgs: whereArgs,
          },
        ),
        returnValue: _i3.Future<int>.value(0),
      ) as _i3.Future<int>);

  @override
  _i2.Batch batch() => (super.noSuchMethod(
        Invocation.method(
          #batch,
          [],
        ),
        returnValue: _FakeBatch_3(
          this,
          Invocation.method(
            #batch,
            [],
          ),
        ),
      ) as _i2.Batch);
}

/// A class which mocks [Client].
///
/// See the documentation for Mockito's code generation for more information.
class MockClient extends _i1.Mock implements _i4.Client {
  MockClient() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<_i4.Response> head(
    Uri? url, {
    Map<String, String>? headers,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #head,
          [url],
          {#headers: headers},
        ),
        returnValue: _i3.Future<_i4.Response>.value(_FakeResponse_4(
          this,
          Invocation.method(
            #head,
            [url],
            {#headers: headers},
          ),
        )),
      ) as _i3.Future<_i4.Response>);

  @override
  _i3.Future<_i4.Response> get(
    Uri? url, {
    Map<String, String>? headers,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #get,
          [url],
          {#headers: headers},
        ),
        returnValue: _i3.Future<_i4.Response>.value(_FakeResponse_4(
          this,
          Invocation.method(
            #get,
            [url],
            {#headers: headers},
          ),
        )),
      ) as _i3.Future<_i4.Response>);

  @override
  _i3.Future<_i4.Response> post(
    Uri? url, {
    Map<String, String>? headers,
    Object? body,
    _i7.Encoding? encoding,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #post,
          [url],
          {
            #headers: headers,
            #body: body,
            #encoding: encoding,
          },
        ),
        returnValue: _i3.Future<_i4.Response>.value(_FakeResponse_4(
          this,
          Invocation.method(
            #post,
            [url],
            {
              #headers: headers,
              #body: body,
              #encoding: encoding,
            },
          ),
        )),
      ) as _i3.Future<_i4.Response>);

  @override
  _i3.Future<_i4.Response> put(
    Uri? url, {
    Map<String, String>? headers,
    Object? body,
    _i7.Encoding? encoding,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #put,
          [url],
          {
            #headers: headers,
            #body: body,
            #encoding: encoding,
          },
        ),
        returnValue: _i3.Future<_i4.Response>.value(_FakeResponse_4(
          this,
          Invocation.method(
            #put,
            [url],
            {
              #headers: headers,
              #body: body,
              #encoding: encoding,
            },
          ),
        )),
      ) as _i3.Future<_i4.Response>);

  @override
  _i3.Future<_i4.Response> patch(
    Uri? url, {
    Map<String, String>? headers,
    Object? body,
    _i7.Encoding? encoding,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #patch,
          [url],
          {
            #headers: headers,
            #body: body,
            #encoding: encoding,
          },
        ),
        returnValue: _i3.Future<_i4.Response>.value(_FakeResponse_4(
          this,
          Invocation.method(
            #patch,
            [url],
            {
              #headers: headers,
              #body: body,
              #encoding: encoding,
            },
          ),
        )),
      ) as _i3.Future<_i4.Response>);

  @override
  _i3.Future<_i4.Response> delete(
    Uri? url, {
    Map<String, String>? headers,
    Object? body,
    _i7.Encoding? encoding,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #delete,
          [url],
          {
            #headers: headers,
            #body: body,
            #encoding: encoding,
          },
        ),
        returnValue: _i3.Future<_i4.Response>.value(_FakeResponse_4(
          this,
          Invocation.method(
            #delete,
            [url],
            {
              #headers: headers,
              #body: body,
              #encoding: encoding,
            },
          ),
        )),
      ) as _i3.Future<_i4.Response>);

  @override
  _i3.Future<String> read(
    Uri? url, {
    Map<String, String>? headers,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #read,
          [url],
          {#headers: headers},
        ),
        returnValue: _i3.Future<String>.value(_i5.dummyValue<String>(
          this,
          Invocation.method(
            #read,
            [url],
            {#headers: headers},
          ),
        )),
      ) as _i3.Future<String>);

  @override
  _i3.Future<_i8.Uint8List> readBytes(
    Uri? url, {
    Map<String, String>? headers,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #readBytes,
          [url],
          {#headers: headers},
        ),
        returnValue: _i3.Future<_i8.Uint8List>.value(_i8.Uint8List(0)),
      ) as _i3.Future<_i8.Uint8List>);

  @override
  _i3.Future<_i4.StreamedResponse> send(_i4.BaseRequest? request) =>
      (super.noSuchMethod(
        Invocation.method(
          #send,
          [request],
        ),
        returnValue:
            _i3.Future<_i4.StreamedResponse>.value(_FakeStreamedResponse_5(
          this,
          Invocation.method(
            #send,
            [request],
          ),
        )),
      ) as _i3.Future<_i4.StreamedResponse>);

  @override
  void close() => super.noSuchMethod(
        Invocation.method(
          #close,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [Connectivity].
///
/// See the documentation for Mockito's code generation for more information.
class MockConnectivity extends _i1.Mock implements _i9.Connectivity {
  MockConnectivity() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Stream<List<_i10.ConnectivityResult>> get onConnectivityChanged =>
      (super.noSuchMethod(
        Invocation.getter(#onConnectivityChanged),
        returnValue: _i3.Stream<List<_i10.ConnectivityResult>>.empty(),
      ) as _i3.Stream<List<_i10.ConnectivityResult>>);

  @override
  _i3.Future<List<_i10.ConnectivityResult>> checkConnectivity() =>
      (super.noSuchMethod(
        Invocation.method(
          #checkConnectivity,
          [],
        ),
        returnValue: _i3.Future<List<_i10.ConnectivityResult>>.value(
            <_i10.ConnectivityResult>[]),
      ) as _i3.Future<List<_i10.ConnectivityResult>>);
}

/// A class which mocks [SharedPreferences].
///
/// See the documentation for Mockito's code generation for more information.
class MockSharedPreferences extends _i1.Mock implements _i11.SharedPreferences {
  MockSharedPreferences() {
    _i1.throwOnMissingStub(this);
  }

  @override
  Set<String> getKeys() => (super.noSuchMethod(
        Invocation.method(
          #getKeys,
          [],
        ),
        returnValue: <String>{},
      ) as Set<String>);

  @override
  Object? get(String? key) => (super.noSuchMethod(Invocation.method(
        #get,
        [key],
      )) as Object?);

  @override
  bool? getBool(String? key) => (super.noSuchMethod(Invocation.method(
        #getBool,
        [key],
      )) as bool?);

  @override
  int? getInt(String? key) => (super.noSuchMethod(Invocation.method(
        #getInt,
        [key],
      )) as int?);

  @override
  double? getDouble(String? key) => (super.noSuchMethod(Invocation.method(
        #getDouble,
        [key],
      )) as double?);

  @override
  String? getString(String? key) => (super.noSuchMethod(Invocation.method(
        #getString,
        [key],
      )) as String?);

  @override
  bool containsKey(String? key) => (super.noSuchMethod(
        Invocation.method(
          #containsKey,
          [key],
        ),
        returnValue: false,
      ) as bool);

  @override
  List<String>? getStringList(String? key) =>
      (super.noSuchMethod(Invocation.method(
        #getStringList,
        [key],
      )) as List<String>?);

  @override
  _i3.Future<bool> setBool(
    String? key,
    bool? value,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #setBool,
          [
            key,
            value,
          ],
        ),
        returnValue: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);

  @override
  _i3.Future<bool> setInt(
    String? key,
    int? value,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #setInt,
          [
            key,
            value,
          ],
        ),
        returnValue: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);

  @override
  _i3.Future<bool> setDouble(
    String? key,
    double? value,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #setDouble,
          [
            key,
            value,
          ],
        ),
        returnValue: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);

  @override
  _i3.Future<bool> setString(
    String? key,
    String? value,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #setString,
          [
            key,
            value,
          ],
        ),
        returnValue: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);

  @override
  _i3.Future<bool> setStringList(
    String? key,
    List<String>? value,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #setStringList,
          [
            key,
            value,
          ],
        ),
        returnValue: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);

  @override
  _i3.Future<bool> remove(String? key) => (super.noSuchMethod(
        Invocation.method(
          #remove,
          [key],
        ),
        returnValue: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);

  @override
  _i3.Future<bool> commit() => (super.noSuchMethod(
        Invocation.method(
          #commit,
          [],
        ),
        returnValue: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);

  @override
  _i3.Future<bool> clear() => (super.noSuchMethod(
        Invocation.method(
          #clear,
          [],
        ),
        returnValue: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);

  @override
  _i3.Future<void> reload() => (super.noSuchMethod(
        Invocation.method(
          #reload,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
}

/// A class which mocks [OfflineSync].
///
/// See the documentation for Mockito's code generation for more information.
class MockOfflineSync extends _i1.Mock implements _i12.OfflineSync {
  MockOfflineSync() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<void> initialize() => (super.noSuchMethod(
        Invocation.method(
          #initialize,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> setAuthToken(String? token) => (super.noSuchMethod(
        Invocation.method(
          #setAuthToken,
          [token],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> loadAuthToken() => (super.noSuchMethod(
        Invocation.method(
          #loadAuthToken,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> addToSyncQueue(
    String? action,
    Map<String, dynamic>? data,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #addToSyncQueue,
          [
            action,
            data,
          ],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> syncData() => (super.noSuchMethod(
        Invocation.method(
          #syncData,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> saveLocalData(
    String? id,
    Map<String, dynamic>? data,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #saveLocalData,
          [
            id,
            data,
          ],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<Map<String, dynamic>?> readLocalData(String? id) =>
      (super.noSuchMethod(
        Invocation.method(
          #readLocalData,
          [id],
        ),
        returnValue: _i3.Future<Map<String, dynamic>?>.value(),
      ) as _i3.Future<Map<String, dynamic>?>);

  @override
  _i3.Future<void> updateFromServer() => (super.noSuchMethod(
        Invocation.method(
          #updateFromServer,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<List<Map<String, dynamic>>> readAllLocalData() =>
      (super.noSuchMethod(
        Invocation.method(
          #readAllLocalData,
          [],
        ),
        returnValue: _i3.Future<List<Map<String, dynamic>>>.value(
            <Map<String, dynamic>>[]),
      ) as _i3.Future<List<Map<String, dynamic>>>);

  @override
  _i3.Future<void> dispose() => (super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  String encryptData(Map<String, dynamic>? data) => (super.noSuchMethod(
        Invocation.method(
          #encryptData,
          [data],
        ),
        returnValue: _i5.dummyValue<String>(
          this,
          Invocation.method(
            #encryptData,
            [data],
          ),
        ),
      ) as String);
}
