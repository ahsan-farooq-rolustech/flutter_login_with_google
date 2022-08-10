import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_with_google/GoogleSignInProvider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context)=>GoogleSignInProvoder(),
    child: MaterialApp(
      title: 'Firebase login demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LogInWithGoogle(),
    ),
  );
}

class LogInWithGoogle extends StatefulWidget {
  const LogInWithGoogle({Key? key}) : super(key: key);

  @override
  State<LogInWithGoogle> createState() => _LoginWithGoogleState();
}

class _LoginWithGoogleState extends State<LogInWithGoogle> {
  String userEmail = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("login with google"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("user email"), Text(userEmail)],
          ),
          ElevatedButton(
              onPressed: () async {
                final provider=Provider.of<GoogleSignInProvoder>(context,listen: false);
                provider.googleLoginIn();
                userEmail=provider.user.email;
                String id=provider.user.id;
                // await signInWithGoogle();
                // setState(() {});
              },
              child: Text("Login"))
        ],
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    userEmail=googleUser!.email;

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
