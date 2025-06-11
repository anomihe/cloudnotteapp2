import 'package:cloudnottapp2/src/api_strings/api_quries/user_quries.dart';
import 'package:cloudnottapp2/src/screens/student/free_ai/free_ai_screens/learn_with_ai.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloudnottapp2/src/data/providers/auth_provider.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/join_school_screens/choose_school.dart';
import 'package:cloudnottapp2/src/screens/onboarding_screens/onboarding_screens.dart/walk_throuh.dart';

import '../../../data/providers/user_provider.dart';
import '../../student/student_landing.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = "/auth";
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isAuth = context.read<AuthProvider>().isAuthenticated();
    return isAuth ? const CheckSpace() : const Rolls();
    // return isAuth ? const ChooseSchool() : const Rolls();
  }
}

class CheckSpace extends StatefulWidget {
  const CheckSpace({super.key});

  @override
  State<CheckSpace> createState() => _CheckSpaceState();
}

class _CheckSpaceState extends State<CheckSpace> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userProvider = context.read<UserProvider>();
      userProvider.checkDefaultSpace();

      await userProvider.getSignedUser(context);
      if (userProvider.isDefaultSet) {
        await userProvider.getUserSpaces(context);
      }
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    bool isAuth = userProvider.isDefaultSet;
    String id = userProvider.extraId ?? userProvider.space.first.id ?? "";
    // String alias = userProvider.alias ?? "";

    return isAuth
        ? StudentLandingScreen(id: id, value: userProvider)
        : const ChooseSchool();
  }
}
