// login screen

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_scanner/screens/home/home.dart';
import 'package:qr_scanner/services/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService();
  late String email;
  late String password;

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Email ID',
          style: TextStyle(
            fontFamily: 'Product Sans',
            color: Color(0xFFA0A0A0),
          ),
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 60.0,
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'Product Sans',
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Color(0XFFFF7D54),
              ),
              hintText: 'Enter your Email',
              hintStyle: TextStyle(
                fontFamily: 'Product Sans',
                color: Color(0xFFA0A0A0),
              ),
            ),
            validator: (_val) {
              if (_val!.isEmpty) {
                return "Can't be empty";
              } else {
                return null;
              }
            },
            onChanged: (val) {
              email = val;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Password',
          style: TextStyle(
            fontFamily: 'Product Sans',
            color: Color(0xFFA0A0A0),
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 60.0,
          child: TextFormField(
            obscureText: true,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'Product Sans',
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Color(0XFFFF7D54),
              ),
              hintText: 'Enter your Password',
              hintStyle: TextStyle(
                fontFamily: 'Product Sans',
                color: Color(0xFFA0A0A0),
              ),
            ),
            validator: (_val) {
              if (_val!.isEmpty) {
                return "Can't be empty";
              } else {
                return null;
              }
            },
            onChanged: (val) {
              password = val;
            },
          ),
        ),
      ],
    );
  }

// edit this widget
  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () => print('Forgot Password Button Pressed'),
        padding: EdgeInsets.only(right: 0.0),
        child: const Text(
          'Forgot Password?',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontFamily: 'Product Sans',
          ),
        ),
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 3.0,
        onPressed: () => _auth.emailLogin(email.trim(), password).whenComplete(
          () {
            final User? user = FirebaseAuth.instance.currentUser;

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage(uid: user!.uid)),
            );
          },
        ),
        padding: const EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: const Color(0XFFFF7D54),
        child: const Text(
          'LOGIN',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Product Sans',
          ),
        ),
      ),
    );
  }

  Widget _buildSignInWithText() {
    return Column(
      children: const <Widget>[
        Text(
          '- OR -',
          style: TextStyle(
            color: Colors.grey,
            fontFamily: 'Product Sans',
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          'Sign In with',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontFamily: 'Product Sans',
          ),
        ),
      ],
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 60.0,
              width: 60.0,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 6.0,
                  ),
                ],
                image: DecorationImage(
                  image: AssetImage(
                    'assets/twitter.png',
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _auth.logInWithFacebook(context).whenComplete(
              () {
                final User? user = FirebaseAuth.instance.currentUser;

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => HomePage(uid: user!.uid)),
                );
              },
            ),
            child: Container(
              height: 60.0,
              width: 60.0,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 6.0,
                  ),
                ],
                image: DecorationImage(
                  image: AssetImage(
                    'assets/facebook.jpg',
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _auth.googleLogin().whenComplete(
              () {
                final User? user = FirebaseAuth.instance.currentUser;

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => HomePage(uid: user!.uid)),
                );
              },
            ),
            child: Container(
              height: 60.0,
              width: 60.0,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 6.0,
                  ),
                ],
                image: DecorationImage(
                  image: AssetImage(
                    'assets/google.png',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupBtn() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GestureDetector(
        onTap: () {
          print('Sign Up Button Pressed');
          Navigator.of(context).pushNamed('/signup');
        },
        child: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Don\'t have an Account? ',
                style: TextStyle(
                  fontFamily: 'Product Sans',
                  color: Colors.grey,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: 'Sign Up',
                style: TextStyle(
                  fontFamily: 'Product Sans',
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(40.0, 30.0, 40.0, 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: 60.0,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: FlatButton(
                            child: const Text(
                              'Guest Mode',
                              style: TextStyle(
                                  fontFamily: 'Product Sans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                  color: Color(0xFF1E1E1E)),
                            ),
                            onPressed: () async {
                              dynamic result = await _auth.signInAnon();
                              if (result == null) {
                                print('Error signing in');
                              } else {
                                print('Signed In');
                                print(result.uid);
                              }
                            },
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          children: [
                            const Text(
                              'Sign In',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Product Sans',
                                fontWeight: FontWeight.bold,
                                fontSize: 30.0,
                              ),
                            ),
                            const SizedBox(height: 30.0),
                            _buildEmailTF(),
                            const SizedBox(height: 30.0),
                            _buildPasswordTF(),
                            _buildForgotPasswordBtn(),
                            _buildLoginBtn(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      _buildSignInWithText(),
                      _buildSocialBtnRow(),
                      _buildSignupBtn(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
