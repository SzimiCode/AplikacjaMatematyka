//ValueNotifier: hold the data
//ValueListaenableBuilder: listentothedata (don't need the setstate)
import 'package:flutter/material.dart';
ValueNotifier<int> selectedPageNotifier = ValueNotifier(12);
ValueNotifier<bool> isDarkModifier = ValueNotifier(false);
ValueNotifier<String> tempLessonName = ValueNotifier("");
