/*
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import './login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'search_screen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  StreamSubscription<User> loginStateSubscription;

  @override
  void initState() {
    final authService = context.read(authServiceProvider);

    loginStateSubscription = authService.currentUser.listen((fbUser) {
      if (fbUser == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    loginStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.read(authServiceProvider);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => SearchScreen(),
                ),
              ),
            ),
            Center(
              child: StreamBuilder<User>(
                  stream: authService.currentUser,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return CircularProgressIndicator();
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(snapshot.data.displayName,
                            style: TextStyle(fontSize: 35.0)),
                        SizedBox(
                          height: 20.0,
                        ),
                        CircleAvatar(
                          backgroundImage: NetworkImage(snapshot.data.photoURL
                              .replaceFirst('s96', 's400')),
                          radius: 60.0,
                        ),
                        SizedBox(
                          height: 100.0,
                        ),
                        SignInButton(Buttons.Google,
                            text: 'Sign Out of Google',
                            onPressed: () => authService.logout())
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

*/
