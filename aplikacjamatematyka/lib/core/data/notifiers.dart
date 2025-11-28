//ValueNotifier: hold the data
//ValueListaenableBuilder: listentothedata (don't need the setstate)
import 'package:flutter/material.dart';
ValueNotifier<int> selectedPageNotifier = ValueNotifier(7);
ValueNotifier<bool> isDarkModifier = ValueNotifier(false);
ValueNotifier<String> tempLessonName = ValueNotifier("");
