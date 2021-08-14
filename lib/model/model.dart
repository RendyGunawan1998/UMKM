class Posts {
  final int userId;
  final int id;
  final String title;
  final String body;

  Posts({
    this.userId,
    this.id,
    this.body,
    this.title,
  });

  factory Posts.formJson(Map<String, dynamic> json) => Posts(
        userId: json['userId'],
        id: json['id'],
        title: json['title'],
        body: json['body'],
      );

  // Map<String, dynamic> toJson() => {
  //       'id': id,
  //       'title': title,
  //       'author': author,
  //       'urlImage': urlImage,
  //     };
}
