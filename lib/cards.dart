class Cards{
String frontImg;
String backImg = "assets/images/Back.png";
String currentImg = "assets/images/Back.png";
bool isFaceUp;
bool isFrozen;
int original_id;
int card_no;

  Cards({
    required this.frontImg,
    required this.original_id,
    required this.card_no,
    this.isFaceUp = false,
    this.isFrozen = false,
  });

  int get getOriginalId => original_id;
  int get getCardNo => card_no;
  String get getBackImg => backImg;
  String get getFrontImg => frontImg;
  String get getCurrImg => currentImg;
  bool get getFaceUp => isFaceUp;
  bool get getFrozen => isFrozen;

  void flipCard(){
    if(isFaceUp && !isFrozen){
      currentImg = backImg;
      isFaceUp = !isFaceUp;
    }else if(!isFaceUp && !isFrozen){
      currentImg = frontImg;
      isFaceUp = !isFaceUp;
    } 
  }

  void freezeCard(){
    isFrozen = true;
  }

  void unfreezeCard(){
    isFrozen = false;
  }

//compares cards by card_no
  @override
  bool operator ==(Object other) {
    return identical(this, other) || 
           (other is Cards && card_no == other.card_no); 
  }

  @override
  int get hashCode => card_no.hashCode; // Ensure the hashCode is based on the card_no

}