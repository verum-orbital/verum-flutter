import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:verum_flutter/resources/auth_methods.dart';
import 'package:verum_flutter/screens/login_screen.dart';
import 'package:verum_flutter/utils/colors.dart';
import 'package:verum_flutter/utils/global_variables.dart';
import 'package:verum_flutter/widgets/text_field_input.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/utils.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  Uint8List? _selectedAvatar;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _pwController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void signUp() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _pwController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: _selectedAvatar);

    if (res == 'success') {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
              webScreenLayout: WebScreenLayout(),
              mobileScreenLayout: MobileScreenLayout())));
    } else {
      showSnackBar(res, context);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void navigateToLoginScreen() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(child: Container(), flex: 2),

          // svg logo
          const Text('WELCOME TO VERUM',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          // SvgPicture.asset('assets/<foo>.svg', color: primaryColor, height: 64)
          const SizedBox(height: 24),

          // Avatar selector
          Stack(
            children: [
              _selectedAvatar != null
                  ? CircleAvatar(
                      radius: 64,
                      backgroundImage: MemoryImage(_selectedAvatar!),
                    )
                  : const CircleAvatar(
                      radius: 64,
                      backgroundImage: NetworkImage(placeholderAvatarImageURL),
                    ),
              Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                      onPressed: () async {
                        // For some reason we need to double-click to select image in iOS Simulator
                        // https://stackoverflow.com/questions/71199859/platformexceptionmultiple-request-cancelled-by-a-second-request-null-null-i
                        Uint8List img = await selectImage(ImageSource.gallery);
                        setState(() {
                          _selectedAvatar = img;
                        });
                      },
                      icon: const Icon(Icons.add_a_photo)))
            ],
          ),

          const SizedBox(height: 24),

          // text fields
          TextFieldInput(
              textEditingController: _usernameController,
              hintText: "Username",
              textInputType: TextInputType.text),

          const SizedBox(height: 24),

          TextFieldInput(
              textEditingController: _emailController,
              hintText: "Email",
              textInputType: TextInputType.emailAddress),

          const SizedBox(height: 24),

          TextFieldInput(
            textEditingController: _pwController,
            hintText: "Password",
            textInputType: TextInputType.text,
            isPassword: true,
          ),

          const SizedBox(height: 24),

          TextFieldInput(
              textEditingController: _bioController,
              hintText: "Bio",
              textInputType: TextInputType.text),

          const SizedBox(height: 24),

          // Signup button
          InkWell(
            onTap: signUp,
            child: Container(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: primaryColor))
                  : const Text(
                      "Sign Up",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  color: blueColor),
            ),
          ),

          const SizedBox(height: 12),

          Flexible(child: Container(), flex: 2),

          // Transition to Sign Up
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: const Text("Already have an account? "),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              GestureDetector(
                onTap: navigateToLoginScreen,
                child: Container(
                  child: const Text(
                    "Login.",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
              )
            ],
          )
        ],
      ),
    )));
  }
}
