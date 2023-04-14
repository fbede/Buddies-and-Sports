import 'package:flutter/material.dart';

///These are the different sports interest the user could have. The strings are left here because they would be easy to main since they are part of the model and are already in one file
enum Interest {
  football('Football', Icons.sports_soccer),
  basketball('Basketball', Icons.sports_basketball),
  hockey('Hockey', Icons.sports_hockey),
  motorSports('MotorSports', Icons.sports_motorsports),
  rugby('Rugby', Icons.sports_football),
  skiing('Skiing', Icons.downhill_skiing),
  tennis('Tennis', Icons.sports_tennis),
  wrestling('Wrestling', Icons.sports_kabaddi);

  final String name;
  final IconData icon;

  const Interest(this.name, this.icon);
}
