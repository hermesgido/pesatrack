import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:pesatrack/providers/authprovider.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      try {
        await authProvider.registerUser(email, password, context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: ['email'],
    );

    Future<void> signInWithGoogle() async {
      try {
        // Step 1: Initiate Google Sign-In
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        // Step 2: Retrieve authentication tokens
        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;

        final String? accessToken = googleAuth?.accessToken;
        final String? idToken = googleAuth?.idToken;

        if (idToken != null && accessToken != null) {
          // Step 3: Print tokens (for debugging) and send the idToken to your Django backend
          print("ID Token: $idToken");
          print("Access Token: $accessToken");

          // Send the idToken to your Django backend for verification
          // await sendGoogleTokenToBackend(idToken);
        }
      } catch (error) {
        // Handle any errors that occur during sign-in
        print('Error signing in with Google: $error');
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Register",
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                buttonItem(
                  "assets/google.svg",
                  "Continue with Google",
                  25,
                  () async {
                    signInWithGoogle();
                    // _handleGoogleSignIn();
                    // await authClass.googleSignIn(context);
                  },
                ),
                const SizedBox(height: 15),
                const Text(
                  "Or",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      textItem("Email", _emailController, false),
                      const SizedBox(height: 15),
                      textItem("Password", _passwordController, true),
                      const SizedBox(height: 15),
                      colorButton("Sign Up", authProvider),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "Already have an Account?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                          (route) => false,
                        );
                      },
                      child: const Text(
                        " Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buttonItem(
      String imagePath, String buttonName, double size, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width - 60,
        height: 60,
        child: Card(
          elevation: 8,
          color: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                imagePath,
                height: size,
                width: size,
              ),
              const SizedBox(width: 15),
              Text(
                buttonName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textItem(
      String name, TextEditingController controller, bool obsecureText) {
    return Container(
      width: MediaQuery.of(context).size.width - 70,
      child: TextFormField(
        controller: controller,
        obscureText: obsecureText,
        style: const TextStyle(
          fontSize: 17,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          labelText: name,
          labelStyle: const TextStyle(
            fontSize: 17,
            color: Colors.white,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              width: 1.5,
              color: Colors.amber,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
          errorStyle: const TextStyle(
            color: Colors.red,
            fontSize: 12,
          ),
          errorMaxLines: 1,
        ),
        validator: (value) {
          if (name == "Email") {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
              return 'Please enter a valid email address';
            }
          } else if (name == "Password") {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            } else if (value.length < 4) {
              return 'Password must be at least 4 characters long';
            }
          }
          return null;
        },
      ),
    );
  }

  Widget colorButton(String name, AuthProvider authProvider) {
    return InkWell(
      onTap: () async {
        await _register();
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 90,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF6D53F4),
              Color(0xFF6D53F4),
              Color(0xFF6D53F4),
            ],
          ),
        ),
        child: Center(
          child: authProvider.isLoading
              ? const CircularProgressIndicator()
              : Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }
}
