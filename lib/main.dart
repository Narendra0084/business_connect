import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'features/auth/data/in_memory_auth_repository.dart';
import 'features/auth/domain/auth_repository.dart';
import 'features/reputation/data/in_memory_reputation_repository.dart';
import 'features/reputation/domain/reputation_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isIOS) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyAsxlQ0MGQ6pPQLmXlSAkZO1bB24GhhaFs',
        appId: '1:517004608949:ios:ed970a6035ad01044fc5fc',
        messagingSenderId: '517004608949',
        projectId: 'biharconnect-db695',
        storageBucket: 'biharconnect-db695.firebasestorage.app',
      ),
    );
  } else {
    await Firebase.initializeApp(
      name: "BiharConnect",
      options: const FirebaseOptions(
        apiKey: "AIzaSyAsxlQ0MGQ6pPQLmXlSAkZO1bB24GhhaFs",
        appId: "1:517004608949:android:f3c5f26293d7d5714fc5fc",
        messagingSenderId: "517004608949",
        projectId: "biharconnect-db695",
      ),
    );
  }
  await FirebaseAppCheck.instance.activate(androidProvider: AndroidProvider.debug, appleProvider: AppleProvider.debug);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (_) => AuthRepositoryImpl(fb.FirebaseAuth.instance, FirebaseFirestore.instance, FirebaseStorage.instance),
        ),

        RepositoryProvider<ReputationRepository>(
          create: (_) => InMemoryReputationRepository(),
        ),
      ],
      child: const BiharBusinessConnectApp(),
    ),
  );
}
