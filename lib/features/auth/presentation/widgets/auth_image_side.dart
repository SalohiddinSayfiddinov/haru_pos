import 'package:flutter/material.dart';
import 'package:haru_pos/core/assets/app_images.dart';

class AuthImageSide extends StatelessWidget {
  const AuthImageSide({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Image(
            width: double.infinity,
            height: double.infinity,
            image: AssetImage(AppImages.authImage),
            fit: BoxFit.cover,
          ),
          Container(
            color: Color(0xFF444D48).withValues(alpha: .35),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'HARU',
                    style: TextStyle(
                      fontSize: 70.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: .8,
                    ),
                  ),
                  Text(
                    'pos system',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
