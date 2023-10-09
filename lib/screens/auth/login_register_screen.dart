import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:outwork_web_app/assets/app_color_palette.dart';
import 'package:outwork_web_app/screens/auth/auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? errorMessage = '';
  bool isLogin = true;

  bool _obscurePassword = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerPasswordConfirmation =
      TextEditingController();

  final TextEditingController _controllerName = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(
        () {
          errorMessage = e.message;
        },
      );
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    if (_controllerName.text.length < 12) {
      try {
        await Auth().createUserWithEmailAndPassword(
          email: _controllerEmail.text,
          password: _controllerPassword.text,
          name: _controllerName.text,
        );
      } on FirebaseAuthException catch (e) {
        setState(() {
          errorMessage = e.message;
        });
      }
    } else {
      setState(() {
        errorMessage = 'Name must be less than 12 characters.';
      });
    }
  }

  Widget _entryField(String title, TextEditingController controller,
      bool maxLenght, bool passwordField) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      child: TextField(
        inputFormatters:
            maxLenght ? [LengthLimitingTextInputFormatter(12)] : null,
        obscureText: passwordField? _obscurePassword : passwordField,
        controller: controller,
        decoration: InputDecoration(
          labelText: title,
          suffixIcon: passwordField? IconButton(
            icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off, color: TeAppColorPalette.white),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ) : null,
        ),
      ),
    );
  }

  Widget _errorMessage() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Text(errorMessage == '' ? '' : "$errorMessage",
          style: const TextStyle(color: Colors.red)),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: () {
          if (isLogin) {
            signInWithEmailAndPassword();
          } else {
        if (_controllerPassword.text == _controllerPasswordConfirmation.text) {

            createUserWithEmailAndPassword();
          } else {
          setState(() {
            errorMessage = 'Passwords do not match';
          });
        } }
        
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            isLogin ? 'Login' : 'Register',
            style:
                const TextStyle(fontSize: 16, color: TeAppColorPalette.black),
          )),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(
        isLogin ? 'Register Instead' : 'Login Instead',
        style: const TextStyle(color: TeAppColorPalette.white),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TeAppColorPalette.black,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              !isLogin
                  ? _entryField(' Name', _controllerName, true, false)
                  : const SizedBox(),
              _entryField(' Email', _controllerEmail, false, false),
              _entryField(' Password', _controllerPassword, false, true),
              !isLogin
                  ? _entryField('Repeat Password',
                      _controllerPasswordConfirmation, false, true)
                  : const SizedBox(),
              _errorMessage(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _submitButton(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _loginOrRegisterButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
