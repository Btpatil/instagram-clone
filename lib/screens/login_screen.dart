import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/main.dart';
import 'package:instagram/resources/auth_methods.dart';
import 'package:instagram/responsive/web_screen_layout.dart';
import 'package:instagram/screens/home_page.dart';
import 'package:instagram/screens/sign_up_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/global_variables.dart';
import 'package:instagram/utils/utils.dart';
import 'package:instagram/widgets/text_field_inout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  void logInUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);

    setState(() {
      isLoading = false;
    });

    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return MyApp();
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: MediaQuery.of(context).size.width > webScreenSize
                ? EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 3)
                : const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.95,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Container(),
                  flex: 2,
                ),
                SvgPicture.asset(
                  "assets/ic_instagram.svg",
                  color: Colors.white,
                  height: 64,
                ),
                const SizedBox(
                  height: 64,
                ),
                TextFeildInput(
                  textEditingController: _emailController,
                  hintText: "Enter Your Email",
                  textInputType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: 24,
                ),
                TextFeildInput(
                  textEditingController: _passwordController,
                  hintText: "Enter Your Password",
                  textInputType: TextInputType.text,
                  isPass: true,
                ),
                SizedBox(
                  height: 24,
                ),
                InkWell(
                  onTap: logInUser,
                  child: Container(
                    child: isLoading
                        ? CircularProgressIndicator(
                            // backgroundColor: Colors.black,
                            color: Colors.white,
                          )
                        : Text("Log In"),
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      color: blueColor,
                    ),
                  ),
                ),
                Flexible(
                  child: Container(),
                  flex: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text("Dont have an Account?"),
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return SignUpScreen();
                            },
                          ),
                        );
                      },
                      child: Container(
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: blueColor,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
