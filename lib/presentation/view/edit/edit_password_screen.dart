import 'package:data_app/main.dart';
import 'package:data_app/model/data_model/users_response_model.dart';
import 'package:data_app/presentation/view/bottom_nav/bottom_nav.dart';
import 'package:data_app/presentation/view/auth/interests_screen.dart';
import 'package:data_app/presentation/view/auth/reset_password_screen.dart';
import 'package:data_app/presentation/view/auth/sign_up_screen.dart';
import 'package:data_app/presentation/view/common/text/headerText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/loading.dart';
import '../../../data/shared_preference.dart';
import '../../../helpers/constants/app_color.dart';
import '../../../helpers/random.dart';
import '../../../model/auth_model/login/login_model.dart';
import '../../viewmodel/user_viewmodel.dart';
import '../common/buttons/general_button.dart';
import '../../../common/validator.dart';
import '../common/widget/text_field.dart';

class EditPasswordScreen extends StatefulWidget{
  const EditPasswordScreen({super.key});

  @override
  State<StatefulWidget> createState() => EditPasswordScreenState();

}

class EditPasswordScreenState extends State<EditPasswordScreen>{

  var password = '';
  final TextEditingController _oldPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var prefs = SharedPreference();

  late UserModel userData;

  @override
  void initState() {
    super.initState();
    _newPassword.addListener(updatePassword);
  }

  @override
  void dispose() {
    _oldPassword.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final viewModel = context.watch<UserViewModel>();

    getUserData();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: LoadingState(
        appState: viewModel.appState,
        child: Scaffold(
          appBar: AppBar(title: Text('Edit Password')),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeaderText(
                        Colors.black,
                          'Enter details to edit password'),
                      SizedBox(
                        height: 32,
                      ),
                      Field(
                        hint: "Old Password",
                        prefixIcon: Icon(Icons.person),
                        controller: _oldPassword,
                        textInputType: TextInputType.emailAddress,
                        validate: FieldValidator.required(),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Field(
                        hint: "New Password",
                        isPassword: true,
                        prefixIcon: Icon(Icons.password),
                        controller: _newPassword,
                        textInputType: TextInputType.visiblePassword,
                        validate: FieldValidator.minLength(5)
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Field(
                          hint: "Confirm Password",
                          isPassword: true,
                          prefixIcon: Icon(Icons.password),
                          controller: _confirmPassword,
                          textInputType: TextInputType.visiblePassword,
                          validate: FieldValidator.equalTo(password)
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      GeneralButton(
                          text: "Proceed",
                          onTap: () {
                            editPassword(context, viewModel);
                          }),
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

  getUserData() async {
    userData = UserModel.fromJson(await prefs.getLoggedIn());
  }

  updatePassword(){
    setState(() {
      password = _newPassword.text;
    });
  }


  void editPassword(BuildContext context, UserViewModel viewModel) {
    if (formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      viewModel.authenticateAndUpdate(
          password: _oldPassword.text.trim(),
          id: userData.id,
          key: 'password',
          value: _newPassword.text.trim()
      ).then((response) async {
        if (response.status == 'success'){
          var newUserData = UserModel(email: userData.email, username: userData.username, phone_number: userData.phone_number, password: _newPassword.text.trim(), id: userData.id, interests: userData.interests);
          await prefs.setLoggedIn(newUserData);
          viewModel.setUser(newUserData);
          RandomFunction.toast(response.message, isError: false);
          Navigator.pop(context);
        }else{
          RandomFunction.toast(response.message, isError: true);
        }
      }, onError: (e) => RandomFunction.toast('An error occurred -> $e', isError: true));
    } else {
      RandomFunction.toast("Please fill details correctly", isError: true);
    }
  }

}