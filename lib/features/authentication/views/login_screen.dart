import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/views/login_form_screen.dart';
import 'package:tiktok_clone/features/authentication/view_models/social_auth_view_model.dart';
import 'package:tiktok_clone/features/authentication/views/widgets/auth_button.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:tiktok_clone/utils.dart';

class LoginScreen extends ConsumerWidget {
  static String routeName = "login";
  static String routeURL = "/login";
  const LoginScreen({super.key});

  void _onSignUpTap(BuildContext context) {
    context.pop();
  }

  void _onEmailLoginTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginFormScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.size40,
          ),
          child: Column(
            children: [
              Gaps.v80,
              Text(
                S.of(context).logInToTiktok("TikToK!"),
                style: const TextStyle(
                  fontSize: Sizes.size24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gaps.v20,
              const Opacity(
                opacity: 0.7,
                child: Text(
                  "Manage your account, check notifications, comment on videos, and more.",
                  style: TextStyle(
                    fontSize: Sizes.size16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Gaps.v40,
              AuthButton(
                icon: const FaIcon(FontAwesomeIcons.user),
                text: "Use email & password",
                onTap: _onEmailLoginTap,
              ),
              Gaps.v16,
              AuthButton(
                onTap: ref.read(socialAuthProvider.notifier).githubSignIn,
                icon: const FaIcon(FontAwesomeIcons.github),
                text: "Continue with Github",
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: isDarkMode(context) ? null : Colors.grey.shade50,
        child: Padding(
          padding: const EdgeInsets.only(
            top: Sizes.size28,
            bottom: Sizes.size56,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Don\'t have an account?',
                style: TextStyle(
                  fontSize: Sizes.size16,
                ),
              ),
              Gaps.h5,
              GestureDetector(
                onTap: () => _onSignUpTap(context),
                child: Text(
                  'Sign up',
                  style: TextStyle(
                    fontSize: Sizes.size16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
