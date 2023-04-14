import 'package:flutter/material.dart';

class GeneralDialog {
  Function() onYes;
  String title;
  String body;
  IconData iconData;
  BuildContext context;

  GeneralDialog(
      {required this.onYes,
        required this.title,
        required this.body,
        required this.iconData,
        required this.context});

  show() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          iconData,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                            title,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      body,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 121,
                            height: 36,
                            decoration: BoxDecoration(
                              border:
                              Border.all(color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  ),
                                )
                            ),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 121,
                          height: 36,
                          child: ElevatedButton(
                            // color: AppColor.secondaryColor,
                            // shape: RoundedRectangleBorder(
                            // borderRadius: BorderRadius.circular(8)),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Theme.of(context).primaryColor)),
                              onPressed: onYes,
                              child:Text(
                                'LogOut',
                                style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                ),
                              )
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          );
        });
  }
}
