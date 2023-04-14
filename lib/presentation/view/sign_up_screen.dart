import 'package:data_app/data/shared_preference.dart';
import 'package:data_app/helpers/random.dart';
import 'package:data_app/model/data_model/users_response_model.dart';
import 'package:data_app/presentation/view/common/buttons/general_button.dart';
import 'package:data_app/presentation/view/interests_screen.dart';
import 'package:data_app/presentation/view/sign_in_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/loading.dart';
import '../../helpers/constants/app_color.dart';
import '../viewmodel/user_viewmodel.dart';
import '../../common/validator.dart';
import 'common/widget/text_field.dart';

class SignUpScreen extends StatefulWidget{
  const SignUpScreen({super.key});

  @override
  State<StatefulWidget> createState() => SignUpScreenState();


}

class SignUpScreenState extends State<SignUpScreen>{

  final TextEditingController _email = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _password = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var prefs = SharedPreference();

  @override
  void initState() {
    super.initState();
    // _email.addListener(validateFields);
    // _phoneNumber.addListener(validateFields);
    // _userName.addListener(validateFields);
    // _password.addListener(validateFields);
  }

  @override
  void dispose() {
    _email.dispose();
    _phoneNumber.dispose();
    _userName.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<UserViewModel>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: LoadingState(
        appState: model.appState,
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
                      Text('Create a Data App account'),
                      SizedBox(
                        height: 5,
                      ),
                      Text('Step 1/2', style: TextStyle(
                        color: Colors.purple.shade300,
                        fontSize: 15,
                        fontWeight: FontWeight.w500
                      ),),
                      SizedBox(
                        height: 32,
                      ),
                      Field(
                        hint: "Email",
                        prefixIcon: Icon(Icons.email_outlined),
                        controller: _email,
                        textInputType: TextInputType.emailAddress,
                        validate: FieldValidator.email(),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Field(
                        hint: "User Name",
                        prefixIcon: Icon(Icons.person_outline_outlined),
                        controller: _userName,
                        validate: FieldValidator.minLength(3),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Field(
                        hint: "Phone Number",
                        prefixIcon: Icon(Icons.phone_outlined),
                        controller: _phoneNumber,
                        textInputType: TextInputType.phone,
                        validate: FieldValidator.length(11),
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
                        validate: FieldValidator.minLength(5),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      GeneralButton(
                          text: "Sign Up",
                          onTap: () {
                            createAccount(context, model);
                          }),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Colors.grey),
                          ),
                          GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignInScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "Sign In",
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

  void createAccount(BuildContext context, UserViewModel viewModel) {
    if (formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      viewModel.addUser(
        UserModel(
            email: _email.text.trim(),
          username: _userName.text.trim(),
          phone_number: _phoneNumber.text.trim(),
          password: _password.text.trim(),
          interests: [],
          id: ''
        )
      ).then((response) async {
          if (response.status == 'success') {
            await prefs.setRegistered(response.data);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const InterestScreen()),
                    (route) => false);
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