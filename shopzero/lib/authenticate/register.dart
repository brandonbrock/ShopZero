import 'package:ShopZero/services/auth.dart';
import 'package:ShopZero/utilities/constants.dart';
import 'package:flutter/material.dart';


class RegisterPage extends StatefulWidget {

 final Function toggleView;
 RegisterPage({
  this.toggleView
 });

 @override
 _RegisterPageState createState() => _RegisterPageState();
}


class _RegisterPageState extends State < RegisterPage > {

 final AuthService _auth = AuthService();
 final _formKey = GlobalKey < FormState > ();
 String error = '';
 bool loading = false;

 // text field state
 String displayName = '';
 String fullName = '';
 String email = '';
 String password = '';

final displayNameController = TextEditingController();
final fullNameController = TextEditingController();
final emailController = TextEditingController();
final passwordController = TextEditingController();
final cpasswordController = TextEditingController();

 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    elevation: 0,
   ),
   body: Form(
    key: _formKey,
    child: LayoutBuilder(
     builder: (BuildContext context, BoxConstraints viewportContraints) {
      return Container(
       padding: const EdgeInsets.symmetric(horizontal: 30),
        color: Theme.of(context).primaryColor,
        width: double.infinity,
        child: SingleChildScrollView(
         child: ConstrainedBox(
          constraints: BoxConstraints(
           minHeight: viewportContraints.maxHeight,
          ),
          child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.stretch,
           children: < Widget > [
            //header
            Text(
             'Create an Account',
             textAlign: TextAlign.center,
             style: TextStyle(fontSize: 35, color: Colors.white),
            ),
            SizedBox(height: 20, ),
            TextFormField(
            controller: displayNameController,
             validator: (input) {
              if (input.isEmpty) {
               return 'Display Name is required';
              }
              if (input.length < 5 || input.length > 15) {
               return 'Display Name must be betweem 5 and 15 characters';
              }
              return null;
             },
             onChanged: (input) {
               if(mounted) {
              setState(() => displayName = input);
             }
             },
             style: textStyles,
             decoration: textInputDecoration.copyWith(hintText: 'Display Name'),
            ),
            SizedBox(height: 20, ),
            TextFormField(
              controller: fullNameController,
             validator: (input) {
              if (input.isEmpty) {
               return 'Full Name is required';
              }
              if (input.length < 5 || input.length > 20) {
               return 'Full Name must be betweem 5 and 20 characters';
              }
              return null;
             },
             onChanged: (input) {
               if(mounted) {
              setState(() => fullName = input);
               }
             },
             style: textStyles,
             decoration: textInputDecoration.copyWith(hintText: 'Full Name'),
            ),
            SizedBox(height: 20, ),
            TextFormField(
            controller: emailController,
             validator: (input) {
              if (input.isEmpty) {
               return 'Email can\'t be empty';
              }
              if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(input)) {
               return 'Please enter a valid email address';
              }
              return null;
             },
             onChanged: (input) {
               if(mounted) {
              setState(() => email = input);
               }
             },
             style: textStyles,
             decoration: textInputDecoration.copyWith(hintText: 'Email'),
            ),
            SizedBox(height: 20, ),
            TextFormField(
              controller: passwordController,
             validator: (input) {
              if (input.isEmpty) {
               return 'Password can\'t be empty';
              }
              if (input.length < 5 || input.length > 15) {
               return 'Password must be between 5 and 15 characters';
              }
              return null;
             },
             onChanged: (input) {
               if(mounted) {
              setState(() => password = input);
               }
             },
             obscureText: true,
             style: textStyles,
             decoration: textInputDecoration.copyWith(hintText: 'Password'),
            ),
            SizedBox(height: 20, ),
            TextFormField(
              controller: cpasswordController,
             validator: (input) {
              if (input.isEmpty) 
               return 'Password can\'t be empty';
              if(input != passwordController.text) 
                return 'Passwords don\'t match';
              return null;
              },
             obscureText: true,
             style: textStyles,
             decoration: textInputDecoration.copyWith(hintText: 'Confirm Password'),
            ),
            SizedBox(height: 20, ),
            FlatButton(child: Text(
              'Register',
              style: TextStyle(
               fontSize: 20,
              ),
             ),
             shape: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(5),
             ),
             padding: const EdgeInsets.all(15),
              textColor: Colors.white,
              onPressed: () async {
               if (_formKey.currentState.validate()) {
                setState(() => loading = true);
                dynamic result = await _auth.registerWithEmailAndPassword(displayName: displayName, fullName: fullName, email: email, password: password);
                if (result == null) {
                 setState(() {
                  loading = false;
                  _error();
                 });
                }
               }
              }
            ),
            SizedBox(height: 12.0),
            FlatButton(child: Text('Already have an Account',),
             textColor: Colors.white,
             onPressed: () => widget.toggleView(),
            ),   
           ],
          ),
         ),
        ),
      );
     },
    )
   ),
  );
 }

 void _error() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Register Authentication"),
          content: new Text("$email is an invaild email address or email is already in use by another account."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


}