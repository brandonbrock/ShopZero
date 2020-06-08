import 'package:ShopZero/services/auth.dart';
import 'package:ShopZero/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:ShopZero/utilities/validation.dart';

class Login extends StatefulWidget {


 final Function toggleView;
 Login({
  this.toggleView
 });

 @override
 _LoginState createState() => new _LoginState();
}

class _LoginState extends State < Login > {

 final AuthService _auth = AuthService();
 final _formKey = GlobalKey < FormState > ();
 String error = '';
 bool loading = false;

 // text field state
 String email = '';
 String password = '';

 @override
 Widget build(BuildContext context) {
  return Scaffold(
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
            Image.asset('assets/images/logo.PNG', height: 200, ),
            SizedBox(height: 25.0),
            TextFormField(
              key: Key('email'),
              style: textStyles,
              decoration: textInputDecoration.copyWith(hintText: 'Email'),
             validator: EmailFieldValidator.validate,
             onChanged: (input) {
              setState(() => email = input);
             },
             
            ),
            SizedBox(height: 20, ),
            TextFormField(
              style: textStyles,
             decoration: textInputDecoration.copyWith(hintText: 'Password'),
             validator: PasswordFieldValidator.validate,
             onChanged: (input) {
              setState(() => password = input);
             },
             obscureText: true,
             
            ),
            SizedBox(height: 20, ),
            FlatButton(
              child: Text('Login',style: TextStyle(fontSize: 20,),),
             shape: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(5),
             ),
             padding: const EdgeInsets.all(15),
              textColor: Colors.white,
              onPressed: () async {
               if (_formKey.currentState.validate()) {
                setState(() => loading = true);
                dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                if (result == null) {
                 setState(() {
                  loading = false;
                  _error();
                 });
                }
               }
              }
            ),
            FlatButton(
             child: Text('Forgot Password'),
             textColor: Colors.white,
             onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPassword()));
             }
            ),
            FlatButton(child: Text(
              'Create a Account',
             ),
             textColor: Colors.white,
             onPressed: () => widget.toggleView(),
            ),   
            Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
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
          title: new Text("Login Authentication"),
          content: new Text("$email or password is incorrect or does not exist"),
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

class ResetPassword extends StatefulWidget {
 _ResetPasswordState createState() => new _ResetPasswordState();
}

class _ResetPasswordState extends State < ResetPassword > {


 final AuthService _auth = AuthService();
 final _formKey = GlobalKey < FormState > ();
 String error = '';
 bool loading = false;

 // text field state
 String email = '';
 String password = '';

 @override
 Widget build(BuildContext context) {
  return Scaffold(
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
             'Reset Pasword',
             textAlign: TextAlign.center,
             style: TextStyle(fontSize: 35, color: Colors.white),
            ),
            SizedBox(height: 25.0),
            TextFormField(
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
              setState(() => email = input);
             },
             style: textStyles,
             decoration: textInputDecoration.copyWith(hintText: 'Email'),
            ),
            SizedBox(height: 20.0),
            FlatButton(child: Text(
              'Reset',
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
                dynamic result = await _auth.sendPasswordResetEmail(email.trim());
                print("Password reset email sent");
                Navigator.pop(context);
                if (result == null) {
                 setState(() {
                  loading = false;
                  AlertDialog(
                   title: Text('Error'),
                   content: SingleChildScrollView(
                    child: ListBody(
                     children: < Widget > [
                      Text('Please enter details correctly'),
                     ],
                    ),
                   ),
                   actions: < Widget > [
                    FlatButton(
                     child: Text('Ok'),
                     onPressed: () {
                      Navigator.of(context).pop();
                     },
                    ),
                   ],
                  );
                 });
                }
               }
              }
            ),
            SizedBox(height: 5),
            FlatButton(child: Text(
              'Go back to Login',
             ),
             padding: const EdgeInsets.all(15),
              textColor: Colors.white,
              onPressed: () {
               Navigator.pop(context);
              }
            ),
           ]
          )
         )
        )
      );
     }
    )
   )
  );
 }
}