import 'package:ShopZero/models/user.dart';
import 'package:ShopZero/services/auth.dart';
import 'package:ShopZero/services/database.dart';
import 'package:ShopZero/utilities/constants.dart';
import 'package:ShopZero/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
 _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State < Settings > {
 @override
 Widget build(BuildContext context) {
  return Scaffold(
    //appbar
   appBar: AppBar(
    title: Text('Settings'),
    centerTitle: true,
   ),
   //main context
   body: SingleChildScrollView(
    padding: EdgeInsets.all(16.0),
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: < Widget > [
      Text('Account', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, ), ),
      SizedBox(height: 5.0),
      ListTile(
       contentPadding: const EdgeInsets.all(0),
        leading: Icon(Icons.account_box, color: Colors.teal, ),
        title: Text('Edit Profile'),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () {
         Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile()));
        },
      ),
      ListTile(
       contentPadding: const EdgeInsets.all(0),
        leading: Icon(Icons.lock, color: Colors.teal, ),
        title: Text('Change Password'),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () {
         Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePassword()));
        },
      ),
      SizedBox(height: 5.0),
      Text('Notifications', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, ), ),
      SizedBox(height: 5.0),
      SwitchListTile(
       activeColor: Colors.teal,
       contentPadding: const EdgeInsets.all(0),
        value: true,
        title: Text('Receive Notifications'),
        onChanged: (value) {}
      ),
      SwitchListTile(
       activeColor: Colors.teal,
       contentPadding: const EdgeInsets.all(0),
        value: true,
        title: Text('Receive Newsletter'),
        onChanged: (value) async {}
      ),
      SwitchListTile(
       activeColor: Colors.teal,
       contentPadding: const EdgeInsets.all(0),
        value: false,
        title: Text('Receive App Updates'),
        onChanged: (value) {},
      ),
      SwitchListTile(
       activeColor: Colors.teal,
       contentPadding: const EdgeInsets.all(0),
        value: true,
        title: Text('Receive Offer Notifications'),
        onChanged: (value) {},
      ),
      SizedBox(height: 5.0),
      Text('More', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, ), ),
      SizedBox(height: 5.0),
      ListTile(
       contentPadding: const EdgeInsets.all(0),
        leading: Icon(Icons.help, color: Colors.teal, ),
        title: Text('Privacy'),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () {
         Navigator.push(context, MaterialPageRoute(builder: (context) => Privacy()));
        },
      ),
      ListTile(
       contentPadding: const EdgeInsets.all(0),
        leading: Icon(Icons.info, color: Colors.teal, ),
        title: Text('About'),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () {
         Navigator.push(context, MaterialPageRoute(builder: (context) => About()));
        },
      ),
     ],
    ),
   ),
  );
 }


}

//class to change the users password
class ChangePassword extends StatefulWidget {
 _ChangePasswordState createState() => new _ChangePasswordState();
}

class _ChangePasswordState extends State < ChangePassword > {


 final AuthService _auth = AuthService();
 final _formKey = GlobalKey < FormState > ();
 String error = '';
 bool loading = false;

//form variables
 String password = '';
 final passwordController = TextEditingController();
 final cpasswordController = TextEditingController();

 @override
 Widget build(BuildContext context) {
  return Scaffold(
    //app bar
   appBar: AppBar(
    centerTitle: true,
    automaticallyImplyLeading: false,
    title: Text('Change Password'),
    //back button
    leading: new IconButton(
     icon: new Icon(Icons.arrow_back),
     onPressed: () {
      Navigator.pop(context);
     }
    ),
   ),
   //main context
   body: Form(
    key: _formKey,
    child: LayoutBuilder(
     builder: (BuildContext context, BoxConstraints viewportContraints) {
      return Container(
       padding: const EdgeInsets.symmetric(horizontal: 30),
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
            SizedBox(height: 25),
            TextFormField(
             obscureText: true,
             controller: passwordController,
             validator: (input) => input.isEmpty ? 'Password can\'t be empty' : null,
             onChanged: (input) {
              setState(() => password = input);
             },
             style: TextStyle(fontSize: 18, color: Colors.black54),
             decoration: InputDecoration(
              errorStyle: TextStyle(color: Colors.red),
              filled: true,
              fillColor: Colors.white,
              hintText: 'Password',
              contentPadding: const EdgeInsets.all(15),
               focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                 color: Colors.teal
                ),
                borderRadius: BorderRadius.circular(5),
               ),
               enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                 color: Colors.teal
                ),
                borderRadius: BorderRadius.circular(5),
               ),
             )
            ),
            SizedBox(height: 20, ),
            TextFormField(
             obscureText: true,
             controller: cpasswordController,
             validator: (input) {
              if (input.isEmpty)
               return 'Password can\'t be empty';
              if (input != passwordController.text)
               return 'Passwords don\'t match';
              return null;
             },
             style: TextStyle(fontSize: 18, color: Colors.black54),
             decoration: InputDecoration(
              errorStyle: TextStyle(color: Colors.red),
              filled: true,
              fillColor: Colors.white,
              hintText: 'Confirm Password',
              contentPadding: const EdgeInsets.all(15),
               focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                 color: Colors.teal
                ),
                borderRadius: BorderRadius.circular(5),
               ),
               enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                 color: Colors.teal
                ),
                borderRadius: BorderRadius.circular(5),
               ),
             )
            ),
            SizedBox(height: 20, ),
            FlatButton(child: Text(
              'Submit',
              style: TextStyle(
               fontSize: 20,
              ),
             ),
             shape: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal, width: 2),
              borderRadius: BorderRadius.circular(5),
             ),
             padding: const EdgeInsets.all(15),
              textColor: Colors.teal,
              onPressed: () async {
                //checks validation then changepassword function
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
            )
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
}

class EditProfile extends StatefulWidget {
 @override
 _EditProfileState createState() => _EditProfileState();

}

class _EditProfileState extends State < EditProfile > {

 //form elements
 FirebaseUser user;
 final _formKey = GlobalKey < FormState > ();
 String error = '';
 bool loading = false;

 // text field state
 String _currentdisplayName = '';
 String _currentfullName = '';
 String _currentemail = '';

 @override
 void initState() {
  super.initState();
  initUser();
 }

 initUser() async {
  user = await FirebaseAuth.instance.currentUser();
  setState(() {});
 }


 @override
 Widget build(BuildContext context) {
  final user = Provider.of < User > (context);
  return StreamBuilder < UserData > (
   stream: DatabaseService(uid: user.uid).userData,
   builder: (context, snapshot) {
    if (snapshot.hasData) {
     UserData userData = snapshot.data;
     return Scaffold(
      appBar: AppBar(
       centerTitle: true,
       automaticallyImplyLeading: false,
       title: Text('Edit Profile'),
       leading: new IconButton(
        icon: new Icon(Icons.arrow_back),
        onPressed: () {
         Navigator.pop(context);
        }
       ),
      ),
      body: Form(
       key: _formKey,
       child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportContraints) {
         return Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
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
               SizedBox(height: 25),
               TextFormField(
                validator: (input) => input.isEmpty ? 'Please enter a display name' : null,
                onChanged: (input) {
                 setState(() => _currentdisplayName = input);
                },
                style: TextStyle(fontSize: 18, color: Colors.black54),
                decoration: InputDecoration(
                labelText: 'Display Name',
                 errorStyle: TextStyle(color: Colors.red),
                 filled: true,
                 fillColor: Colors.white,
                 hintText: userData.displayName,
                 contentPadding: const EdgeInsets.all(15),
                  focusedBorder: OutlineInputBorder(
                   borderSide: BorderSide(
                    color: Colors.teal
                   ),
                   borderRadius: BorderRadius.circular(5),
                  ),
                  enabledBorder: UnderlineInputBorder(
                   borderSide: BorderSide(
                    color: Colors.teal
                   ),
                   borderRadius: BorderRadius.circular(5),
                  ),
                )
               ),
               SizedBox(height: 20, ),
               TextFormField(
                validator: (input) => input.isEmpty ? 'Please enter a name' : null,
                onChanged: (input) {
                 setState(() => _currentfullName = input);
                },
                style: TextStyle(fontSize: 18, color: Colors.black54),
                decoration: InputDecoration(
                  labelText: 'Full Name',
                 errorStyle: TextStyle(color: Colors.red),
                 filled: true,
                 fillColor: Colors.white,
                 hintText: userData.fullName ?? 'Full Name',
                 contentPadding : const EdgeInsets.all(15),
                  focusedBorder: OutlineInputBorder(
                   borderSide: BorderSide(
                    color: Colors.teal
                   ),
                   borderRadius: BorderRadius.circular(5),
                  ),
                  enabledBorder: UnderlineInputBorder(
                   borderSide: BorderSide(
                    color: Colors.teal
                   ),
                   borderRadius: BorderRadius.circular(5),
                  ),
                )
               ),
               SizedBox(height: 20, ),
               TextFormField(
                validator: (input) => input.isEmpty ? 'Please enter a email' : null,
                onChanged: (input) {
                 setState(() => _currentemail = input);
                },
                style: TextStyle(fontSize: 18, color: Colors.black54),
                decoration: InputDecoration(
                  labelText: 'Email',
                 errorStyle: TextStyle(color: Colors.red),
                 filled: true,
                 fillColor: Colors.white,
                 hintText: userData.email,
                 contentPadding: const EdgeInsets.all(15),
                  focusedBorder: OutlineInputBorder(
                   borderSide: BorderSide(
                    color: Colors.teal
                   ),
                   borderRadius: BorderRadius.circular(5),
                  ),
                  enabledBorder: UnderlineInputBorder(
                   borderSide: BorderSide(
                    color: Colors.teal
                   ),
                   borderRadius: BorderRadius.circular(5),
                  ),
                )
               ),
               SizedBox(height: 25),
               FlatButton(child: Text(
                 'Update',
                 style: TextStyle(
                  fontSize: 20,
                 ),
                ),
                shape: OutlineInputBorder(
                 borderSide: BorderSide(color: Colors.teal, width: 2),
                 borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.all(15),
                 textColor: Colors.teal,
                 onPressed: () async {
                  if (_formKey.currentState.validate()) {
                   await DatabaseService(uid: user.uid).updateEditProfile(
                    _currentdisplayName ?? userData.displayName,
                    _currentemail ?? userData.email,
                    _currentfullName ?? userData.fullName,
                   );
                   Navigator.pop(context);
                  }
                 }
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
    } else {
     return Center(
      child: Loading(),
     );
    }

   }
  );
 }
}

class About extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    centerTitle: true,
    automaticallyImplyLeading: false,
    title: Text('About Us'),
    leading: new IconButton(
     icon: new Icon(Icons.arrow_back),
     onPressed: () {
      Navigator.pop(context);
     }
    ),
   ),
   body: SingleChildScrollView(
    child: Container(
     padding: EdgeInsets.all(16.0),
     child: Column(
      children: < Widget > [
       SizedBox(height: 10),
       Text('SHOP ZERO is run by me, Sarah Maloy. I aim to empower people to live more sustainably by providing well researched information and products for my customers. Knowing where to start when reducing your environmental impact can be hard, so if you’re looking to take a practical approach, then Shop Zero is a great place to start. As you make changes that are more in harmony with our environment, I can help you to stay informed and make choices that suit your lifestyle. I want to provide people with alternatives and sustainable swaps to everyday items that don’t cost the Earth.', style: textStyles),
       SizedBox(height: 10),
       Text('Us humans have become very detached from the impact we have on our environment. We have all been shocked by seeing how the waste that we produce, whether this be from the rubbish in our homes, to the carbon emissions from broader human activity, is affecting our world. We can see increasingly that the capacity of the Earth to manage our over-consumption has been exceeded. Unlike us, nature does not operate is a linear way; taking, using and discarding without regard. We need to follow her circular example and learn to live more consciously.', style: textStyles),
       SizedBox(height: 10),
       Text('I do have qualifications in the environmental field (a Degree in Biology, followed by an MSc in Environmental Monitoring and Assessment, then my PhD in the microbial ecology of polluted waters). But I have always had the environment at the heart of what I do both in work and in my life not only because of that, but because it makes sense. I worked in the sustainability field on both company-wide and community-based projects until such roles fell out of favour, so then I qualified as a Primary Teacher. My catch-phrase is, ‘We are nature!’ By this I mean that we are not separate from nature but part of it and thus we have responsibility for the stewardship of our world.', style: textStyles),
       SizedBox(height: 10),
       Text('I have first-hand experience of reducing my family’s waste so I can help you to do the same. I first became particularly intent on making significant changes over 3 years ago. I was lent Bea Johnson’s iconic book Zero Waste Home. Even though I had thought we were trying to live more in harmony with nature, I became acutely aware of the amount of waste we were creating as a family and set out to reduce it. And as my low-waste journey began, the plastic crisis started to come into acute focus, which only increased my desire to help others to live more sustainably too. I have learnt that being more environmentally conscious is not always easy. But what I have learnt, I have put into my business, to make it easier for you.', style: textStyles),
       SizedBox(height: 10),
       Text('I started my first my business, Join the Dots – sustainability made simple, in 2017. As ever, my focus is on empowering individuals, schools, business and community to live more sustainably. Out of this business, two main projects grew – Nottingham Fixers community Repair Cafe, and Shop Zero. Many of us have a strong desire for change, but what is on offer to us is certainly not perfect and making choices is not always easy. So my aim is to use my knowledge and experience to be transparent in what I do and offer. I hope this can empower you to make the choices that are best for you and those around you.', style: textStyles),
       SizedBox(height: 10),
       Text('So Shop Zero is about the community of people it serves, all of us who are coming together with a common goal.', style: textStyles),
       SizedBox(height: 10),
       Text('Come on in and say hello!', style: textStyles),
       SizedBox(height: 10),
      ],
     ),
    ),
   ),
  );
 }
}

class Privacy extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    centerTitle: true,
    automaticallyImplyLeading: false,
    title: Text('Privacy Policy'),
    leading: new IconButton(
     icon: new Icon(Icons.arrow_back),
     onPressed: () {
      Navigator.pop(context);
     }
    ),
   ),
   body: SingleChildScrollView(
    child: Container(
     padding: EdgeInsets.all(16.0),
     child: Column(
      children: < Widget > [
       SizedBox(height: 10),
       Text('Shop Zero is located at: ShopZero, 16 St James’s Street', style: textStyles),
       SizedBox(height: 10),
       Text('It is Shop Zero’s policy to respect your privacy regarding any information we may collect while operating our website. This Privacy Policy applies to https://shopzero.co.uk. We respect your privacy and are committed to protecting personally identifiable information you may provide us through the Website. We have adopted this privacy policy to explain what information may be collected on our Website and Mobile Application, how we use this information, and under what circumstances we may disclose the information to third parties. This Privacy Policy applies only to information we collect through the Website and does not apply to our collection of information from other sources.', style: textStyles),
       SizedBox(height: 10),
       Text('This Privacy Policy, together with the Terms and conditions posted on our Website, set forth the general rules and policies governing your use of our Website. Depending on your activities when visiting our Website, you may be required to agree to additional terms and conditions.', style: textStyles),
       SizedBox(height: 10),
       Text('Website Visitors', style: headings),
       SizedBox(height: 10),
       Text('Like most website operators, Shop Zero collects non-personally-identifying information of the sort that web browsers and servers typically make available, such as the browser type, language preference, referring site, and the date and time of each visitor request. Shop Zero’s purpose in collecting non-personally identifying information is to better understand how Shop Zero’s visitors use its website. From time to time, Shop Zero may release non-personally-identifying information in the aggregate, e.g., by publishing a report on trends in the usage of its website.', style: textStyles),
       SizedBox(height: 10),
       Text('Shop Zero also collects potentially personally-identifying information like Internet Protocol (IP) addresses for logged in users and for users leaving comments on https://shopzero.co.uk/ blog posts. Shop Zero only discloses logged in user and commenter IP addresses under the same circumstances that it uses and discloses personally-identifying information as described below.', style: textStyles),
       SizedBox(height: 10),
       Text('Gathering of Personally-Identifying Information', style: headings),
       SizedBox(height: 10),
       Text('Certain visitors to Shop Zero’s websites choose to interact with Shop Zero in ways that require Shop Zero to gather personally-identifying information. The amount and type of information that Shop Zero gathers depends on the nature of the interaction. For example, we ask visitors who sign up for a blog at https://shopzero.co.uk/ to provide a username and email address. If you pruchase goods from us then we also collect your address in order to pass to our delivery companies in order to fulfill the contract.', style: textStyles),
       SizedBox(height: 10),
       Text('Security', style: headings),
       SizedBox(height: 10),
       Text('The security of your Personal Information is important to us, but remember that no method of transmission over the Internet, or method of electronic storage is 100% secure. While we strive to use commercially acceptable means to protect your Personal Information, we cannot guarantee its absolute security.', style: textStyles),
       SizedBox(height: 10),
       Text('Advertisements', style: headings),
       SizedBox(height: 10),
       Text('Ads appearing on our website may be delivered to users by advertising partners, who may set cookies. These cookies allow the ad server to recognize your computer each time they send you an online advertisement to compile information about you or others who use your computer. This information allows ad networks to, among other things, deliver targeted advertisements that they believe will be of most interest to you. This Privacy Policy covers the use of cookies by Shop Zero and does not cover the use of cookies by any advertisers.', style: textStyles),
       SizedBox(height: 10),
       Text('Links to External Sites', style: headings),
       SizedBox(height: 10),
       Text('Our Service may contain links to external sites that are not operated by us. If you click on a third party link, you will be directed to that third party’s site. We strongly advise you to review the Privacy Policy and terms and conditions of every site you visit. We have no control over, and assume no responsibility for the content, privacy policies or practices of any third party sites, products or services.', style: textStyles),
       SizedBox(height: 10),
       Text('Google Adwords', style: headings),
       SizedBox(height: 10),
       Text('Https://shopzero.co.uk/ uses the remarketing services to advertise on third party websites (including Google) to previous visitors to our site. It could mean that we advertise to previous visitors who haven’t completed a task on our site, for example using the contact form to make an enquiry. This could be in the form of an advertisement on the Google search results page, or a site in the Google Display Network. Third-party vendors, including Google, use cookies to serve ads based on someone’s past visits. Of course, any data collected will be used in accordance with our own privacy policy and Google’s privacy policy.', style: textStyles),
       SizedBox(height: 10),
       Text('You can set preferences for how Google advertises to you using the Google Ad Preferences page, and if you want to you can opt out of interest-based advertising entirely by cookie settings or permanently using a browser plugin.', style: textStyles),
       SizedBox(height: 10),
       Text('Aggregated Statistics', style: headings),
       SizedBox(height: 10),
       Text('Shop Zero may collect statistics about the behavior of visitors to its website. Shop Zero may display this information publicly or provide it to others. However, Shop Zero does not disclose your personally-identifying information.', style: textStyles),
       SizedBox(height: 10),
       Text('Cookies', style: headings),
       SizedBox(height: 10),
       Text('To enrich and perfect your online experience, Shop Zero uses “Cookies”, similar technologies and services provided by others to display personalized content, appropriate advertising and store your preferences on your computer.', style: textStyles),
       SizedBox(height: 10),
       Text('A cookie is a string of information that a website stores on a visitor’s computer, and that the visitor’s browser provides to the website each time the visitor returns. Shop Zero uses cookies to help Shop Zero identify and track visitors, their usage of https://shopzero.co.uk/, and their website access preferences. Shop Zero visitors who do not wish to have cookies placed on their computers should set their browsers to refuse cookies before using Shop Zero’s websites, with the drawback that certain features of Shop Zero’s websites may not function properly without the aid of cookies.', style: textStyles),
       SizedBox(height: 10),
       Text('By continuing to navigate our website without changing your cookie settings, you hereby acknowledge and agree to Shop Zero’s use of cookies.', style: textStyles),
       SizedBox(height: 10),
       Text('E-commerce ', style: headings),
       SizedBox(height: 10),
       Text('Those who engage in transactions with Shop Zero – by purchasing Shop Zero’s services or products, are asked to provide additional information, including as necessary the personal and financial information required to process those transactions. In each case, Shop Zero collects such information only insofar as is necessary or appropriate to fulfill the purpose of the visitor’s interaction with Shop Zero. Shop Zero does not disclose personally-identifying information other than as described below. And visitors can always refuse to supply personally-identifying information, with the caveat that it may prevent them from engaging in certain website-related activities.', style: textStyles),
       SizedBox(height: 10),
       Text('Privacy Policy Changes', style: headings),
       SizedBox(height: 10),
       Text('Although most changes are likely to be minor, Shop Zero may change its Privacy Policy from time to time, and in Shop Zero’s sole discretion. Shop Zero encourages visitors to frequently check this page for any changes to its Privacy Policy. Your continued use of this site after any change in this Privacy Policy will constitute your acceptance of such change.', style: textStyles),
       SizedBox(height: 10),
       Text('Contact Information', style: headings),
       SizedBox(height: 10),
       Text('If you have any questions about this Privacy Policy, please contact us.', style: textStyles),
      ],
     ),
    ),
   ),
  );
 }
}