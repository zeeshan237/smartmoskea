import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_moskea/pages/BeforeLoggedInMainScreen.dart';

class AuthServices {
  // ignore: unused_field
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void signOut(context) {
    FirebaseAuth.instance.signOut();
    //FirebaseUser user = FirebaseAuth.instance.currentUser;
    //print('$user');
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => BeforeLoggedInMainScreen()));
    // runApp(new MaterialApp(
    //   home: new BeforeLoggedInMainScreen(),
    // ));
  }

//   handleAuth()
//   {
//     return StreamBuilder(
//       stream: FirebaseAuth.instance.onAuthStateChanged,
//       builder:(BuildContext context, snapshot)
//         {
//           if(snapshot.hasData)
//           {
//             return LoggedInMainScreen();

//           }
//           else
//           {
//              return BeforeLoggedInMainScreen();

//           }
//         }
//       );
//   }

//   final FirebaseAuth _auth = FirebaseAuth.instance;

//     Future<FirebaseUser> getUser() {
//     return _auth.currentUser();
//   }

//     Future logout(BuildContext context) async {
//    var result = FirebaseAuth.instance.signOut();

//     return result;

}

//  //SignOut
//   signOut()
//   {
//     FirebaseAuth.instance.signOut();
//   }

//   //SignIN
//   signIn(AuthCredential authCredential)
//   {
//      FirebaseAuth.instance.signInWithCredential(authCredential);
//   }

//   handleErrorForSignIn(PlatformException error,BuildContext context) {
//     print(error);
//     switch (error.code) {
//       case 'ERROR_INVALID_EMAIL':
//         //toast.showToast('Invalid Email', context);
//         break;
//       case 'ERROR_WRONG_PASSWORD':
//         //toast.showToast('Wrong Password', context);
//         break;
//       case 'ERROR_USER_NOT_FOUND':
//         //toast.showToast('User Not Found', context);
//         break;
//       case 'ERROR_TOO_MANY_REQUESTS':
//         //toast.showToast('Too Many Attempts', context);
//         break;
//       case 'ERROR_OPERATION_NOT_ALLOWED':
//         // toast.showToast('Operation Not Allowed', context);
//         break;
//       default:
//     }
//   }

//   signInWithOTPCode(smsCode, verId)
//   {
//     AuthCredential authCredential = PhoneAuthProvider.getCredential(
//       verificationId: verId,
//       smsCode: smsCode);
//     signIn(authCredential);
//   }
// }
