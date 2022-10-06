import 'package:eliana/screens/authenticate/sign_in.dart';
import 'package:eliana/screens/home/home_page.dart';
import 'package:eliana/models/app_user.dart';
// import 'package:elaina/screens/authenticate/auth_intro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);

    // return either Home or Authenticate widget
    if (user == null) {
      // return const Authenticate();
      return const SignIn();
    } else {
      return const Home();
    }
  }
}
