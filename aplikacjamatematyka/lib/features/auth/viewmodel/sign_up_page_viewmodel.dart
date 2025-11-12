import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';


class SignUpPageViewmodel {
 void onBackButtonPressed(){
    selectedPageNotifier.value = 0;
  }
}