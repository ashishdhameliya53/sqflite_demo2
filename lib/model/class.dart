class Class{
 int? class_id;
 String class_name;
 String class_details;
 String class_room_num;

 Class({
      this.class_id,required this.class_name,required this.class_details,required this.class_room_num});

 factory Class.fromMap(Map<String, dynamic> json) =>
     Class( class_name: json['class_name'], class_details: json['class_details'], class_room_num: json['class_room_num']);

 Map<String,dynamic> toMap() => {
  //  'class_id' :class_id,
  'class_name':class_name,
  'class_details':class_details,
  'class_room_num':class_room_num,
 };
}