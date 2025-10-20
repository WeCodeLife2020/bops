import 'package:bops_mobile/src/bloc/profile_bloc.dart';
import 'package:bops_mobile/src/bloc/user_auth_bloc.dart';
import 'package:bops_mobile/src/models/user_response_model.dart';
import 'package:bops_mobile/src/screens/home_screens/home_screen.dart';
import 'package:bops_mobile/src/utils/app_assets.dart';
import 'package:bops_mobile/src/utils/app_colors.dart';
import 'package:bops_mobile/src/utils/app_toasts.dart';
import 'package:bops_mobile/src/utils/object_factory.dart';
import 'package:bops_mobile/src/utils/utils.dart';
import 'package:bops_mobile/src/widgets/build_elevated_button_widget.dart';
import 'package:bops_mobile/src/widgets/build_loading_widget.dart';
import 'package:bops_mobile/src/widgets/build_svg_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserAuthBloc userAuthBloc = UserAuthBloc();
  ProfileBloc profileBloc = ProfileBloc();
  bool isLoading = false;
  bool isUpdatingUserData = false;
  bool isAppleLoading = false;
  String? fcmToken;

  Future<void> _getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      fcmToken = token;
      print("FCM Token in Login Page (token): $token");
      print("FCM Token in Login Page (fcmToken): $fcmToken");
    }
  }

  saveUserDetailsAndContinue(UserCredential event) async {
    await _getToken();
    await ObjectFactory().appHive.putEmail(email: event.user?.email ?? "");
    await ObjectFactory().appHive.putUserId(userId: event.user?.uid ?? "");
    await ObjectFactory()
        .appHive
        .putProfilePic(profilePic: event.user?.photoURL ?? "");
    await ObjectFactory().appHive.putIsLoggedIn(isLoggedIn: true);
    await ObjectFactory().appHive.putFcmToken(fcmToken: fcmToken ?? "");

    // print("USER ID: ${ObjectFactory().appHive.getUserId()}");
    // print("USER EMAIL: ${ObjectFactory().appHive.getEmail()}");
    // print("USER NAME: ${ObjectFactory().appHive.getName()}");
    // print("USER PROFILE PICTURE: ${ObjectFactory().appHive.getProfilePic()}");
    // print("USER LOGGED IN STATUS: ${ObjectFactory().appHive.getIsLoggedIn()}");
    await profileBloc.addOrUpdateUser(
        userResponseModel: UserResponseModel(
            userName: event.user?.displayName ?? "",
            userEmail: event.user?.email ?? "",
            userId: event.user?.uid ?? "",
            profilePictureUrl: event.user?.photoURL ?? "",
            fcmToken: fcmToken ?? "",
            userAddress: "",
            userPhoneNumber: "",
            accountType: "user"));
    setState(() {
      isLoading = false;
    });
    pushAndReplacement(context, HomeScreen());
  }

  @override
  void initState() {
    profileBloc.addOrUpdateUserListener.listen((event) {
      print("ADD OR UPDATE USER RESPONSE: ${event.toString()}");
      setState(() {
        isUpdatingUserData = false;
      });
      AppToasts.showSuccessToastTop(
          context, "User data updated successfully!");
    }, onError: (error) {
      setState(() {
        isUpdatingUserData = false;
      });
     AppToasts.showErrorToastTop(context, error);
    });

    userAuthBloc.loginResponse.listen((event) async {
      print("LOGIN EVENT:$event");
      saveUserDetailsAndContinue(event);
      AppToasts.showSuccessToastTop(
          context, "Logged in successfully!");
    }, onError: (error) {
      setState(() {
        isLoading = false;
        isUpdatingUserData=false;
      });
      AppToasts.showErrorToastTop(context, error);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/images/login_image.png',
            fit: BoxFit.cover,
          ),
          // Content Layer
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight(context, dividedBy: 4)),
                Text(
                  "Login to Continue",
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Login to continue your journey with us",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(right: 20, left: 20, bottom: 40),
              child: BuildElevatedButtonWidget(
                width: screenWidth(context, dividedBy: 1.2),
                height: screenHeight(context, dividedBy: 17),
                // txt: "",
                child: isLoading || isUpdatingUserData
                    ? const BuildLoadingWidget(
                        color: AppColors.primaryColorWhite,
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            BuildSvgIcon(
                              assetImagePath: AppAssets.googleIcon,
                              iconHeight: 25,
                            ),
                            const Spacer(),
                            Text(
                              "CONTINUE WITH GOOGLE",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                      ),
                onTap: () {
                  if (!isLoading) {
                    userAuthBloc.login();
                    setState(() {
                      isLoading = true;
                      isUpdatingUserData = true;
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
