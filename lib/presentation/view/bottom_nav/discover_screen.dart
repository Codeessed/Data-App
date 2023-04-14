import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/loading.dart';
import '../../../common/validator.dart';
import '../../../data/shared_preference.dart';
import '../../../helpers/constants/app_color.dart';
import '../../../helpers/random.dart';
import '../../../model/data_model/users_response_model.dart';
import '../../viewmodel/user_viewmodel.dart';
import '../common/buttons/general_button.dart';
import '../common/widget/text_field.dart';

class DiscoverScreen extends StatefulWidget{
  const DiscoverScreen({super.key});

  @override
  State<StatefulWidget> createState() => DiscoverScreenState();

}

class DiscoverScreenState extends State<DiscoverScreen>{

  var prefs = SharedPreference();

  @override
  void initState() {
    super.initState();
    getUsers();
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
          appBar: AppBar(title: Text('Discover'),),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView.builder(
                  itemCount: viewModel.allUsers.length,
                  itemBuilder: (context, index){
                    return ListTile(
                      leading: Icon(Icons.person),
                      title: Text(viewModel.allUsers[index].username) ,
                      subtitle: Text(viewModel.allUsers[index].email),
                    );
                  }
              )
            ),
          ),
        ),
      ),
    );

  }

  getUsers() async {
    context.read<UserViewModel>().getUsers(UserModel.fromJson(await prefs.getLoggedIn()).email);
  }

}