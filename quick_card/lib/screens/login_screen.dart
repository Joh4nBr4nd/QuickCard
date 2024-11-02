// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:quick_card/screens/home_screen.dart';
import 'package:quick_card/screens/registration_screen.dart';
import 'package:quick_card/service/auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final AuthService _authService = AuthService();

  String errorMessage = '';
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _stayLoggedIn = true;

  Future<void> _handleLogin() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Login and set error message if any
    String? error = await _authService.login(username, password, _stayLoggedIn);
    setState(() {
      errorMessage = error ?? '';
      if (error == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Center(
            child: SingleChildScrollView(
              child: Container(

                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/background.jpg'),
                    fit: BoxFit.cover,

                  ),
                ),
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: <Widget>[

                    // Profile photo at the top
                    Padding(
                padding: EdgeInsets.only(top: 20, bottom: 20), // Padding for spacing
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:[
                    ClipOval(
                  child: Image.asset(
                    'assets/greenlight.png', // Replace with your image path
                    width: 150.0,
                    height: 170.0,
                    opacity: const AlwaysStoppedAnimation(.6),
                ),
              ),
              SizedBox(width: 20), // Space between the two images
              // Second circular image
              ClipOval(
                child: Image.asset(
                  'assets/purplelight.png', // Second image path
                  width: 170.0, // Adjust width
                  height: 150.0, // Adjust height
                  opacity: const AlwaysStoppedAnimation(0.6),
                  fit: BoxFit.cover,
                ),
              ),
                  ],
                ),
                    ),

                    Center(
                      child: Column(
                        children: [
                          Text(
                            'welcome to',
                            style: TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'quick',
                                  style: TextStyle(
                                    fontSize: 52.0,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: 'card',
                                  style: TextStyle(
                                    fontSize: 52.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF382EF2),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.0),
                    // Login subtitle
                    Center(
                      child: Text(
                        'login to your account',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    // Error message (initially invisible)
                    Visibility(
                      visible: errorMessage.isNotEmpty,
                      child: Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    // Username input field with user icon and lighter purple background
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'username',
                        filled: true,
                        fillColor: Color(0xFFDEDCFB),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Padding(
                          //Inserted image in text field
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/user.png',
                            width: 15,
                            height: 15,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 25.0),
                    // Password input field with lock icon and lighter purple background
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'password',
                        filled: true,
                        fillColor: Color(0xFFDEDCFB),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Padding(
                          //Inserted image in text field
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/lock.png',
                            width: 15,
                            height: 15,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 4.0),
                    CheckboxListTile(
                      title: Text('remember me?'),
                      value: _stayLoggedIn,
                      onChanged: (value) {
                        setState(() {
                          _stayLoggedIn = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    // Login button with bold black text
                    SizedBox(height: 40.0),
                    ElevatedButton(
                      onPressed: () {
                        _handleLogin();
                      },
                      style: ElevatedButton.styleFrom(

                        backgroundColor: Color (0xff8EE4DF), // Background color
                        foregroundColor: Colors.black, // Text color
                      ),
                      child: Text(
                        'login',
                        style: TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationScreen()));
                        },
                        child: Text.rich(
                          TextSpan(
                            text: "don't have an account? ",
                            children: [
                              TextSpan(
                                text: 'sign up', // Bold text
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
        )

    );
  }
}
