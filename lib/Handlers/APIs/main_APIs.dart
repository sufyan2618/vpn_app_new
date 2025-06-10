import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'package:http/http.dart';
import 'package:vpn_app/Handlers/pref_storage.dart';
import 'package:vpn_app/data/Models/ip_Address_Details.dart';
import 'package:vpn_app/data/Models/vpn_main.dart';


class APIs {


  static Future<List<Vpn>> getVPNServers() async {
    final List<Vpn> vpnList = [];

    try {
      /// Fetch all VPN servers
      final res = await get(Uri.parse('http://www.vpngate.net/api/iphone/'));
      final csvString = res.body.split("#")[1].replaceAll('*', '');

      List<List<dynamic>> list = const CsvToListConverter().convert(csvString);

      final header = list[0];

      for (int i = 1; i < list.length - 1; ++i) {
        Map<String, dynamic> tempJson = {};

        for (int j = 0; j < header.length; ++j) {
          tempJson.addAll({header[j].toString(): list[i][j]});
        }
        vpnList.add(Vpn.fromJson(tempJson));
      }
    } catch (e) {
      log('\ngetVPNServersE: $e');
    }

    vpnList.shuffle();

    if (vpnList.isNotEmpty) {
      // Cache the VPN server data locally for future use
      Pref.vpnList = vpnList;
    }

    return vpnList;
  }

  static Future< List<String>> getCountriesFlags() async {
    List<String> flags=[];
    try {
      final response = await http.get(Uri.parse('http://www.vpngate.net/api/iphone/'));

      if (response.statusCode == 200) {
        // Parse the response as needed (it is in CSV format)
        List<String> lines = response.body.split('\n');
        print(lines);

        // Extract unique countries with flags
        Set<String> uniqueCountries = {};

        for (int i = 2; i < lines.length; i++) {
          List<String> serverInfo = lines[i].split(',');
          if (serverInfo.length > 6) {
            uniqueCountries.add(serverInfo[6]);
          }
        }

        flags = uniqueCountries.toList();
        await Pref.storeCountryFlags(flags); // Store flags in Pref


      } else {
        print(
            "Error: Unable to fetch data. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
    return flags;
  }


  static  Future<List<String>> getCountries() async {
    List<String> countries = [];
    try {
      final response = await http.get(Uri.parse('http://www.vpngate.net/api/iphone/'));

      if (response.statusCode == 200) {
        /// Parse the response as needed (it is in CSV format)

        List<String> lines = response.body.split('\n');
        print(lines);

        /// Extract unique countries with flags
        Set<String> uniqueCountries = {};

        for (int i = 2; i < lines.length; i++) {
          List<String> serverInfo = lines[i].split(',');

          if (serverInfo.length > 7) {
            uniqueCountries.add(serverInfo[5]);
          }
        }

        /// Convert country names to CountryData objects with flags
        countries = uniqueCountries.toList();
        await Pref.storeCountries(countries); // Store countries in Pref

        print(countries);
      } else {
        print("Error: Unable to fetch data. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
    return countries;


  }



  static Future<IPDetails> getIPDetails({required IPDetails ipData}) async {
    var  ipdata;
    try {
      final res = await get(Uri.parse('http://ip-api.com/json/'));
      final data = jsonDecode(res.body);
    ipdata= IPDetails.fromJson(data);

    } catch (e) {
      print('\ngetIPDetailsE: $e');
    }
    return ipdata;
  }

}



