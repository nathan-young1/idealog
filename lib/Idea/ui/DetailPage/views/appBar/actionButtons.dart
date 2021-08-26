import 'package:flutter/material.dart';
import 'package:idealog/Idea/code/ideaManager.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/customWidget/alertDialog/deleteDialog.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/global/routes.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({
    Key? key,
    required this.idea,
  }) : super(key: key);

  final Idea idea;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FavoriteIconWidget(idea: idea),
        SizedBox(width: 5),

        PopupMenuButton<dynamic>(
            iconSize: 30,
            padding: EdgeInsets.zero,
            onSelected: (_) async{ 
              if((await showDeleteDialog(context: context, titleOfIdeaToDelete: idea.ideaTitle))!){
                await IdeaManager.deleteIdeaFromDb(idea);
                await Navigator.pushReplacementNamed(context, menuPageView);
              }
            },

            itemBuilder: (BuildContext context) => [
                PopupMenuItem( 
                  value: 0,
                  child: Container(
                    child: Row(
                      children: [
                      Icon(Icons.delete_sweep,size: 30),
                      SizedBox(width: 10),
                      Text('Delete',style: TextStyle(fontSize: 18))
                    ]),
                  ),
                )
            ],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          )
                     ],
    );
  }
}

class FavoriteIconWidget extends StatefulWidget {
  const FavoriteIconWidget({
    Key? key,
    required this.idea,
  }) : super(key: key);

  final Idea idea;

  @override
  _FavoriteIconWidgetState createState() => _FavoriteIconWidgetState();
}

class _FavoriteIconWidgetState extends State<FavoriteIconWidget> with SingleTickerProviderStateMixin{

  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this);

    _colorAnimation = ColorTween(begin: Colors.grey, end: HighPriorityColor)
                        .animate(_controller);

    _sizeAnimation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 30, end: 50),
          weight: 50
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 50, end: 30),
          weight: 50
        ),
      ]
    ).animate(_controller);
    
    // If the idea is a favorite, set the controller value to 1 meaning animation completed, so that on press it will just reverse the animation.
    if(widget.idea.isFavorite)
      _controller.value = 1;

    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, _) =>
      IconButton(
      icon: Icon(Icons.favorite,size: _sizeAnimation.value,color: _colorAnimation.value),
      onPressed: () async {
        (widget.idea.isFavorite)
          ? _controller.reverse()
          : _controller.forward();

        await IdeaManager.setFavorite(idea: widget.idea);
      }
        ),
    );
  }
}