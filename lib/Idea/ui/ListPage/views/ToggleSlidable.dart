import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_slidable/flutter_slidable.dart';

class ToggleSlidable extends StatelessWidget {
  final bool slidableIsOpen;

  ToggleSlidable({
    Key? key,
    required this.slidableIsOpen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return AnimatedContainer(duration: Duration(milliseconds: 400),
      child: slidableIsOpen
      
        ? IconButton( icon:Icon(Icons.arrow_forward_ios,size: 28),
        onPressed: () =>Slidable.of(context)!.close()
        )
    
        : IconButton(onPressed: () => Slidable.of(context)!.open(actionType: SlideActionType.secondary),
        icon: Icon(Icons.more_vert,size: 32))
       );
  }
}