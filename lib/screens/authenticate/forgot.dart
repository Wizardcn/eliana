import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Forgot extends StatefulWidget {
  const Forgot({Key? key}) : super(key: key);

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  // Explicit
  final formKey = GlobalKey<FormState>();
  String emailString = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method
  Widget content() {
    return Center(
      child: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(50, 200, 50, 240),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "เปลี่ยนรหัสผ่าน",
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 30.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text("*จำเป็น"),
              ],
            ),
            emailText(),
            const SizedBox(
              height: 75.0,
            ),
            resetPasswordButton(),
          ],
        ),
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
            labelText: "อีเมล์*",
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

  Future resetPassword(emailString) async {
    try {
      await _auth.sendPasswordResetEmail(email: emailString).then((response) {
        print("Send Reset Password Success for Email = $emailString");
        showSuccess();
      }).catchError((response) {
        String title = response.code;
        String message = response.message;
        print("title = $title, message = $message");
        myAlert(title, message);
      });
    } catch (err) {
      print(err.toString());
    }
  }

  Widget backButton() {
    return IconButton(
      onPressed: () {
        Navigator.of(context).pop();
        print("Clicked!");
      },
      icon: const Icon(
        Icons.navigate_before_rounded,
        size: 70.0,
        color: Colors.black,
      ),
    );
  }

  void showSuccess() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const ListTile(
              leading: Icon(
                Icons.email,
                size: 48.0,
                color: Colors.green,
              ),
              title: Text(
                "Success",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            actions: [doubleOkButton()],
          );
        });
  }

  Widget okButton() {
    return TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text("OK"));
  }

  Widget doubleOkButton() {
    return TextButton(
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
        child: const Text("OK"));
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
            actions: [okButton()],
          );
        });
  }

  Widget resetPasswordButton() {
    return GestureDetector(
      onTap: () {
        formKey.currentState?.save();
        resetPassword(emailString);
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
            "ส่งอีเมลเพื่อตั้งรหัสผ่านใหม่",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          // display background image
          image: DecorationImage(
            image: AssetImage("assets/bg/auth-bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(children: [
          content(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                child: backButton(),
                label: "กลับไปหน้าเข้าสู่ระบบ",
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
