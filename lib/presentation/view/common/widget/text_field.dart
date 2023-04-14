
import 'package:flutter/material.dart';


class Field extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final Widget? prefixIcon;
  final double height,width,borderRadius;
  final TextInputType textInputType;
  final Function(String)? validate;
  final Color fillColor;
  final bool isPassword,enable;
  final Function? onTap;
  const Field({
    required this.controller,
    this.height=54,
    this.onTap,
    this.enable=true,
    required this.validate,
    this.fillColor=const Color(0xffF2F2F2),
    this.width=double.maxFinite,
    this.isPassword=false,
    this.borderRadius=10,
    this.hint="",
    this.textInputType=TextInputType.text,
    this.prefixIcon,
    Key? key}) : super(key: key);

  @override
  State<Field> createState() => _FieldState();
}

class _FieldState extends State<Field> {
  bool secure = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: (){
        widget.onTap;
      },
      obscureText: secure,
      enabled: widget.enable,
      controller:widget.controller ,
      keyboardType: widget.textInputType,
      validator: (e){
        return  widget.validate==null?null:widget.validate!(e!);
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 13),
        hintText: widget.hint,
        prefixIcon:widget.prefixIcon==null?null: Transform.scale(
            scale: 0.5,
            child: widget.prefixIcon),
        suffixIcon: widget.isPassword?InkWell(
            onTap: (){
              setSecure();
            },
            child: icon()):null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.transparent,width: 0),
        ),
        enabledBorder:OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide:const BorderSide(color: Colors.transparent,width:0),
        ) ,
        disabledBorder:OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide:const BorderSide(color: Colors.transparent,width:0),
        ),
        focusedBorder:OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide:const BorderSide(color: Colors.transparent,width: 0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide:  const BorderSide(color: Colors.red,width: 0.2),
        ),
        fillColor:widget.fillColor ,
        filled: true,

      ),

    );
  }

  setSecure(){
    setState((){
      secure=!secure;
    });
  }

  Widget icon() {
    if(secure){
      return const Icon(Icons.visibility_outlined);
    }else{
      return const Icon(Icons.visibility_off_outlined);
    }

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.isPassword){
      setState(() {
        secure=true;
      });
    }
  }
}
