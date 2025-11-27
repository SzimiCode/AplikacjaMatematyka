class Tempquizquestionfirsttype {

  Tempquizquestionfirsttype(this.text, this.answers);

  final String text;
  late final List<String> answers;
  
  //metoda do mieszania pytań z quizu
  List<String> getShuffledAnswersFirstType() {
    final shuffleListFirstType = List.of(answers);
    shuffleListFirstType.shuffle();
    return shuffleListFirstType;
  }
}