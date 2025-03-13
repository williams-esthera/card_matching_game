class Cards{
String frontImg;
String backImg;
int id;

  Cards({
    required this.frontImg,
    required this.id,
    this.backImg = "assets/images/Back.png",
  });

  int get getId => id;
  String get getBackImg => backImg;
  String get backFrontImg => frontImg;

  @override
  bool operator ==(Object other) {
    return identical(this, other) || 
           (other is Cards && other.id == id); // Use id to compare
  }

  @override
  int get hashCode => id.hashCode; // Ensure the hashCode is based on the id

}