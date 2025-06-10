import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:vpn_app/data/Models/vpn_main.dart';

class Pref {
  static late Box _box;

  static Future<void> initializeHive() async {
    await Hive.initFlutter();
    _box = await Hive.openBox('data');
  }


  ///for storing single selected vpn details
  static Vpn get vpn => Vpn.fromJson(jsonDecode(_box.get('vpn') ?? '{}'));
  static set vpn(Vpn v) => _box.put('vpn', jsonEncode(v));

  ///for storing vpn servers details
    static set vpnList(List<Vpn> v) => _box.put('vpnList', jsonEncode(v));
  static List<Vpn> get vpnList {
    List<Vpn> temp = [];
    final data = jsonDecode(_box.get('vpnList') ?? '[]');

    for (var i in data) temp.add(Vpn.fromJson(i));

    return temp;
  }


  static Future<void> storeCountryFlags(List<String> flags) async {
    await initializeHive(); // Ensure Hive is initialized
    await _box.put('countryFlags', jsonEncode(flags));
  }

  static List<String> getStoredCountryFlags() {
    final data = _box.get('countryFlags');
    return data != null ? List<String>.from(jsonDecode(data)) : [];
  }

  static Future<void> storeCountries(List<String> countries) async {
    await initializeHive(); // Ensure Hive is initialized
    await _box.put('countries', jsonEncode(countries));
  }

  static List<String> getStoredCountries() {
    final data = _box.get('countries');
    return data != null ? List<String>.from(jsonDecode(data)) : [];
  }
}


