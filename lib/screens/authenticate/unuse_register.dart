import 'package:eliana/models/app_user.dart';
import 'package:eliana/services/auth.dart';
import 'package:eliana/shared/constants.dart';
import 'package:eliana/shared/loading.dart';
import 'package:eliana/shared/widgets.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  const Register({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool _passwordVisible = false;
  RegExp emailRegEx = RegExp(r"^[a-z0-9._]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$",
      caseSensitive: false);
  // form key is used to identify the form and we's going to associate our form with this global form state key.

  // text field state
  String username = '';
  String email = '';
  String password = '';
  String error = '';

  AppBar registerAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      leading: const BackButton(color: Colors.blue),
      elevation: 0.0,
      title: const Text(
        'Sign up to Eliana',
        style: TextStyle(color: Colors.blue),
      ),
      actions: <Widget>[
        ElevatedButton.icon(
            icon: const Icon(
              Icons.person,
              color: Colors.lightBlue,
            ),
            label: const Text('Sign In'),
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

  ElevatedButton registerButton() {
    return ElevatedButton(
      onPressed: () async {
        // check if our form is valid which is we click on this button and this function fires
        // validate method uses validator property in form field.
        if (_formKey.currentState!.validate()) {
          setState(() {
            loading = true;
          });
          AppUser? result = await _auth.registerWithEmailAndPassword(
              username, email, password);
          if (result == null) {
            setState(() {
              error = 'Please supply a valid email';
              loading = false;
            });
          }
          setState(() {
            loading = false;
          });
          // back to sign in page automatically
          widget.toggleView();
          await _auth.signOut();
        }
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.blue, // background
        onPrimary: Colors.white, // foreground
      ),
      child: const Text('Register'),
    );
  }

  Form registerForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 20.0),
          TextFormField(
            decoration: textInputDecoration.copyWith(hintText: 'Username'),
            validator: (value) =>
                value!.isEmpty ? 'Please enter your username' : null,
            onChanged: (value) {
              setState(() => username = value);
            },
          ),
          const SizedBox(height: 20.0),
          TextFormField(
            decoration: textInputDecoration.copyWith(hintText: 'Email'),
            validator: (value) => !emailRegEx.hasMatch(value!)
                ? 'Sorry, only letters (a-z), numbers (0-9), and periods (.) are allowed'
                : null,
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
          registerButton(),
          const SizedBox(height: 12.0),
          helperText(error)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: const Color.fromARGB(255, 169, 217, 240),
            appBar: registerAppBar(),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 40.0),
                child: registerForm(),
              ),
            ));
  }
}
