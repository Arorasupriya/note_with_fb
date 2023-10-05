class DataModel {
  String? title;
  String? desc;
  String? dateTime;

  DataModel({this.title, this.desc, this.dateTime});

  factory DataModel.fromJson(Map<String, dynamic>json){
    return DataModel(
        title: json["title"],
        desc: json["desc"],
        dateTime: json["dateTime"]
    );
  }

  Map<String,dynamic> toJson(){
    return {
     "title": title,
     "desc":desc,
     "dateTime":dateTime
    };
  }
}
