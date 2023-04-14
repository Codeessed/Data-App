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

class BuddiesScreen extends StatefulWidget{
  const BuddiesScreen({super.key});

  @override
  State<StatefulWidget> createState() => BuddiesScreenState();

}

class BuddiesScreenState extends State<BuddiesScreen>{

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
          appBar: AppBar(title: Text('Buddies'),),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Container(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  color: Colors.purpleAccent,
                ),
              ),
            ),
          ),
        ),
      ),
    );

  }

}