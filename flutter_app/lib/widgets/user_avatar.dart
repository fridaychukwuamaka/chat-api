import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    this.backgroundColor,
  }) ;

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: backgroundColor,
          ),
          Positioned(
            bottom: 2,
            right: 2,
            child: Icon(
              Icons.circle,
              size: 12,
              color: Colors.green,
            ),
          )
        ],
      ),
      height: 50,
      width: 50,
    );
  }
}
