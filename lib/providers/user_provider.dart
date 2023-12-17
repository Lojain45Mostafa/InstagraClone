import 'package:flutter/foundation.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/resources/auth_methods.dart';

class UserProvider with ChangeNotifier{
User? _user;

//initializing out authmethods class
final AuthMethods _authMethods = AuthMethods();

//creating a global variable user which is nullable and private to prevent bugs
User get getUser => _user!;
//so if we wanna access this user field or get its data we will be creating get method and returning user and to return it add ! that it's not going to be null
 Future<void> refreshUser() async{

  //it will return user model from it
  User  user = await _authMethods.getUserDetails();
  _user = user;

  //it will notify all listeners to this user providers that the data of our global variable (_user) has changed so u need to update ur value
  notifyListeners();
 }
 //creating function and refresh the user everytime this function is there so that we can update the values of our user
}