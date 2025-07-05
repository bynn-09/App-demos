import 'package:demosapp/Loadingpage.dart';
import 'package:flutter/material.dart';
import 'package:demosapp/Homepage.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,

              // gradient: LinearGradient(
              //   begin: Alignment.topCenter,
              //   end: Alignment.bottomCenter,
              //   colors: [
              //     Colors.greenAccent.shade200,
              //     Colors.greenAccent,
              //     Colors.white,
              //   ],
              // ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 120.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 400, // Set a max width for larger screens
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Selamat Datang!',
                      style: TextStyle(
                        color: Colors.green,
                        fontFamily: 'OpenSans',
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                     Text(
                      'di Estrakulikuler App development',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.green,
                        fontFamily: 'OpenSans',
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30.0),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        icon: Icon(Icons.email, color: Colors.black),
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.0),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock, color: Colors.black),
                        label: Text('Password'),
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Loadingscreen(),
                            ),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => ChatWhatsApp()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          backgroundColor: Colors.green,
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
