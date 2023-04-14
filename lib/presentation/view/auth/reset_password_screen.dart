import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/loading.dart';
import '../../../common/validator.dart';
import '../../../helpers/constants/app_color.dart';
import '../../../helpers/random.dart';
import '../../viewmodel/user_viewmodel.dart';
import '../common/buttons/general_button.dart';
import '../common/widget/text_field.dart';

class ResetPasswordScreen extends StatefulWidget{
  const ResetPasswordScreen({super.key});

  @override
  State<StatefulWidget> createState() => ResetPasswordScreenState();

}

class ResetPasswordScreenState extends State<ResetPasswordScreen>{

  var password = '';
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _password.addListener(updatePassword);
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
                      Text('Reset your password'),
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
                          hint: "New Password",
                          isPassword: true,
                          prefixIcon: Icon(Icons.password),
                          controller: _password,
                          textInputType: TextInputType.visiblePassword,
                          validate: FieldValidator.minLength(5)
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Field(
                          hint: "Confirm New Password",
                          isPassword: true,
                          prefixIcon: Icon(Icons.password),
                          controller: _confirmPassword,
                          textInputType: TextInputType.visiblePassword,
                          validate: FieldValidator.equalTo(password, message: 'Passwords do not match')
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      GeneralButton(
                          text: "Reset",
                          onTap: () {
                            resetAccount(context, viewModel);
                          }),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Spacer(),
                          TextButton.icon(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.arrow_back),
                              label: Text('Back to Login')
                          )
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

  updatePassword(){
    setState(() {
      password = _password.text;
    });
  }

  void resetAccount(BuildContext context, UserViewModel viewModel) {
    if (formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      viewModel.resetPassword(
          email: _email.text.trim(),
          password: _password.text.trim()
      ).then((response) async {
        if (response.status == 'success') {
          Navigator.pop(context);
          RandomFunction.toast(response.message, isError: false);
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