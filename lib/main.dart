import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clumpcoder/home.dart';
import 'package:clumpcoder/widgets/progress.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget example1 = SplashScreenView(
      navigateRoute: SecondScreen(),
      duration: 3000,
      imageSize: 130,
      imageSrc:
          "https://th.bing.com/th/id/OIP.VDm2OjlSxHqajY-YKOGQjAHaE8?pid=ImgDet&rs=1",
      text: "Splash Screen",
      textType: TextType.ColorizeAnimationText,
      textStyle: TextStyle(
        fontSize: 40.0,
      ),
      colors: [
        Colors.purple,
        Colors.blue,
        Colors.yellow,
        Colors.red,
      ],
      backgroundColor: Colors.white,
    );

    return MaterialApp(
      title: 'Splash screen Demo',
      home: example1,
    );
  }
}

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  final usersRef = FirebaseFirestore.instance.collection('users');

  final GoogleSignIn googleSignIn = new GoogleSignIn();

  TextEditingController email = TextEditingController();

  TextEditingController pass = TextEditingController();
  var authc = FirebaseAuth.instance;
  //FacebookLogin _facebookLogin = FacebookLogin();
  var progress = false;
  handleSignIn1() async {
    if (email.toString().length >= 1 && pass.toString().length >= 6) {
      try {
        await authc.signInWithEmailAndPassword(
            email: email.text, password: pass.text);
        pass.clear();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home(email.text)));

        Fluttertoast.showToast(
            msg: "Succesfully Login",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        setState(() {
          progress = false;
        });
      } catch (e) {
        if (e.toString() ==
            "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.") {
          Fluttertoast.showToast(
              msg: "Wrong Password",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          setState(() {
            progress = false;
          });
        } else if (e.toString() ==
            "[firebase_auth/invalid-email] The email address is badly formatted.") {
          Fluttertoast.showToast(
              msg: "Email address is Badly Formatted",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          setState(() {
            progress = false;
          });
        } else if (e.toString() ==
            "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.") {
          await authc.createUserWithEmailAndPassword(
              email: email.text, password: pass.text);
          pass.clear();

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Home(email.text)));
          email.clear();
          Fluttertoast.showToast(
              msg: "SuccessFully SignUp",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          setState(() {
            progress = false;
          });
        } else if (e.toString() ==
            "[firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later.") {
          Fluttertoast.showToast(
              msg: "Try Again Later",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          setState(() {
            progress = false;
          });
        }
      }
    } else {
      Fluttertoast.showToast(
          msg: "all textfield must be filled ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      Fluttertoast.showToast(
          msg: "password length should be greater than 6",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        progress = false;
      });
    }
  }

  final DateTime timeStamp = DateTime.now();

  bool isAuth = false;

  login() async {
    await googleSignIn.signIn();

    createUserInFirestore();
  }

  createUserInFirestore() async {
    final GoogleSignInAccount user = googleSignIn.currentUser!;
    DocumentSnapshot doc = await usersRef.doc(user.id).get();
    if (!doc.exists) {
      usersRef.doc(user.id).set({
        'id': user.id,
        'photoUrl': user.photoUrl,
        'email': user.email,
        "timestamp": timeStamp
      });
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Home(user.displayName)));
    }
    if (doc.exists) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Home(user.displayName)));
    }
  }

  // Future fbLogIn() async {
  //   FacebookLoginResult _result = await _facebookLogin.logIn(['email']);
  //   switch (_result.status) {
  //     case FacebookLoginStatus.cancelledByUser:
  //       print("Cancel By User");
  //       break;
  //     case FacebookLoginStatus.error:
  //       print("error");
  //       break;
  //     case FacebookLoginStatus.loggedIn:
  //       await _logInWithFacebook(_result);
  //       break;
  //     default:
  //   }
  // }

  // Future _logInWithFacebook(FacebookLoginResult _result) async {
  //   FacebookAccessToken _accessToken = _result.accessToken;
  //   AuthCredential _credential =
  //       FacebookAuthProvider.credential(_accessToken.token);
  //   var a = await authc.signInWithCredential(_credential);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login SignUp Page'),
      ),
      body: Container(
          child: Column(
        children: <Widget>[
          progress ? circularProgress() : Text(''),
          TextField(
            keyboardType: TextInputType.emailAddress,
            controller: email,
            decoration: InputDecoration(
              hintText: 'Enter Your Email',
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),

              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue)),
              isDense: true, // Added this
              contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 10),
            ),
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.black),
          ),
          TextField(
            keyboardType: TextInputType.emailAddress,
            controller: pass,
            decoration: InputDecoration(
              hintText: 'Enter Your Password',
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),

              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue)),
              isDense: true, // Added this
              contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 10),
            ),
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.black),
          ),
          TextButton(
              onPressed: () {
                handleSignIn1();
              },
              child: Text('Sign In ')),
          TextButton(
              onPressed: () {
                login();
              },
              child: Text('Sign In With Google')),
          TextButton(
              onPressed: () {
                //          fbLogIn();
              },
              child: Text('Sign In With Facebook'))
        ],
      )),
    );
  }
}
