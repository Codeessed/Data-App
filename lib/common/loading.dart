import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../helpers/app_state.dart';

class LoadingState extends StatelessWidget {
  final Widget child;
  final AppState appState;
  const LoadingState({required this.appState, required this.child, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        appState == AppState.idle
            ? SizedBox()
            : const Opacity(
              opacity: 0.25,
              child: ModalBarrier(
                dismissible: false,
                color: Colors.black,
              ),
            ),
        appState == AppState.idle
            ? SizedBox()
            : Center(
          child: CircularProgressIndicator(
            color: Colors.purpleAccent,
          ),
        )
      ],
    );
  }
}
