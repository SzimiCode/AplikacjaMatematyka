class Tempquizquestionfirsttype {

  const Tempquizquestionfirsttype(this.text, this.answers);

  final String text;
  final List<String> answers;
  
  //metoda do mieszania pytań z quizu
  List<String> getShuffledAnswersFirstType() {
    final shuffleListFirstType = List.of(answers);
    shuffleListFirstType.shuffle();
    return shuffleListFirstType;
  }
}