import 'dart:collection';
import 'dart:math';

import 'package:data_app/data/shared_preference.dart';
import 'package:data_app/model/data_model/auth_model/login/login_model.dart';
import 'package:data_app/model/data_model/users_response_model.dart';
import 'package:data_app/presentation/view/splash_screen.dart';
import 'package:data_app/presentation/viewmodel/user_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserViewModel()),
      ],
      child: const MyApp()
    )
      // const MyApp()
  );
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  // final CollectionReference _users = FirebaseFirestore.instance.collection('users_data');
  // List<UserModel>? _usersList = [];

  // getUsers() async {
  //   await _users.get().then((QuerySnapshot querySnapshot){
  //     _usersList?.addAll(querySnapshot.docs.map((e) => UserModel.fromDocument(e)));
  //   });
  //   print(_usersList);
  // }
  late SharedPreference prefs;


  @override
  void initState() {
    prefs = SharedPreference();
    getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserViewModel userViewModel = context.watch<UserViewModel>();
    // userViewModel.getUsers();

    // () async {
    //   _usersList = await userViewModel.allUsers;
    // };
    // userViewModel.getUsers();


    // getResources() {
    //   resources = context.read<ResourceViewModel>().getAllResources();
    // }

    // getUsers();

    // _usersList = userViewModel.getUsers() as List<UserModel>;

    //   return Scaffold(
  //     appBar: AppBar(title: Text('appbar'),),
  //     body: Container(
  //       color: Colors.amber,
  //     ),
  //   );

    // return Scaffold(
    //   body: StreamBuilder(
    //     stream: _users.snapshots(),
    //     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    //       if(snapshot.hasData){
    return Scaffold(
      appBar: AppBar(title: Text('appbar')),
      body: Column(
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: ListView.builder(
                itemCount: userViewModel.allUsers.length,
                itemBuilder: (context, index){
                  // print(_usersList);
                  // print('object');
                  // final DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
                  // final List<QueryDocumentSnapshot<Object?>> documentSnapsho = snapshot.data!.docs;

                  return ListTile(
                    title: Text(userViewModel.allUsers[index].phone_number) ,
                    subtitle: Text(userViewModel.allUsers[index].email),
                    trailing: ElevatedButton.icon(
                      icon: Icon(Icons.update),
                      onPressed: () async {
                        // doc(documentSnapshot.id).delete();
                        // .update({"email": 'new kasdfa'});
                      },
                      label: const Text('Update'),
                    ),
                  );
                }
            ),
          ),

          IconButton(
              onPressed: () async {
                // await prefs.removeString();
                // var check = await prefs.checkValue();
                // var save = await prefs.checkValue();
                var read = await prefs.getString();
                // var update = await userViewModel.updateUser('4qE1vkNv6ar5FxkbapTq', 'password', 'pasword_changed');
                // var existing = await userViewModel.addUser(UserModel(email: "ema", username: 'usrn', phone_number: 'po', password: 'fpasswrd', interests: ['as', 'f2'], id: ''));
                var login = await userViewModel.loginUser(LoginModel(email: "email", password: 'fpasswrd'));
                // if(login.status == 'success'){
                //   await prefs.setString(login.data);
                //   ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(SnackBar(content: Text(login.data)));
                // }else{
                //   ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(SnackBar(content: Text(login.message)));
                // }
                // print(update);
                // ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(SnackBar(content: Text(login.status == 'success' ? prefs.setString(login.data): login.message)));
                // ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(SnackBar(content: Text(existing.status == 'success' ? existing.message: existing.message)));
                ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(SnackBar(content: Text(UserModel.fromJson(read).interests!.isNotEmpty.toString())));
                // ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(SnackBar(content: Text()));
              },
              icon: const Icon(Icons.add)
          )

        ],
      ),
    );


    // }
          // return const Center(
          //   child: CircularProgressIndicator(),
          // );
        // },
      // ),
    // );

  }

  // Future<void> getUsers() async {
  //   _usersList = await context.read<UserViewModel>().getUsers();
  //   // print(_usersList);
  // }

  getUsers() {
    context.read<UserViewModel>().getUsers();
  }

}
