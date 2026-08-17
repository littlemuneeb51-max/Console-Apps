class UserProfile {
  final String id;
  final String name;
  final String title;
  final String url;

  UserProfile({
    required this.id,
    required this.name,
    required this.title,
    required this.url,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'title': title,
        'url': url,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        id: json['id'] as String,
        name: json['name'] as String,
        title: json['title'] as String,
        url: json['url'] as String,
      );
}
