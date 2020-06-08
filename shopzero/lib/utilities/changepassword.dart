import 'package:ShopZero/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
 _ChangePasswordState createState() => new _ChangePasswordState();
}

class _ChangePasswordState extends State < ChangePassword > {


 final AuthService _auth = AuthService();
 final _formKey = GlobalKey < FormState > ();
 String error = '';
 bool loading = false;

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
             //validator: () {},
             onChanged: (input) {
              setState(() => password = input);
             },
             style: TextStyle(fontSize: 18, color: Colors.black54),
             decoration: InputDecoration(
              errorStyle: TextStyle(color: Colors.white),
              filled: true,
              fillColor: Colors.white,
              hintText: 'Password',
              contentPadding: const EdgeInsets.all(15),
               focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                 color: Colors.white
                ),
                borderRadius: BorderRadius.circular(5),
               ),
               enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                 color: Colors.white
                ),
                borderRadius: BorderRadius.circular(5),
               ),
             )
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
                dynamic result = await _auth.changePassword(password);
                print("Password changed");
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
              'Go back to settings',
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