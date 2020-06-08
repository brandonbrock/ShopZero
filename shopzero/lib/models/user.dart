class User {

  final String uid;
  
  User({ this.uid });

}

class UserData {

  final String uid;
  final String displayName;
  final String fullName;
  final String email;
  final String userRole;
  final int scans;
  final int scansLeft;
  final double scansPercent;

  UserData({this.uid, this.displayName, this.email, 
  this.fullName, this.userRole, this.scans, this.scansLeft, this.scansPercent});
}