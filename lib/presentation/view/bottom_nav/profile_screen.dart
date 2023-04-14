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

class ProfileScreen extends StatefulWidget{
  const ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() => ProfileScreenState();

}

class ProfileScreenState extends State<ProfileScreen>{

  @override
  Widget build(BuildContext context) {

    final viewModel = context.watch<UserViewModel>();

    return Scaffold(
      appBar: AppBar(title: Text('Profile'),),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.maxFinite,
              height: 250,
              color: Theme.of(context).primaryColor.withOpacity(0.2),
              child: Center(
                child: Icon(Icons.person, size: 220, color: Colors.black.withOpacity(0.2),),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: Icon(Icons.person, color: Colors.black,),
                      title: Text(viewModel.user!.username),
                    ),
                    ListTile(
                      leading: Icon(Icons.email, color: Colors.black,),
                      title: Text(viewModel.user!.email),
                    ),
                    ListTile(
                      leading: Icon(Icons.phone, color: Colors.black,),
                      title: Text(viewModel.user!.phone_number),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Interests:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text(
                            listToString(viewModel.user!.interests!),
                            style: TextStyle(
                              color: Theme.of(context).primaryColor.withOpacity(0.7)
                            ),
                          ),

                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ]
        ),
      ),
    );

  }

  listToString(List<dynamic> list){
    return list.join(', ');
  }

}