class EduContainer{

  final String title;
  final String desc;
  final String thumbnailURL;
  final String src;
  final String provider;
  final String providerURL;

  EduContainer({
    required this.title, 
    required this.desc, 
    required this.thumbnailURL, 
    required this.src, 
    required this.provider,
    required this.providerURL});

    static EduContainer fromJson(json) => EduContainer(
      title: json["title"] as String,
       desc: json["desc"] as String, 
       thumbnailURL: json["thumbnailURL"] as String, 
       src: json["url"] as String, 
       provider: json["provider"] as String, 
       providerURL: json["providerImageURL"] as String);
    }
