import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vpn_app/Views/core/Constant.dart';

class locationCard extends StatelessWidget {
  final String countryName;
  final  String flag;
  final  Function(bool value) tap;
  final List<Widget> servers;
  final bool isExpanded;

const locationCard({required this.isExpanded,required this.servers,required this.tap,required this.flag,required this.countryName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ExpansionTile(
             shape: Border.all(color: Colors.transparent),


              onExpansionChanged: tap,
              leading: Container(
                    height: 38,
                    width: 48,
                    decoration: BoxDecoration(
            border: Border.all(color: gray.withOpacity(0.2)),
                    image: DecorationImage(
                        image: AssetImage('assets/flags/${flag.toLowerCase()}.png',
                    ),fit: BoxFit.fill )),

                    ),

              title: Text(countryName,style: boldStyle.copyWith(fontSize: 16,color: white),),
               trailing: IconButton(
                    icon: Icon( isExpanded ? Icons.keyboard_arrow_up_sharp :Icons.keyboard_arrow_down_rounded,color:white ,size: 25,),
                    onPressed: (){

                    }
                    ),
                    children: isExpanded ? servers: [],
            ),
            const Divider(color: dividerColor,indent: 5,endIndent: 5,)
          ],
        ),
      ),
    );
  }
}
