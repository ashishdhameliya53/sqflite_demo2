class Subject{
 int? sub_id;
 String sub_name;
 int sub_code;
 String sub_details;

 Subject({this.sub_id,required this.sub_name,required this.sub_code,required this.sub_details});

 factory Subject.fromMap(Map<String, dynamic> json) =>
     Subject( sub_name: json['sub_name'], sub_code: json['sub_code'], sub_details: json['sub_details']);

 Map<String,dynamic> toMap() => {
  //  'sub_id' : sub_id,
  'sub_name':sub_name,
  'sub_code':sub_code,
  'sub_details':sub_details,
 };
}