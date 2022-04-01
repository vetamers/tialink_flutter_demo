import 'package:flutter/cupertino.dart';

class CacheMissException extends ErrorDescription {
  final String key;

  CacheMissException(this.key) : super("CacheMiss\nkey: $key");
}

class CacheEmptyException extends ErrorDescription {
  CacheEmptyException() : super("Cache empty");
}