import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:tialink/core/exceptions/main_exceptions.dart';

abstract class MainLocalSource {
  T getModel<T>(String uuid,
      {required T Function(Map<String, dynamic> json) fromJson});

  List<T> getModels<T>({required T Function(Map<String, dynamic> json) fromJson});

  Future<void> putModel<T>(T model,
      {required String Function(T object) uuid,
      required Map<String, dynamic> Function(T object) toJson});

  Future<void> putModels<T>(List<T> models,
      {required String Function(T object) uuid,
      required Map<String, dynamic> Function(T object) toJson});

  Future<int> clear();
}

class MainLocalSourceImpl implements MainLocalSource {
  final Box _box;

  MainLocalSourceImpl(this._box);

  @override
  T getModel<T>(String uuid,
      {required T Function(Map<String, dynamic> json) fromJson}) {
    if (_box.containsKey(uuid)) {
      return fromJson(jsonDecode(_box.get(uuid)));
    } else {
      throw CacheMissException(uuid);
    }
  }

  @override
  List<T> getModels<T>({required T Function(Map<String, dynamic> json) fromJson}) {
    if (_box.isNotEmpty) {
      return _box
          .toMap()
          .map((key, value) {
            return MapEntry(null, fromJson(jsonDecode(value)));
          })
          .values
          .cast<T>()
          .toList(growable: false);
    } else {
      throw CacheEmptyException();
    }
  }

  @override
  Future<void> putModel<T>(T model,
      {required String Function(T object) uuid,
      required Map<String, dynamic> Function(T object) toJson}) {
    return _box.put(uuid(model), jsonEncode(toJson(model)));
  }

  @override
  Future<void> putModels<T>(List<T> models,
      {required String Function(T object) uuid,
      required Map<String, dynamic> Function(T object) toJson}) async {
    models.map((e) => {uuid(e): jsonEncode(toJson(e))}).forEach((element) async {
      await _box.putAll(element);
    });
  }

  @override
  Future<int> clear() => _box.clear();
}
