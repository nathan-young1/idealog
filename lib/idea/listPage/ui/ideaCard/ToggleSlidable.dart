import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_slidable/flutter_slidable.dart';

class ToggleSlidable extends StatelessWidget {
  final ValueNotifier<bool> slidableIconState;

  const ToggleSlidable({
    Key? key,
    required this.slidableIconState
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: slidableIconState,
      builder: (context, bool _slidableIconisOpen,child) =>

      AnimatedContainer(duration: Duration(milliseconds: 500),
      child: _slidableIconisOpen
      
        ? IconButton( icon:Icon(Icons.arrow_forward_ios,size: 32),
        onPressed: () =>Slidable.of(context).close()
        )
    
        : IconButton(onPressed: () => Slidable.of(context).open(actionType: SlideActionType.secondary),
        icon: Icon(Icons.more_vert,size: 32))
       ),
    );
  }
}