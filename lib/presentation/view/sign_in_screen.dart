import 'package:data_app/main.dart';
import 'package:data_app/presentation/view/bottom_nav/bottom_nav.dart';
import 'package:data_app/presentation/view/interests_screen.dart';
import 'package:data_app/presentation/view/reset_password_screen.dart';
import 'package:data_app/presentation/view/sign_up_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/loading.dart';
import '../../data/shared_preference.dart';
import '../../helpers/constants/app_color.dart';
import '../../helpers/random.dart';
import '../../model/auth_model/login/login_model.dart';
import '../viewmodel/user_viewmodel.dart';
import 'common/buttons/general_button.dart';
import '../../common/validator.dart';
import 'common/widget/text_field.dart';

class SignInScreen extends StatefulWidget{
  const SignInScreen({super.key});

  @override
  State<StatefulWidget> createState() => SignInScreenState();

}

class SignInScreenState extends State<SignInScreen>{

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var prefs = SharedPreference();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final viewModel = context.watch<UserViewModel>();


    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: LoadingState(
        appState: viewModel.appState,
        child: Scaffold(
          appBar: AppBar(),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Login to your account'),
                      SizedBox(
                        height: 32,
                      ),
                      Field(
                        hint: "Email",
                        prefixIcon: Icon(Icons.email_outlined),
                        controller: _email,
                        textInputType: TextInputType.emailAddress,
                        validate: FieldValidator.required(message: 'This field must contain a minimum of one character'),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Field(
                        hint: "Password",
                        isPassword: true,
                        prefixIcon: Icon(Icons.password),
                        controller: _password,
                        textInputType: TextInputType.visiblePassword,
                        validate: FieldValidator.required(message: 'This field must contain a minimum of one character')
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      GeneralButton(
                          text: "Login",
                          onTap: () {
                            login(context, viewModel);
                          }),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Spacer(),
                          InkWell(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
                              );
                            },
                            child: Text('Forgot Password?'),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Colors.grey),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpScreen(),
                                ), (route) => false
                              );
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: AppColor.secondaryColor),
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

  void validateFields(){
    formKey.currentState!.validate();
  }

  void login(BuildContext context, UserViewModel viewModel) {
    if (formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      viewModel.loginUser(
          LoginModel(email: _email.text.trim(), password: _password.text.trim())
      ).then((response) async {
        if (response.status == 'success'){
          if(response.data!.interests!.isNotEmpty){
            await prefs.setRegistered(response.data);
            await prefs.setLoggedIn(response.data);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => BottomNav()),
                    (route) => false);
          }else{
            await prefs.setRegistered(response.data);
            await prefs.setLoggedIn(response.data);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const InterestScreen()),
                    (route) => false);
          }
        }else{
          RandomFunction.toast(response.message, isError: true);
        }
      },
      );
    } else {
      RandomFunction.toast("Please fill details correctly", isError: true);
    }
  }

}