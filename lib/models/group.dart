class Group {
  String name;
  String numberOfUser;

  Group(this.name, this.numberOfUser);

  Group.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    numberOfUser = json['numberOfUser'];
  }
}
