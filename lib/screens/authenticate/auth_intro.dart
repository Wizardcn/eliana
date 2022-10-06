import 'package:eliana/screens/authenticate/authenticate.dart';
import 'package:flutter/material.dart';

class AuthIntroScreen extends StatefulWidget {
  const AuthIntroScreen({Key? key}) : super(key: key);

  @override
  State<AuthIntroScreen> createState() => _AuthIntroScreenState();
}

class _AuthIntroScreenState extends State<AuthIntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            Authenticate(showSignIn: true),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ));
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.blue[300], // background
                    onPrimary: Colors.white, // foreground
                    fixedSize: const Size(100, 50)),
                child: const Text('Sign In'),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            Authenticate(showSignIn: false),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ));
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.blue[300], // background
                    onPrimary: Colors.white, // foreground
                    fixedSize: const Size(100, 50)),
                child: const Text('Register'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
