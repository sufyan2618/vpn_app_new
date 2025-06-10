import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:vpn_app/Handlers/APIs/main_APIs.dart';
import 'package:vpn_app/Handlers/home_provider.dart';
import 'package:vpn_app/Handlers/location_provider.dart';
import 'package:vpn_app/data/services/auth_service.dart';
import 'package:vpn_app/data/services/vpn_Engine.dart';
import 'package:vpn_app/data/Models/ip_Address_Details.dart';
import 'package:vpn_app/data/Models/vpn_main.dart';
import 'package:vpn_app/data/Models/vpn_Status.dart';
import 'package:vpn_app/Views/Screens/IP_details_screen.dart';
import 'package:vpn_app/Views/Screens/Location_screen.dart';
import 'package:vpn_app/Views/Screens/Side_navigationBar.dart';
import 'package:vpn_app/Views/Screens/profile.dart';
import 'package:vpn_app/Views/Screens/register.dart';
import 'package:vpn_app/Views/core/components/Countdown_timer.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Vpn> vpnList = [];
  List<String> countrtylist = [];
  List<String> flaglist = [];
  var ipData;

  late BannerAd _bannerAd;
  bool _isAdLoaded = false;

  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdLoaded = false;

  @override
  void initState() {
    super.initState();
    gettingServers();
    getIPDetails();
    _loadBannerAd();
    _loadInterstitialAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', // Test banner ad
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => _isAdLoaded = true),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('BannerAd failed: ${error.message}');
        },
      ),
    )..load();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712', // Test interstitial ad
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialAdLoaded = true;
        },
        onAdFailedToLoad: (error) {
          print('Interstitial failed to load: ${error.message}');
          _isInterstitialAdLoaded = false;
        },
      ),
    );
  }

  void _showInterstitialAd(VoidCallback afterAd) {
    if (_isInterstitialAdLoaded && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _loadInterstitialAd(); // Preload next ad
          afterAd(); // VPN connect/disconnect logic
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _loadInterstitialAd();
          afterAd(); // Fallback to action
        },
      );

      _interstitialAd!.show();
      _interstitialAd = null;
      _isInterstitialAdLoaded = false;
    } else {
      afterAd(); // If ad not ready, just proceed
    }
  }

  void gettingServers() {
    final locationController = Provider.of<LocationProvider>(context, listen: false);
    locationController.getVpnData();
    locationController.getCountriesData();
    setState(() {
      vpnList = locationController.vpnList;
      countrtylist = locationController.countrylist;
      flaglist = locationController.flaglist;
    });
  }
  
  void getIPDetails() async {
    var ipDetails = IPDetails.fromJson({});
    var details = await APIs.getIPDetails(ipData: ipDetails);
    setState(() {
      ipData = details;
    });
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<VpnProvider>(context);

    VpnEngine.vpnStageSnapshot().listen((event) {
      homeProvider.changevpnState(event);
    });

    return Scaffold(
      backgroundColor: const Color(0xFF121A2E),
      drawer: const SideNavigationBar(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121A2E),
        elevation: 0,
        title: const Text(
          'Wrap VPN',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          authService.getCurrentUserEmail() != null
              ? GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfilePage()),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFF00BCD4),
            child: authService.getCurrentUsernane()!= null && authService.getCurrentUsernane()!.isNotEmpty
                ? Text(
              authService.getCurrentUsernane()![0].toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            )
                : const Icon(Icons.person, color: Colors.white, size: 16),
          ),
        ),
      )
              : TextButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => RegisterPage(
                onSignInPressed: () => Navigator.pop(context),
              )),
            ),
          );
        },
        icon: const Icon(Icons.login, color: Colors.white, size: 16),
        label: const Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xFF1E2C45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      )
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  // Location Selection Button
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2C45),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => LocationScreen(
                              serverList: vpnList,
                              countries: countrtylist,
                              flags: flaglist,
                            )),
                          ),
                        );
                      },
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFF00BCD4),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.location_on, color: Colors.white),
                      ),
                      title: const Text(
                        'Select Country/Location',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // VPN Stats Cards
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Location Card
                      _buildStatCard(
                        title: 'Location',
                        value: homeProvider.vpn.countryLong.isEmpty
                            ? 'Location'
                            : homeProvider.vpn.countryLong,
                        icon: Icons.location_on,
                        countryCode: homeProvider.vpn.countryShort, // Pass country code for flag
                        hasLocation: !homeProvider.vpn.countryLong.isEmpty, // Check if location is selected
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: ((context) => const IPDetailsScreen())),
                          );
                        },
                      ),

                      // Ping Card
                      _buildStatCard(
                        title: 'Ping',
                        value: homeProvider.vpn.countryLong.isEmpty
                            ? 'Ping'
                            : '${homeProvider.vpn.ping} ms',
                        icon: CupertinoIcons.waveform_path_ecg,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Download/Upload Stats
                  StreamBuilder<VpnStatus?>(
                      initialData: VpnStatus(),
                      stream: VpnEngine.vpnStatusSnapshot(),
                      builder: (context, snapshot) {
                        final byteIn = (snapshot.data?.byteIn) ?? 0;
                        final byteOut = (snapshot.data?.byteOut) ?? 0;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Download Card
                            _buildStatCard(
                              title: 'download speed',
                              value: byteIn == 0 ? '0 kbps' : '$byteIn kbps',
                              icon: Icons.arrow_downward_rounded,
                            ),

                            // Upload Card
                            _buildStatCard(
                              title: 'upload speed',
                              value: byteOut == 0 ? '0 kbps' : '$byteOut kbps',
                              icon: Icons.arrow_upward_rounded,
                            ),
                          ],
                        );
                      }
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  _buildConnectButton(homeProvider),
                  const SizedBox(height: 30),
                  // Connection Status
                  Text(
                    homeProvider.vpnState == VpnEngine.vpnDisconnected
                        ? 'Not Connected'
                        : homeProvider.vpnState.toString().replaceAll('_', ' ').toUpperCase(),
                    style: TextStyle(
                      color: homeProvider.vpnState == VpnEngine.vpnConnected
                          ? const Color(0xFF00BCD4)
                          : Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Timer
                  CountDownTimer(
                    startTimer: homeProvider.vpnState == VpnEngine.vpnConnected,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    String? countryCode,
    bool hasLocation = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.42,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2C45),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: Color(0xFF00BCD4),
                shape: BoxShape.circle,
              ),
              child: hasLocation && countryCode != null && countryCode.isNotEmpty
                  ? CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF00BCD4),
                backgroundImage: AssetImage(
                  'assets/flags/${countryCode.toLowerCase()}.png',
                ),
                onBackgroundImageError: (exception, stackTrace) {
                  // Fallback if flag image fails to load
                  print('Error loading flag for $countryCode: $exception');
                },
              )
                  : CircleAvatar(
                backgroundColor: const Color(0xFF00BCD4),
                radius: 20,
                child: Icon(icon, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 5),
            Container(
              height: 20, // Fixed height to prevent layout shifts
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectButton(VpnProvider homeProvider) {
    return GestureDetector(
      onTap: () {
        _showInterstitialAd(() => homeProvider.connectToVpn(context));
      },
      child: Container(
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: homeProvider.getGradientWhiteColor,
          ),
          boxShadow: [
            BoxShadow(
              color: homeProvider.getBoxShadowGradientColor,
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: homeProvider.getGradientWhiteColor,
            ),
          ),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: homeProvider.getButtonColor,
              ),
            ),
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.power_settings_new,
                    size: 40,
                    color: homeProvider.getBoxShadowColor,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    homeProvider.getButtonText,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}







