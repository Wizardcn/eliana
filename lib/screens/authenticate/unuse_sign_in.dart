// ignore_for_file: avoid_print
import 'package:eliana/services/auth.dart';
import 'package:eliana/shared/constants.dart';
import 'package:eliana/shared/widgets.dart';
import 'package:flutter/material.dart';
import 'package:eliana/shared/loading.dart';
import 'package:eliana/models/app_user.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  const SignIn({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;
  bool _passwordVisible = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  AppBar signInAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      leading: const BackButton(color: Colors.blue),
      elevation: 0.0,
      title: const Text(
        'Sign in to Eliana',
        style: TextStyle(color: Colors.blue),
      ),
      actions: <Widget>[
        ElevatedButton.icon(
            icon: const Icon(
              Icons.person,
              color: Colors.lightBlue,
            ),
            label: const Text('Register'),
            onPressed: () {
              widget.toggleView();
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.transparent, // background
              onPrimary: Colors.blue, // foreground
              elevation: 0.0,
            ))
      ],
    );
  }

  Form signInForm() {
    return Form(
      key: _formkey,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 20.0),
          TextFormField(
            decoration: textInputDecoration.copyWith(hintText: 'Email'),
            validator: (value) => value!.isEmpty ? 'Enter an email' : null,
            onChanged: (value) {
              setState(() => email = value);
            },
          ),
          const SizedBox(height: 20.0),
          TextFormField(
            decoration: textInputDecoration.copyWith(
                hintText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                )),
            validator: (value) =>
                value!.length < 6 ? 'Enter a password 6+ chars long' : null,
            obscureText: !_passwordVisible,
            onChanged: (value) {
              setState(() => password = value);
            },
          ),
          const SizedBox(height: 20.0),
          signInButton(),
          const SizedBox(height: 12.0),
          // forgotPasswordButton(),
          // const SizedBox(height: 12.0),
          helperText(error),
        ],
      ),
    );
  }

  ElevatedButton signInButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_formkey.currentState!.validate()) {
          setState(() {
            loading = true;
          });
          AppUser? result =
              await _auth.signInWithEmailAndPassword(email, password);
          if (result == null) {
            setState(() {
              error = 'could not sign in with those credentials';
              loading = false;
            });
          } else {
            if (!mounted) return;
            Navigator.pop(context);
          }
          setState(() {
            loading = false;
          });
        }
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.blue, // background
        onPrimary: Colors.white, // foreground
      ),
      child: const Text('Sign In'),
    );
  }

  // Widget forgotPasswordButton() {
  //   return TextButton(
  //     onPressed: () {
  //       Navigator.push(
  //           context,
  //           PageRouteBuilder(
  //             pageBuilder: (context, animation1, animation2) => const Forgot(),
  //             transitionDuration: Duration.zero,
  //             reverseTransitionDuration: Duration.zero,
  //           ));
  //     },
  //     child: const Text("forgot password"),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: const Color.fromARGB(255, 169, 217, 240),
            appBar: signInAppBar(),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 40.0),
                child: signInForm(),
              ),
            ));
  }
}
