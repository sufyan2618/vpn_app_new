import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpn_app/Handlers/home_provider.dart';
import 'package:vpn_app/Handlers/pref_storage.dart';
import 'package:vpn_app/Views/core/Constant.dart';
import 'package:vpn_app/data/services/vpn_Engine.dart';
import 'package:vpn_app/data/Models/vpn_main.dart';





class VpnCard extends StatelessWidget {
   final Vpn vpn;
  const VpnCard({Key? key, required this.vpn}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final vpnProvider = Provider.of<VpnProvider>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
       height: 60,
      child: InkWell(
        onTap: () {
          vpnProvider.vpn = vpn;
          Pref.vpn = vpn;
          Navigator.pop(context);
          if (vpnProvider.vpnState == VpnEngine.vpnConnected) {
            VpnEngine.stopVpn();
            Future.delayed(
                const Duration(seconds: 2), () => vpnProvider.connectToVpn(context));
          } else {
            vpnProvider.connectToVpn(context);
           }
        },
        child: ListTile(
          // shape:
          // RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),

         /// flag
            ///
          leading: Container(
              height: 30,
              width: 38,
              decoration: BoxDecoration(border: Border.all(color: gray.withOpacity(0.2)),
                  image: DecorationImage(
                      image: AssetImage('assets/flags/${vpn.countryShort.toLowerCase()}.png',
                  ),fit: BoxFit.fill ))),


          ///title
          title: Text(vpn.countryLong,style: boldStyle.copyWith(fontSize: 15,color: white),),

          ///subtitle
          subtitle: Row(
            children: [
              Image.asset('assets/images/Internetspeed.png',color: IconBluecolor,height: 20,),
              const SizedBox(width: 4),
              Text(_formatBytes(vpn.speed, 1), style: MediumStyle.copyWith(color:MediumGray,fontSize: 13))
            ],
          ),

        ),
      ),
    );
  }

  String _formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ['Bps', "Kbps", "Mbps", "Gbps", "Tbps"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }
}
