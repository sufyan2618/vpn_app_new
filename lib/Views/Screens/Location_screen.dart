import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:vpn_app/Handlers/home_provider.dart';
import 'package:vpn_app/Handlers/location_provider.dart';
import 'package:vpn_app/data/Models/premium_server.dart';
import 'package:vpn_app/data/Models/vpn_main.dart';

import 'package:vpn_app/Views/core/components/Country_card.dart';
import 'package:vpn_app/Views/core/components/Vpn_card.dart';
import 'package:vpn_app/Views/core/components/alertBox.dart';
import 'package:vpn_app/data/services/vpn_Engine.dart';

class LocationScreen extends StatefulWidget {
  final List<Vpn> serverList;
  final List<String> countries;
  final List<String> flags;

  LocationScreen({Key? key, required this.serverList, required this.flags, required this.countries}) : super(key: key);

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final String apiURL = "http://www.vpngate.net/api/iphone";
  List<String> countries = [];
  String? selectedCountry;
  List<Vpn> servers = [];
  List<String> flags = [];
  bool istap = false;
  String? expandedCountry;

  @override
  void initState() {
    super.initState();
    gettingServers();
  }

  final List<PremiumServer> premiumServers = [
    PremiumServer(
      id: 'sweden1',
      name: 'Sweden Premium',
      country: 'Sweden',
      flagAssetPath: 'assets/flags/se.png',
      ovpnAssetPath: 'assets/vpn/sweden.ovpn',
      username: 'openvpn',
      password: 'Judge@hmadno1',
    ),
    // Add more premium servers as needed
  ];

  void gettingServers() async {
    final locationController = Provider.of<LocationProvider>(context, listen: false);

    try {
      if (widget.countries.isEmpty) {
        if (locationController.vpnList.isEmpty) {
          await locationController.getVpnData();
        }
        if (locationController.countrylist.isEmpty || locationController.flaglist.isEmpty) {
          await locationController.getCountriesData();
        }

        if (mounted) {
          setState(() {
            servers = locationController.vpnList;
            countries = locationController.countrylist;
            flags = locationController.flaglist;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            servers = widget.serverList;
            countries = widget.countries;
            flags = widget.flags;
          });
        }
      }
    } catch (e) {
      print('Error in getting servers: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationController = Provider.of<LocationProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: const Color(0xFF121A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121A2E),
        title: const Text(
          'Location',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 26),
        ),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Premium Servers Section
          if (premiumServers.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text(
                'Premium Servers',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...premiumServers.map((server) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2C45),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.withOpacity(0.3), width: 1),
              ),
              child: PremiumServerCard(
                server: server,
                onTap: () => _connectToPremiumServer(server),
              ),
            )).toList(),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              height: 1,
              color: Colors.white.withOpacity(0.2),
            ),
          ],

          // Free Servers Section Header
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Text(
              "Free Servers",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Servers List
          Expanded(
            child: Consumer<LocationProvider>(
              builder: (context, locationController, child) {
                if (locationController.isLoading) {
                  return _loadingWidget(context);
                } else if (locationController.vpnList.isEmpty) {
                  return _noVPNFound(context);
                } else {
                  return serversData();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _connectToPremiumServer(PremiumServer server) async {
    try {
      Navigator.pop(context);

      final vpnProvider = Provider.of<VpnProvider>(context, listen: false);
      final ovpnContent = await rootBundle.loadString(server.ovpnAssetPath);

      if (vpnProvider.vpnState == VpnEngine.vpnConnected) {
        VpnEngine.stopVpn();
        await Future.delayed(const Duration(seconds: 2), () {
          vpnProvider.connectWithCustomOVPN(
            ovpnContent: ovpnContent,
            country: server.country,
            username: server.username,
            password: server.password,
          );
        });
      } else {
        await vpnProvider.connectWithCustomOVPN(
          ovpnContent: ovpnContent,
          country: server.country,
          username: server.username,
          password: server.password,
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connecting to ${server.name}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to connect: ${e.toString()}')),
      );
    }
  }

  ///Loading Indicator
  _loadingWidget(context) => SizedBox(
    width: double.infinity,
    height: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ///lottie animation
        LottieBuilder.asset(
          'assets/animation/new_loading.json',
          width: 220,
        ),

        /// loading text
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
          child: const Text(
            'Loading Servers....\nPlease have some Patience. Good Things takes Time😊',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ).animate().fade().slideY(begin: 0.2, end: 0, curve: Curves.easeIn),
        ),
      ],
    ),
  );

  ///InCase there is no Data
  _noVPNFound(context) => Container(
    margin: const EdgeInsets.all(20),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: const Color(0xFF1E2C45),
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.signal_wifi_off,
          size: 70,
          color: Color(0xFF00BCD4),
        ),
        SizedBox(height: 20),
        Text(
          'Sorry, VPNs Not Found! 😔',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );

  serversData() {
    final locationController = Provider.of<LocationProvider>(context);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: countries.length,
      itemBuilder: (context, index) {
        if (index >= countries.length || index >= flags.length) {
          return const SizedBox.shrink();
        }

        final country = countries[index];
        final flag = flags[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF1E2C45),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: locationCard(
            isExpanded: country == expandedCountry,
            countryName: country,
            flag: flag,
            tap: (istap) async {
              setState(() {
                if (expandedCountry == country) {
                  expandedCountry = null;
                  istap = false;
                  servers = locationController.vpnList;
                } else {
                  expandedCountry = country;
                  istap = true;
                  List<Vpn> specificCountryServers = serversForSelectedCountry(country, context);
                  servers = specificCountryServers;
                }
              });
            },
            servers: locationController.vpnList.isEmpty
                ? [const CircularProgressIndicator()]
                : servers.where((server) =>
            server.countryLong.toLowerCase() == country.toLowerCase()
            ).map((server) => VpnCard(vpn: server)).toList(),
          ),
        ).animate().fade(duration: 300.ms);
      },
    );
  }

  List<Vpn> serversForSelectedCountry(String country, context) {
    final locationController = Provider.of<LocationProvider>(context, listen: false);
    List<Vpn> data = locationController.vpnList;
    List<Vpn> myservers = data.where((server) => server.countryLong.toLowerCase() == country.toLowerCase()).toList();
    return myservers;
  }
}

class PremiumServerCard extends StatelessWidget {
  final PremiumServer server;
  final VoidCallback onTap;

  const PremiumServerCard({
    required this.server,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Flag container
            Container(
              height: 32,
              width: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
                image: DecorationImage(
                  image: AssetImage(server.flagAssetPath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Server info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    server.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'Premium Server',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Arrow icon
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}