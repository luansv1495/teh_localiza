import 'package:hive/hive.dart';

class PreferencesDriver {
  static const _preferencesBox = '_preferencesBox';
  final Box<dynamic> _box;

  PreferencesDriver._(this._box);

  static Future<PreferencesDriver> getInstance() async {
    final box = await Hive.openBox<dynamic>(_preferencesBox);
    return PreferencesDriver._(box);
  }

  String getString(String key) => _getValue(key);

  Future<void> setString(String key, String value) => _setValue(key, value);

  T _getValue<T>(dynamic key, {T defaultValue}) =>
      _box.get(key, defaultValue: defaultValue) as T;

  Future<void> _setValue<T>(dynamic key, T value) => _box.put(key, value);
}
