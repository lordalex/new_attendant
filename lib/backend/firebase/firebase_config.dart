import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyAPH-6jESxwygQkq2Aukn_sqAsZqYx9F_A",
            authDomain: "knex-attendant-25.firebaseapp.com",
            projectId: "knex-attendant-25",
            storageBucket: "knex-attendant-25.firebasestorage.app",
            messagingSenderId: "839302273645",
            appId: "1:839302273645:web:ada71112f88491ed45fd64"));
  } else {
    await Firebase.initializeApp();
  }
}
