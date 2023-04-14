import 'package:data_app/common/loading.dart';
import 'package:data_app/data/shared_preference.dart';
import 'package:data_app/helpers/constants/app_color.dart';
import 'package:data_app/helpers/constants/list.dart';
import 'package:data_app/main.dart';
import 'package:data_app/presentation/view/bottom_nav/bottom_nav.dart';
import 'package:data_app/presentation/view/common/text/headerText.dart';
import 'package:data_app/presentation/viewmodel/user_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/random.dart';
import '../../../model/common_model/interest_list_data.dart';
import '../../../model/data_model/users_response_model.dart';
import '../common/buttons/general_button.dart';

class InterestScreen extends StatefulWidget{
  const InterestScreen({super.key});

  @override
  State<StatefulWidget> createState() => InterestScreenState();

}

class InterestScreenState extends State<InterestScreen>{

  var prefs = SharedPreference();
  late List<InterestListModel> interestList;
  List<String> interest = [];
  @override
  void initState() {
    interestList = initialInterestList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var viewModel = context.watch<UserViewModel>();

    List<Widget> interestItem(){
      List<Widget> chips = [];
      for(int i = 0; i < interestList.length; i++){
        Widget item = Padding(
            padding: const EdgeInsets.all(5),
            child: FilterChip(
                selectedColor: Theme.of(context).primaryColor,
                side: BorderSide(
                    color: (interestList[i].selected == true) ? Colors.white: Theme.of(context).primaryColor,
                    style: BorderStyle.solid
                ),
                backgroundColor: (interestList[i].selected == true) ? Theme.of(context).primaryColor: Colors.white,
                label: Text(
                  interestList[i].name,
                ),
                selected: interestList[i].selected,
                onSelected: (selected){
                  setState(() {
                    if(interestList[i].selected){
                      interestList[i].selected = false;
                      interest.removeWhere((element) => element == interestList[i].name);
                    }else{
                      interestList[i].selected = true;
                      interest.add(interestList[i].name);
                    }
                  });
                  print(interest.toString());
                }
            )
        );
        chips.add(item);
      }
      return chips;
    }


    return LoadingState(
      appState: viewModel.appState,
      child: Scaffold(
        appBar: AppBar(title: const Text('Interest Screen')),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderText(
                Colors.black,
                  'Pick an area that suits your interest :'
              ),
              SizedBox(height: 32,),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                  child: Wrap(
                    children: interestItem(),
                  )
              ),
              SizedBox(height: 20,),
              GeneralButton(
                text: 'Continue',
                onTap: (){
                  saveInterest(context, viewModel);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  saveInterest(BuildContext context, UserViewModel viewModel) async {
    var userId = UserModel.fromJson(await prefs.getRegistered()).id;
    if (interest.isNotEmpty) {
      viewModel.updateUser(
          id: userId, key: "interests", value: interest
      ).then((response) async {
        if (response.status == 'success') {
          await prefs.setLoggedIn(response.data);
          viewModel.setUser(response.data);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const BottomNav()),
                  (route) => false);
          RandomFunction.toast(response.message, isError: false);
        }else{
          RandomFunction.toast(response.message, isError: true);
        }
      },
      );
    } else {
      RandomFunction.toast("You have to select at least one area of interest", isError: true);
    }
  }


}