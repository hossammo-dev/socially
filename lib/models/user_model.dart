class UserModel {
  String userId;
  String username;
  String email;
  String avatarUrl;
  String bio;
  String password;
  int postsNumber;
  int followersNumber;
  int followingNumber;

  UserModel({
    this.userId,
    this.username,
    this.email,
    this.avatarUrl,
    this.bio,
    this.password,
    this.postsNumber,
    this.followersNumber,
    this.followingNumber,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    this.userId = json['id'];
    this.username = json['username'] ?? 'Failed to get the username';
    this.email = json['email'] ?? 'Failed to get the emial';
    this.avatarUrl = json['avatar_url'] ?? 'Failed to get the image url';
    this.bio = json['bio'] ?? 'Failed to get the biography';
    this.password = json['password'];
    this.postsNumber = json['posts_number'];
    this.followersNumber = json['followers_number'];
    this.followingNumber = json['following_number'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.userId,
      'username': this.username,
      'email': this.email,
      'avatar_url': this.avatarUrl,
      'bio': this.bio,
      'password': this.password,
      'posts_number': this.postsNumber,
      'followers_number': this.followersNumber,
      'following_number': this.followingNumber,
    };
  }
}
