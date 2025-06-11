// import 'dart:developer';
// import 'dart:io';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class GoogleService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn(
//     scopes: [
//       'email',
//     ],
//   );

//   // Sign in with Google
//   Future<String?> signInWithGoogle() async {
//     try {
//       // Handle iOS differently to avoid disconnection issues
//       if (Platform.isIOS) {
//         return await _signInWithGoogleOnIOS();
//       } else {
//         return await _signInWithGoogleOnAndroid();
//       }
//     } catch (e) {
//       log('Error signing in with Google: $e');
//       return null;
//     }
//   }

//   Future<String?> _signInWithGoogleOnIOS() async {
//     final GoogleSignInAccount? googleUser =
//         _googleSignIn.currentUser ?? await _googleSignIn.signInSilently();

//     final GoogleSignInAccount? signedInUser =
//         googleUser ?? await _googleSignIn.signIn();

//     if (signedInUser == null) {
//       return null;
//     }

//     try {
//       final GoogleSignInAuthentication googleAuth =
//           await signedInUser.authentication;

//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       await _auth.signInWithCredential(credential);
//       return googleAuth.idToken;
//     } catch (e) {
//       log('iOS authentication error: $e');
//       await Future.delayed(Duration(milliseconds: 300));
//       try {
//         final GoogleSignInAuthentication googleAuth =
//             await signedInUser.authentication;
//         final credential = GoogleAuthProvider.credential(
//           accessToken: googleAuth.accessToken,
//           idToken: googleAuth.idToken,
//         );
//         await _auth.signInWithCredential(credential);
//         return googleAuth.idToken;
//       } catch (retryError) {
//         log('Retry failed: $retryError');
//         return null;
//       }
//     }
//   }

//   Future<String?> _signInWithGoogleOnAndroid() async {
//     // Trigger the authentication flow
//     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

//     if (googleUser == null) {
//       return null; // User canceled the sign-in flow
//     }

//     final GoogleSignInAuthentication googleAuth =
//         await googleUser.authentication;

//     final credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );
//     await _auth.signInWithCredential(credential);
//     return googleAuth.idToken;
//   }

//   // Sign out
//   Future<void> signOut() async {
//     await _auth.signOut();
//     await _googleSignIn.signOut();
//   }

//   // Get current user
//   User? getCurrentUser() {
//     return _auth.currentUser;
//   }
// }

import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', "profile"],
    // serverClientId:
  );

  // Sign in with Google
  Future<String?> signInWithGoogle() async {
    try {
      // Handle iOS differently to avoid disconnection issues
      if (Platform.isIOS) {
        return await _signInWithGoogleOnIOS();
      } else {
        return await _signInWithGoogleOnAndroid();
      }
    } catch (e) {
      log('Error signing in with Google: $e');
      return null;
    }
  }

  Future<String?> _signInWithGoogleOnIOS() async {
    // Fixed syntax error here
    final GoogleSignInAccount? googleUser =
        _googleSignIn.currentUser ?? await _googleSignIn.signInSilently();
    final GoogleSignInAccount? signedInUser =
        googleUser ?? await _googleSignIn.signIn();

    if (signedInUser == null) {
      return null;
    }

    try {
      final GoogleSignInAuthentication googleAuth =
          await signedInUser.authentication;

      // Add token validation
      final String? idToken = googleAuth.idToken;
      _validateToken(idToken, 'iOS - First attempt');

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: idToken,
      );
      await _auth.signInWithCredential(credential);
      return idToken;
    } catch (e) {
      log('iOS authentication error: $e');
      await Future.delayed(Duration(milliseconds: 300));
      try {
        final GoogleSignInAuthentication googleAuth =
            await signedInUser.authentication;

        // Add token validation for retry
        final String? idToken = googleAuth.idToken;
        _validateToken(idToken, 'iOS - Retry attempt');

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: idToken,
        );
        await _auth.signInWithCredential(credential);
        return idToken;
      } catch (retryError) {
        log('Retry failed: $retryError');
        return null;
      }
    }
  }

  Future<String?> _signInWithGoogleOnAndroid() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      return null; // User canceled the sign-in flow
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Add token validation
    final String? idToken = googleAuth.idToken;
    _validateToken(idToken, 'Android');

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: idToken,
    );
    await _auth.signInWithCredential(credential);
    return idToken;
  }

  // Add this method to validate tokens
  void _validateToken(String? token, String context) {
    if (token == null) {
      log('$context: Token is null');
      return;
    }

    log('$context: Token length: ${token.length}');
    final segments = token.split('.');
    log('$context: Token segments: ${segments.length}');

    if (segments.length != 3) {
      log('$context: INVALID TOKEN - Expected 3 segments, got ${segments.length}');
      log('$context: Token: $token');
    } else {
      log('$context: Token is valid (3 segments)');
      // Log first and last 50 characters to check for truncation
      log('$context: Token starts: ${token.substring(0, 50)}...');
      log('$context: Token ends: ...${token.substring(token.length - 50)}');
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
