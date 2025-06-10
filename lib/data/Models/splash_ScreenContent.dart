class SplashScreenContent {
  String image;
  String title;
  String discription;

  SplashScreenContent({ required this.image, required this.title, required this.discription});
}

List<SplashScreenContent> contents = [
  SplashScreenContent(
    title: 'Ironclad Online Security',
    image: 'assets/images/secure.svg',
    discription: "Say goodbye to digital threats! Our VPN wraps your data in military-grade encryption, shielding you from trackers, hackers, and spies. Browse fearlessly with complete peace of mind.",
  ),
  SplashScreenContent(
    title: 'Blazing Fast Speeds',
    image: 'assets/images/fast_loading.svg',
    discription: "Go full throttle! Experience lightning-fast downloads, seamless streaming, and ultra-responsive browsing — all powered by our performance-optimized servers. Speed meets security like never before.",
  ),
  SplashScreenContent(
    title: 'Turbocharged Global Servers',
    image: 'assets/images/server.svg',
    discription: "Connect to a world of possibilities. Our powerful global servers deliver lightning-fast, uninterrupted access to content across the globe. No lags, no limits — just pure, high-speed freedom.",
  ),
];
