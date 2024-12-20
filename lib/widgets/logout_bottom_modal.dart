import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pesatrack/screens/auth/login.dart';
import 'package:pesatrack/screens/auth/register.dart';
import 'package:pesatrack/services/auth_service.dart';
import 'package:pesatrack/utils/token_handler.dart';

class LogoutBottomSheetWidget extends StatelessWidget {
  const LogoutBottomSheetWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "Logout",
                    style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.headline6!.color),
                  ),
                  const SizedBox(height: 10),
                  Divider(color: theme.dividerColor),
                  const SizedBox(height: 10),
                  Text(
                    "Are you sure you want to logout?",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.bodyText1!.color,
                        fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: theme.primaryColor),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: ()   {
                          AuthService().signout(context: context);
                             GoogleSignIn().signOut();  // Ensure Google account is signed out too

                          TokenHandler().clearToken();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AuthPage()));
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          backgroundColor: theme.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            'Yes, Logout',
                            style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: theme.textTheme.labelLarge!.color),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
