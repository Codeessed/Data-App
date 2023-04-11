import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget{
  const SignUpScreen({super.key});

  @override
  State<StatefulWidget> createState() => SignUpScreenState();


}

class SignUpScreenState extends State<SignUpScreen>{
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: LoadingState(
        appState: model.appState,
        child: Scaffold(
          appBar: appbar(),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                            text: "Create a ",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 24,
                                color: Colors.black),
                            children: [
                              TextSpan(
                                text: "$appName\n",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24,
                                    color: AppColor.secondaryColor),
                              ),
                              TextSpan(
                                text: "account",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24,
                                    color: Colors.black),
                              )
                            ]),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      HeaderThreeText(appPrimaryColor, 'Step 1/2'),
                      SizedBox(
                        height: 32.h,
                      ),
                      Field(
                        hint: "User Name",
                        prefixIcon: SvgPicture.asset(
                          AppImage.iconProfile,
                          height: 10,
                        ),
                        controller: _userName,
                        validate: FieldValidator.minLength(3),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Field(
                        hint: "First Name",
                        prefixIcon: SvgPicture.asset(
                          AppImage.iconProfile,
                          height: 10,
                        ),
                        controller: _firstName,
                        validate: FieldValidator.minLength(3),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Field(
                        hint: "Email",
                        prefixIcon: SvgPicture.asset(
                          AppImage.iconEmail,
                          height: 10,
                        ),
                        controller: _email,
                        textInputType: TextInputType.emailAddress,
                        validate: FieldValidator.email(),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Field(
                        hint: "Learning Goal",
                        prefixIcon: SvgPicture.asset(
                          AppImage.iconCourses,
                          height: 10,
                        ),
                        controller: _learningGoal,
                        validate: FieldValidator.minLength(3),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Row(
                        children: [
                          interest.isEmpty
                              ? SizedBox()
                              : TechText(
                              "${interest.length} interest selected"),
                          TextButton.icon(
                              onPressed: () {
                                getInterest(context);
                              },
                              icon: Icon(
                                Icons.add_circle_outline,
                                color: AppColor.secondaryColor,
                              ),
                              label: TechText("Add interest")),
                        ],
                      ),
                      SizedBox(
                        height: 35.h,
                      ),
                      GenericButtonAlt(
                          text: "Next >>",
                          onTap: () {
                            createAccount(context, model);
                          }),
                      SizedBox(
                        height: 15.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignIn(),
                                ),
                              );
                            },
                            child: RichText(
                              text: const TextSpan(
                                  text: "Already have an account? ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Colors.grey),
                                  children: [
                                    TextSpan(
                                      text: "Sign In",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                          color: AppColor.secondaryColor),
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

  }

  // void createAccount(BuildContext context, UserViewModel viewModel) {
  //   if (formKey.currentState!.validate()) {
  //     FocusScope.of(context).unfocus();
  //     viewModel.initialSignUpVerification(
  //       {
  //         "userName": _userName.text.trim(),
  //         "firstName": _firstName.text.trim(),
  //         "email": _email.text,
  //         "interests": interest,
  //         "learningGoal": _learningGoal.text.trim(),
  //       },
  //     ).then(
  //           (value) {
  //         if (value == true) {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => const SignUpTwo(),
  //             ),
  //           );
  //         }
  //       },
  //     );
  //   } else {
  //     RandomFunction.toast("Validation failed, fill form correctly",
  //         isError: true);
  //   }
  // }


}