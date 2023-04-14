import 'dart:collection';
import 'dart:math';

import 'package:data_app/data/shared_preference.dart';
import 'package:data_app/model/data_model/users_response_model.dart';
import 'package:data_app/presentation/view/auth/interests_screen.dart';
import 'package:data_app/presentation/view/auth/splash_screen.dart';
import 'package:data_app/presentation/viewmodel/user_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/auth_model/login/login_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserViewModel()),
      ],
      child: const MyApp()
    )
      // const MyApp()
  );
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}