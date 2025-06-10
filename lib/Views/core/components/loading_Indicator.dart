import 'package:flutter/material.dart';
import 'package:vpn_app/Views/core/Constant.dart';

class loadingIndicator extends StatelessWidget {
  loadingIndicator();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor:Colors.transparent ,
      child: Container(
        height:60,
        width:MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.transparent,
            borderRadius:BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: white.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child:const Padding(
          padding:  EdgeInsets.all(8),
          child: CircularProgressIndicator(color: IconBluecolor,),
        ),
      ),
    ) ;

  }
}
