// ignore_for_file: avoid_print, prefer_const_constructors
import 'package:eliana/models/app_user.dart';
import 'package:eliana/services/auth.dart';
import 'package:eliana/shared/loading.dart';

import 'package:eliana/screens/authenticate/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eliana/services/database.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

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
  final upRegex = RegExp(r"[A-Z]");
  final speRegex = RegExp(r"(?=.[ -/:-@[-`{-~]+)");
  bool _obscureText = true;
  // form key is used to identify the form and we's going to associate our form with this global form state key.

  // text field state
  String username = '';
  String email = '';
  String password = '';
  String error = '';

  AppUser? _appUserFromUser(User? user) {
    // ignore: unnecessary_null_comparison
    return user != null ? AppUser(uid: user.uid) : null;
  }

  // Method

  // Toggles the password show status
  void toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Widget registerButton() {
    return GestureDetector(
      onTap: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState?.save();
          // เก็บข้อมูลลงตัวแปรสำเร็จ
          setState(() {
            loading = true;
          });
          await registerThread(username, email, password);
          await _auth.signOut();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const SignIn(),
            ),
          );
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
            "ลงทะเบียน",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  Future registerThread(String username, String email, String password) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try {
      UserCredential result = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      //     .then((response) {
      //   print("Register Success for Email = $email");
      //   setupDisplayName();
      // }).catchError((response) {
      //   setState(() {
      //     loading = false;
      //   });
      //   String title = response.code;
      //   String message = response.message;
      //   print("title = $title, message = $message");
      //   myAlert(title, message);
      // });
      User? user = result.user;
      // create a new document for the user with the uid
      await DatabaseService(uid: user!.uid).createUserDetail(
          username,
          email,
          password,
          "https://cdn.discordapp.com/attachments/983275821630357534/994459026320543764/userimg2.jpg");
      return _appUserFromUser(user);
    } catch (error) {
      print(error.toString());
    }
    setState(() {
      loading = false;
    });
  }

  Future<void> setupDisplayName() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    var user = firebaseAuth.currentUser;
    if (user != null) {
      user.updateDisplayName(username);

      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) => SignIn());
      Navigator.of(context).pushAndRemoveUntil(
          materialPageRoute, (Route<dynamic> route) => false);
    }
  }

  void myAlert(String title, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: ListTile(
              leading: Icon(
                Icons.add_alert,
                color: Colors.red,
                size: 48.0,
              ),
              title: Text(
                title,
                style: TextStyle(color: Colors.red),
              ),
            ),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        });
  }

  Widget nameText() {
    return Semantics(
      child: TextFormField(
        style: const TextStyle(
          color: Colors.black,
        ),
        decoration: const InputDecoration(
          // icon: Icon(
          //   Icons.face,
          //   color: Colors.purple,
          //   size: 48.0,
          // ),
          labelText: "ชื่อ*",
          labelStyle: TextStyle(
            color: Colors.black,
            fontSize: 16,
            // fontWeight: FontWeight.bold,
          ),
          // helperText: "Type Your Nickname to Display",
          helperStyle: TextStyle(
            color: Colors.black,
            fontStyle: FontStyle.italic,
          ),
        ),
        validator: (String? value) {
          if (value!.isEmpty) {
            return "กรุณากรอกชื่อ";
          } else {
            return null;
          }
        },
        onSaved: (String? value) {
          username = value!.trim();
        },
      ),
      label: "ช่องกรอกชื่อ",
    );
  }

  Widget emailText() {
    return Semantics(
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          // icon: Icon(
          //   Icons.email,
          //   color: Colors.green.shade800,
          //   size: 48.0,
          // ),
          labelText: "อีเมล*",
          labelStyle: TextStyle(
            color: Colors.black,
            fontSize: 16,
            // fontWeight: FontWeight.bold,
          ),
          // helperText: "Type Your Email",
          helperStyle: TextStyle(
            color: Colors.black,
            fontStyle: FontStyle.italic,
          ),
        ),
        validator: (String? value) {
          if (!((value!.contains("@")) && (value.contains(".")))) {
            return "กรุณากรอกอีเมล ในรูปแบบ xxx@xxx.com";
          } else {
            return null;
          }
        },
        onSaved: (String? value) {
          email = value!.trim();
        },
      ),
      label: "ช่องกรอกอีเมล",
    );
  }

  Widget passwordText() {
    return Semantics(
      child: TextFormField(
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          // icon: Icon(
          //   Icons.lock,
          //   color: Colors.black,
          //   size: 48.0,
          // ),
          labelText: "รหัสผ่าน*",
          labelStyle: TextStyle(
            color: Colors.black,
            fontSize: 16,
            // fontWeight: FontWeight.bold,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
              _passwordVisible
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: Colors.grey,
            ),
            onPressed: () {
              // Update the state i.e. toogle the state of passwordVisible variable
              setState(() {
                _passwordVisible = !_passwordVisible;
                _obscureText = !_obscureText;
              });
            },
          ),
          // helperText: "Type Your Password more than 6 Characters",
          helperStyle: TextStyle(
            color: Colors.black,
            fontStyle: FontStyle.italic,
          ),
        ),
        obscureText: _obscureText,
        validator: (String? value) {
          if (!upRegex.hasMatch(value!)) {
            return "ต้องมีตัวพิมพ์ใหญ่อย่างน้อย 1 ตัว";
          }
          if (!speRegex.hasMatch(value)) {
            return "ต้องมีอักขระพิเศษอย่างน้อย 1 ตัว";
          }
          if (value.length < 8) {
            return "ต้องมีความยาวตั้งแต่ 8 ตัวขึ้นไป";
          } else {
            return null;
          }
        },
        onSaved: (String? value) {
          password = value!.trim();
        },
      ),
      label: "ช่องกรอกรหัสผ่าน",
    );
  }

  Widget backButton() {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text(
        "เข้าสู่ระบบ",
        style: TextStyle(
          decoration: TextDecoration.underline,
          color: Colors.blue,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Container(
            decoration: const BoxDecoration(
              // display background image
              image: DecorationImage(
                image: AssetImage("assets/bg/auth-bg.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Scaffold(
              // appBar: AppBar(
              //   backgroundColor: Colors.transparent,
              // title: const Text("Register"),
              // actions: [registerButton()],
              // ),
              body: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                      vertical: 50.0, horizontal: 60.0),
                  children: [
                    Center(
                      child: const Text(
                        "สร้างบัญชี Eliana",
                        style: TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "*จำเป็น",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    nameText(),
                    const SizedBox(
                      height: 20.0,
                    ),
                    emailText(),
                    const SizedBox(
                      height: 20.0,
                    ),
                    passwordText(),
                    const SizedBox(
                      height: 50.0,
                    ),
                    registerButton(),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "มีบัญชีผู้ใช้อยู่แล้ว?   ",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        backButton(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
