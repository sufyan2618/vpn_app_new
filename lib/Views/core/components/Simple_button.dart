import 'package:flutter/material.dart';
import 'package:vpn_app/Views/core/Constant.dart';


class SimpleButton extends StatelessWidget {
  final String btnText;
  final VoidCallback tap;
  const SimpleButton({super.key, required this.btnText,required this.tap});

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: tap,
      child: Container(
        height:60,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: IconBluecolor,
          borderRadius: BorderRadius.circular(6),
          gradient: const LinearGradient(

            begin: Alignment.bottomCenter,
            end:Alignment.topCenter,
              colors: [
                blue,
                gradientblue
              ],
          )
        ),
        margin: const EdgeInsets.symmetric(horizontal:5,vertical: 9 ),
        child: Center(child: Text(btnText,style: btntext)) ,
      ),
    );
  }
}
