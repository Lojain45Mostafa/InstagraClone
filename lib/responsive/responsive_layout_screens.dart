import 'package:flutter/material.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/utils/global_variables.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  
  const ResponsiveLayout({Key? key , required this.mobileScreenLayout, required this.webScreenLayout}) :super(key:key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {

  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async{

    UserProvider _userProvider = Provider.of(context , listen: false);
    //context will be coming from the state
    //it will listen to the values given by _userProvider we just need to call refreshUser once on it, so we will set listen to false 
  
  await _userProvider.refreshUser();
  //now we are storing the values in _userProvider
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context , constraints){
        if(constraints.maxWidth > webScreenSize){
          return widget.webScreenLayout;
        }
        return widget.mobileScreenLayout;
      },
      );
  }
}