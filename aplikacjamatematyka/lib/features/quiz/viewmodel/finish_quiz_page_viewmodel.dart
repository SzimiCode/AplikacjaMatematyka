import 'package:aplikacjamatematyka/core/data/notifiers.dart';

class FinishQuizPageViewmodel {

  void onClaimButtonPressed(){
    selectedPageNotifier.value = 0;
    // coś o odbieraniu ogni tutaj 
  }

}