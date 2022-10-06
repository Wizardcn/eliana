import 'package:eliana/bloc/ex_sounds_bloc/ex_sounds_bloc.dart';
import 'package:eliana/bloc/user_detail_bloc/user_detail_bloc.dart';

import 'package:eliana/screens/authenticate/forgot.dart';
import 'package:eliana/screens/authenticate/register.dart';
import 'package:eliana/screens/home/home_page.dart';
import 'package:eliana/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool loading = false;

  final _formKey = GlobalKey<FormState>();
  String emailString = "", passwordString = "";
  bool _passwordVisible = false;
  bool _obscureText = true;

  // Toggles the password show status
  void toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Widget content() {
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            showAppName(),
            emailText(),
            const SizedBox(
              height: 15.0,
            ),
            passwordText(),
            const SizedBox(
              height: 50.0,
            ),
            loginButton(),
            const SizedBox(
              height: 15.0,
            ),
            registerButton(),
            forgotPassword(),
          ],
        ),
      ),
    );
  }

  Widget showAppName() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          child: showLogo(),
          label: "Eliana",
        ),
        // showText(),
      ],
    );
  }

  Widget showLogo() {
    return Container(
      width: 125.0,
      height: 125.0,
      child: Image.asset("assets/logo/auth-logo.png"),
    );
  }

  Widget showText() {
    return Text(
      "eliana",
      style: TextStyle(
        fontSize: 30.0,
        color: Colors.orange.shade700,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        // fontFamily: "Caveat",
      ),
    );
  }

  Widget emailText() {
    return Container(
      width: 250.0,
      child: Semantics(
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            // icon: Icon(
            //   Icons.email,
            //   size: 36.0,
            //   color: Colors.blue.shade700,
            // ),
            labelText: "อีเมล์",
            labelStyle: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          onSaved: (String? value) {
            emailString = value.toString().trim();
          },
        ),
        label: "ช่องกรอกอีเมล์",
      ),
    );
  }

  Widget passwordText() {
    return Container(
      width: 250.0,
      child: Semantics(
        child: TextFormField(
          decoration: InputDecoration(
            // icon: Icon(
            //   Icons.lock,
            //   size: 36.0,
            //   color: Colors.blue.shade700,
            // ),
            labelText: "รหัสผ่าน",
            labelStyle: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                // Based on passwordVisible state choose the icon
                _passwordVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: Colors.grey,
                semanticLabel: _passwordVisible
                    ? "กดเพื่อปกปิดรหัสผ่าน"
                    : "กดเพื่อแสดงรหัสผ่าน",
              ),
              onPressed: () {
                // Update the state i.e. toogle the state of passwordVisible variable
                setState(() {
                  _passwordVisible = !_passwordVisible;
                  _obscureText = !_obscureText;
                });
              },
            ),
          ),
          obscureText: _obscureText,
          onSaved: (String? value) {
            passwordString = value.toString().trim();
          },
        ),
        label: "ช่องกรอกรหัสผ่าน",
      ),
    );
  }

  Widget loginButton() {
    return GestureDetector(
      onTap: () async {
        if (_formKey.currentState!.validate()) {
          setState(() {
            loading = true;
          });
          _formKey.currentState?.save();
          print("email = $emailString, password = $passwordString");
          await checkAuthen();

          setState(() {
            loading = false;
          });
        }
      },
      child: Container(
        height: 44,
        width: 305,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Color.fromRGBO(177, 199, 250, 1.0),
        ),
        child: const Center(
          child: Text(
            "เข้าสู่ระบบ",
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }

  Widget registerButton() {
    return GestureDetector(
      onTap: () {
        MaterialPageRoute materialPageRoute = MaterialPageRoute(
            builder: (BuildContext context) => const Register());
        Navigator.of(context).push(materialPageRoute);
      },
      child: Container(
        height: 44,
        width: 305,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromRGBO(177, 199, 250, 1.0),
            width: 3,
          ),
          borderRadius: BorderRadius.circular(50),
          color: Colors.transparent,
        ),
        child: const Center(
          child: Text(
            "ลงทะเบียน",
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }

  Future<void> checkAuthen() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try {
      await firebaseAuth
          .signInWithEmailAndPassword(
              email: emailString, password: passwordString)
          .then((response) {
        print("Authen Success");

        User? user = response.user;

        // ----------- bloc session ---------------
        BlocProvider.of<UserDetailBloc>(context)
            .add(AuthenticatedEvent(user!.uid));

        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext context) => Home());
        Navigator.of(context).pushAndRemoveUntil(
            materialPageRoute, (Route<dynamic> route) => false);
        BlocProvider.of<ExSoundsBloc>(context).add(HomeIsOpenedEvent());
        // ----------------------------------------
      }).catchError((response) {
        String title = response.code;
        String message = response.message;
        myAlert(title, message);
      });
    } catch (error) {
      print(error.toString());
    }
  }

  Widget showTitle(String title) {
    return ListTile(
      leading: const Icon(
        Icons.add_alert,
        size: 48.0,
        color: Colors.red,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget okButton() {
    return TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text("OK"));
  }

  void myAlert(String title, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: showTitle(title),
            content: Text(message),
            actions: [okButton()],
          );
        });
  }

  Widget forgotPassword() {
    return TextButton(
      onPressed: () {
        MaterialPageRoute materialPageRoute = MaterialPageRoute(
            builder: (BuildContext context) => const Forgot());
        Navigator.of(context).push(materialPageRoute);
      },
      child: const Text(
        "ลืมรหัสผ่าน?",
        style: TextStyle(color: Colors.grey, fontSize: 14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Container(
            decoration: const BoxDecoration(
              // color: Colors.white,
              // display background image
              image: DecorationImage(
                image: AssetImage("assets/bg/auth-bg.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Scaffold(
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 50.0, horizontal: 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      content(),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
