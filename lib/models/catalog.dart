class Catalog {
  int id;
  String major;
  String minor;
  String description = '';

  Catalog(
      {this.id = 0, this.major = '', this.minor = '', this.description = ''});

  Catalog.fromJson(Map json)
      : id = json['id'] is int ? json['id'] : null,
        major = json['major'] is String ? json['major'] : '',
        description = json['description'] is String ? json['description'] : '',
        minor = json['minor'] is String ? json['minor'] : '';
}
