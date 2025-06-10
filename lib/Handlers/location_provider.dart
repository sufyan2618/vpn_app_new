
import 'package:flutter/foundation.dart';
import 'package:vpn_app/Handlers/APIs/main_APIs.dart';
import 'package:vpn_app/Handlers/pref_storage.dart';
import 'package:vpn_app/data/Models/vpn_main.dart';

class LocationProvider extends ChangeNotifier {
  List<Vpn> _vpnList= Pref.vpnList;
  List<Vpn> get vpnList => _vpnList;
  List<String> _countrylist = Pref.getStoredCountries() ;
  List<String> _flaglist = Pref.getStoredCountryFlags() ;
  List<String> get countrylist => _countrylist;
  List<String> get flaglist => _flaglist;


  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> getVpnData() async {
    _isLoading = true;
    _vpnList.clear();
    _vpnList = await APIs.getVPNServers();
    _isLoading = false;
    notifyListeners(); // Notify listeners that isLoading has changed
  }
Future<void> getCountriesData()async{
   _isLoading = true;
  _countrylist.clear();
  _flaglist.clear();
    _countrylist=await APIs.getCountries();
    _flaglist =await APIs.getCountriesFlags();
   _isLoading = false;
  notifyListeners();

}

  Future<void> getVpn() async {
    _isLoading = true;
     notifyListeners(); // Notify listeners that isLoading has changed
    _vpnList.clear();
    _vpnList = await APIs.getVPNServers();
    _countrylist=await APIs.getCountries();
    _flaglist =await APIs.getCountriesFlags();
    _isLoading = false;
    notifyListeners(); // Notify listeners that isLoading has changed
  }
}
