import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vpn_app/Handlers/APIs/main_APIs.dart';
import 'package:vpn_app/data/Models/ip_Address_Details.dart';

import 'package:vpn_app/Views/core/components/IP_detail_card.dart';

class IPDetailsScreen extends StatefulWidget {
  const IPDetailsScreen({Key? key}) : super(key: key);

  @override
  _IPDetailsScreenState createState() => _IPDetailsScreenState();
}

class _IPDetailsScreenState extends State<IPDetailsScreen> {
  var data;

  @override
  void initState() {
    getData();
    super.initState();
  }

  ///Getting IP Details
  getData() async {
    var ipData = IPDetails.fromJson({});
    var d = await APIs.getIPDetails(ipData: ipData);
    data = d;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121A2E),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFF121A2E),
        elevation: 0,
        title: const Text(
          'IP Address Details',
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
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 26,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              // Header section with illustration
              Container(
                height: 180,
                margin: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2C45),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: const BoxDecoration(
                          color: Color(0xFF00BCD4),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          CupertinoIcons.globe,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        data?.query ?? 'Fetching IP...',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Your Current IP Address',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // IP Details List
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // Internet Provider
                    _buildDetailCard(
                      icon: CupertinoIcons.antenna_radiowaves_left_right,
                      title: 'Internet Provider',
                      value: data?.isp ?? 'Loading...',
                    ),

                    // Location
                    _buildDetailCard(
                      icon: CupertinoIcons.location_solid,
                      title: 'Location',
                      value: (data != null && data.country != null && data.country.isNotEmpty)
                          ? '${data.city}, ${data.regionName}, ${data.country}'
                          : 'Fetching...',
                    ),

                    // Pin-code
                    _buildDetailCard(
                      icon: Icons.lock_outlined,
                      title: 'Pin-code',
                      value: data?.zip ?? 'Loading...',
                    ),

                    // Timezone
                    _buildDetailCard(
                      icon: CupertinoIcons.time,
                      title: 'Timezone',
                      value: data?.timezone ?? 'Loading...',
                    ),

                    // // Additional details
                    // _buildDetailCard(
                    //   icon: CupertinoIcons.globe,
                    //   title: 'Country Code',
                    //   value: data?.countryCode ?? 'Loading...',
                    // ),
                    //
                    _buildDetailCard(
                      icon: CupertinoIcons.map,
                      title: 'Region',
                      value: data?.regionName ?? 'Loading...',
                    ),
                  ],
                ).animate().fade(duration: 400.ms).slideY(begin: 0.2, end: 0, duration: 400.ms, curve: Curves.easeOut),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
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
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Color(0xFF00BCD4),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Container(
          height: 22,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
