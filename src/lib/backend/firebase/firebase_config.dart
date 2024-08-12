import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDDklsnnezn_rP7CftS7iNBEjV-tMxE-lc",
            authDomain: "ai-bot-34ebe.firebaseapp.com",
            projectId: "ai-bot-34ebe",
            storageBucket: "ai-bot-34ebe.appspot.com",
            messagingSenderId: "309181490870",
            appId: "1:309181490870:web:4676881cd8907dcf6d2817",
            measurementId: "G-CR8P00FWYM"));
  } else {
    await Firebase.initializeApp();
  }
}
