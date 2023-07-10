import 'package:flutter/material.dart';

class IconCard extends StatelessWidget {
  final String? imagePath;
  final String text;
  final Function? onTap;
  final Color? color;

  const IconCard({super.key, required this.imagePath, required this.text, this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: InkWell(
            onTap: () {
              if (onTap != null) {
                onTap!();
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(imagePath!, width: 100, height: 100,),
                const SizedBox(height: 8.0),
                Text(text ,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
