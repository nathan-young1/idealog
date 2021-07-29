import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SlidableList with ChangeNotifier{

  SlidableList._(){
    controller = SlidableController(
      onSlideIsOpenChanged: (bool? value)=> notifyListeners(),
      onSlideAnimationChanged: (_){}
      );
  }

  static final SlidableList instance = SlidableList._();

  late final SlidableController controller;

  /// Checks if a particular cards slidable is open through the context given.
  static bool isOpen(BuildContext context)=> 
      Slidable.of(context)!.renderingMode == SlidableRenderingMode.slide;
}