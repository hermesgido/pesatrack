import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back_rounded)),
          title: const Text("Privacy Policy"),
          centerTitle: true,
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Information Collection',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: const Color(0xFF6D53F4),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'This Privacy Policy describes how PesaTrack ("we", "us", or "our") collects, uses, and discloses personal information when you use our finance management app.',
                      style: GoogleFonts.inter(
                          fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Information Usage',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: const Color(0xFF6D53F4),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'We use the collected information to provide and improve our services, including expense tracking, income management, and financial planning. Your information may be used for analytics purposes to understand user preferences and behavior. We may also use your email address to send promotional and informational emails about our services. You can opt-out of receiving promotional emails at any time.',
                      style: GoogleFonts.inter(
                          fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'This Privacy Policy describes how PesaTrack ("we", "us", or "our") collects, uses, and discloses personal information when you use our finance management app.',
                      style: GoogleFonts.inter(
                          fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Information Sharing and Disclosure',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: const Color(0xFF6D53F4),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'We may share your personal information with third-party service providers to help us operate and improve our app. Your information may also be disclosed in response to legal requirements, such as subpoenas or court orders, or to protect our rights, property, or safety. We retain your personal information for as long as necessary to fulfill the purposes outlined in this Privacy Policy.',
                      style: GoogleFonts.inter(
                          fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Your Choices',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: const Color(0xFF6D53F4),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'You have the right to access, update, and delete your personal information. You can manage your account settings within the app to update or delete your information.',
                      style: GoogleFonts.inter(
                          fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'You may also contact us to request assistance with managing your information or to opt-out of certain communications. However, please note that some information may be retained in our records even after deletion, as required by law or for legitimate business purposes.',
                      style: GoogleFonts.inter(
                          fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        )));
  }
}
