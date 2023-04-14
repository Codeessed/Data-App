import 'package:data_app/main.dart';
import 'package:data_app/model/data_model/users_response_model.dart';
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

class EditUserNameScreen extends StatefulWidget{
  const EditUserNameScreen({super.key});

  @override
  State<StatefulWidget> createState() => EditUserNameScreenState();

}

class EditUserNameScreenState extends State<EditUserNameScreen>{

  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var prefs = SharedPreference();

  late UserModel userData;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
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
                      Text('Enter details to edit username'),
                      SizedBox(
                        height: 32,
                      ),
                      Field(
                        hint: "Username",
                        prefixIcon: Icon(Icons.person),
                        controller: _username,
                        textInputType: TextInputType.emailAddress,
                        validate: FieldValidator.required(),
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
                        validate: FieldValidator.required()
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      GeneralButton(
                          text: "Proceed",
                          onTap: () {
                            editUsername(context, viewModel);
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

  void editUsername(BuildContext context, UserViewModel viewModel) {
    if (formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      viewModel.authenticateAndUpdate(
          password: _password.text.trim(),
          id: userData.id,
          key: 'username',
          value: _username.text.trim()
      ).then((response) async {
        if (response.status == 'success'){
          var newUserData = UserModel(email: userData.email, username: _username.text.trim(), phone_number: userData.phone_number, interests: userData.interests, password: userData.password, id: userData.id);
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