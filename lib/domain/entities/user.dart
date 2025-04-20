

class User{
  final String id;
  final String name;
  final String email;
  final String photoUrl;
  final DateTime lastActive;
  final bool isOnline;

  User({
    required this.id,
     required this.name,
      required this.email,
       required this.photoUrl, 
       required this.lastActive, 
       required this.isOnline
       });
  
}