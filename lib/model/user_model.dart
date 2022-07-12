class UserModel{
  String? email;
  String? uid;

  UserModel({this.uid, this.email});

  //get data from server
factory UserModel.fromMap(map){
  return UserModel(
    uid: map('uid'),
    email: map('email'),
  );
}


//send to server
Map<String, dynamic> toMap(){
  return {
    'uid':uid,
    'email':email,

  };
}

}