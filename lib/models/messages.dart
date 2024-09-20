class Messages {
  //
  Role role;
  String content;

  //constructor
  Messages({
    this.role = Role.user,
    this.content = "",
  });

  //fromjson
  factory Messages.fromJson(Map<String, dynamic> json) {
    return Messages(
      //casting role to Role
      role: Role.values.firstWhere(
        (element) => element.toString() == json['role'],
        orElse: () => Role.user,
      ),
      content: json['content'] ?? "",
    );
  }

  //tojson
  Map<String, dynamic> toJson() {
    return {
      'role': role.name,
      'content': content,
    };
  }
}

//enum for role
enum Role {
  user,
  assistant,
}

//enum ImageSize
enum ImageSize {
  size256,
  size512,
  size1024,
}

//eunm ImageSize value
extension ImageSizeValue on ImageSize {
  String get name {
    switch (this) {
      case ImageSize.size256:
        return "256x256";
      case ImageSize.size512:
        return "512x512";
      case ImageSize.size1024:
        return "1024x1024";
    }
  }
}
