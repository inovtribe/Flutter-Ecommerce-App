class HorizontalSliderItem{
  String title;
  String imageSrc;
  int resourceId;

  HorizontalSliderItem({
  this.title,
  this.imageSrc,
  this.resourceId
  });

  HorizontalSliderItem.fromJson(Map<String, dynamic> json):
      title=json['title'],
      imageSrc=json['imageSrc'],
      resourceId=json['resourceId'];
}