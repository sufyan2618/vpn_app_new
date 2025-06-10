import 'package:flutter/material.dart';
import 'package:vpn_app/Views/core/Constant.dart';



class DrawerItem extends StatelessWidget {
  final IconData leading;
  final String  title;
  final VoidCallback onTap;
  const DrawerItem({
    required this.leading,
    required this.title,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding:  const EdgeInsets.symmetric(vertical: 6,horizontal: 4),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
              child:  ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (Rect bounds) => blueGradient.createShader(bounds),
                child:   Icon(
                 leading,
                  size: 26,
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 1.0),
              child: Text(title,style:boldStyle.copyWith(fontSize: 14,color: white)),
            ),
          ],
        ),
      ),
    );
  }
}