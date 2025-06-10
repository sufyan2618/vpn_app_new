
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vpn_app/Views/core/Constant.dart';

class alertBox extends StatelessWidget {
  final String txt;
  alertBox({required this.txt});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor:Colors.white,

        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0)
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              // color: App,
              height: 170,
              width: 280,
              child: Padding(
                padding:  const EdgeInsets.fromLTRB(10, 30, 10, 8),
                child: Column(
                  children: [
                    const Expanded(child: Padding(
                      padding:  EdgeInsets.only(top: 8.0),
                      child: Text('Alert ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19,color: Colors.black),textAlign: TextAlign.center),
                    )),
                    Expanded(flex:2,child: Padding(
                      padding:  const EdgeInsets.only(bottom: 8.0),
                      child: Center(child: Text(txt, style: const TextStyle(fontSize: 14,color: Colors.black),textAlign: TextAlign.center,)),
                    )),
                    Expanded(
                      child: MaterialButton(onPressed: (){
                        Navigator.pop(context);
                      },
                        color: IconBluecolor,
                        child: const Text('Okay', style: TextStyle(color: Colors.white),),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const Positioned(
                top: -20,
                child: CircleAvatar(
                  backgroundColor: IconBluecolor,
                  radius: 25,
                  child: Icon(Icons.check, color: Colors.white, size: 25,),
                )
            ),
          ],
        )
    );
  }
}
