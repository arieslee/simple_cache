library simple_cache;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class SimpleCache{
  static SimpleCache _instance;
  static Future<SimpleCache> getInstance() async{
    if (_instance == null) {
      _instance = SimpleCache._internal();
      await _instance._initSharedPreferences();
    }
    return _instance;
  }
  SimpleCache._internal();
  SharedPreferences _preference;
  SharedPreferences get preference => _preference;

  /// 初始化 SharedPreferences
  ///
  Future _initSharedPreferences() async {
    _preference = await SharedPreferences.getInstance();
  }

  /// 验证
  ///
  /// 验证SharedPreferences是否可用
  bool _isAvailable() {
    if (_preference != null) {
      return true;
    }
    return false;
  }

  /// 设置带过期时间的缓存
  ///
  /// expire单位为秒[second]
  Future<bool> setEx(String key, String value, {int expire = -1}) async{
    if(!_isAvailable()) return null;
    if(expire != -1){
      expire = DateTime.now().add(Duration(seconds: expire)).millisecondsSinceEpoch;
    }
    List<String> stringList = [expire.toString(), value];
    return _preference.setStringList(key, stringList);
  }

  /// 验证是否有效
  ///
  /// 验证是否在有效的时间内
  bool _notExpired(List<Object> value) {
    try {
      if (value != null && value.isNotEmpty && value.length == 2) {
        int timestamp = int.parse(value[0]);
        return (timestamp >= DateTime.now().millisecondsSinceEpoch);
      }
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  /// 获取带过期时间的缓存
  ///
  String getEx(String key){
    if(!_isAvailable()) return null;
    List value = _preference.getStringList(key);
    if (_notExpired(value)) {
      return value[1];
    }
    return null;
  }

  /// 写入map
  ///
  Future<bool> setMap(String key, Map value) {
    if(!_isAvailable()) return null;
    return _preference.setString(key, value == null ? "" : json.encode(value));
  }

  /// 获取map
  ///
  Map getMap(String key) {
    if(!_isAvailable()) return null;
    String _data = _preference.getString(key);
    return (_data == null || _data.isEmpty) ? null : json.decode(_data);
  }

  /// 写入list map
  ///
  Future<bool> setListMap(String key, List<Map> list) {
    if(!_isAvailable()) return null;
    List<String> _dataList = list?.map((value) {
      return json.encode(value);
    })?.toList();
    return _preference.setStringList(key, _dataList);
  }

  /// 获取list map
  ///
  List<Map> getListMap(String key) {
    if(!_isAvailable()) return null;
    List<String> dataLis = _preference.getStringList(key);
    return dataLis?.map((value) {
      Map _dataMap = json.decode(value);
      return _dataMap;
    })?.toList();
  }

  /// 写入String类型的数据
  ///
  Future<bool> setString(String key, String value) {
    if(!_isAvailable()) return null;
    return _preference.setString(key, value);
  }

  /// 获取String类型的数据
  ///
  String getString(String key) {
    if(!_isAvailable()) return null;
    return _preference.getString(key);
  }

  /// 写入bool类型的数据
  ///
  Future<bool> setBool(String key, bool value) {
    if(!_isAvailable()) return null;
    return _preference.setBool(key, value);
  }

  /// 获取bool类型的数据
  ///
  bool getBool(String key) {
    if(!_isAvailable()) return null;
    return _preference.getBool(key);
  }

  /// 写入int类型的数据
  ///
  Future<bool> setInt(String key, int value) {
    if(!_isAvailable()) return null;
    return _preference.setInt(key, value);
  }

  /// 获取int类型的数据
  ///
  int getInt(String key) {
    if(!_isAvailable()) return null;
    return _preference.getInt(key);
  }

  /// 写入double类型的数据
  ///
  Future<bool> setDouble(String key, double value) {
    if(!_isAvailable()) return null;
    return _preference.setDouble(key, value);
  }

  /// 获取double类型的数据
  ///
  double getDouble(String key) {
    if(!_isAvailable()) return null;
    return _preference.getDouble(key);
  }

  /// 写入List<String>类型的数据
  ///
  Future<bool> setStringList(String key, List<String> value) {
    if(!_isAvailable()) return null;
    return _preference.setStringList(key, value);
  }

  /// 获取List<String>类型的数据
  ///
  List<String> getStringList(String key) {
    return _preference.getStringList(key);
  }

  /// 获取dynamic类型的数据
  ///
  dynamic getDynamic(String key) {
    if(!_isAvailable()) return null;
    return _preference.get(key);
  }

  /// getDynamic的别名
  ///
  dynamic get(String key) {
    return getDynamic(key);
  }

  /// 删除缓存
  Future remove(String key) async{
    if(!_isAvailable()) return null;
    _preference.remove(key);
  }

  /// 净化缓存
  ///
  /// 此功能能够删除键值[key]存在，但是内容为空的缓存
  Future purge() async{
    if(!_isAvailable()) return null;
    Set<String> keys = _preference.getKeys();
    for (String key in keys) {
      if (getEx(key) == null) {
        _preference.remove(key);
      }
    }
  }

  /// 清理缓存
  ///
  /// 清空所有缓存
  Future flush() async{
    if(!_isAvailable()) return null;
    _preference.clear();
  }
}