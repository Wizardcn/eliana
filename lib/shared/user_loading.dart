import 'package:eliana/shared/constants.dart';
import 'package:eliana/shared/custom_icon.dart';
import 'package:flutter/material.dart';

class UserLoading extends StatelessWidget {
  const UserLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            primary: grey,
            shape: const CircleBorder(),
            backgroundColor: blue,
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Icon(
              CustomIcon.user,
              size: 40,
              color: white,
            ),
          ),
        ),
        Text("กำลังโหลด")
      ],
    );
  }
}
