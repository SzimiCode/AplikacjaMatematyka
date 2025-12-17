import 'package:aplikacjamatematyka/core/data/notifiers.dart';

class FinishQuizPageViewmodel {

  void onBackButtonPressed(){
    selectedPageNotifier.value = 0;
  }

}