import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:idealog/idea/ideaDetails/ui/ideaDetails.dart';
import 'package:idealog/productivity/code/productivityManager.dart';
import 'package:provider/provider.dart';

class FavoriteTasks extends StatelessWidget {
  const FavoriteTasks({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Idea> favorites = Provider.of<ProductivityManager>(context).getFavoriteTasks();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: LightPink.withOpacity(0.15),
          ),
          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
        child: Column(
          children: [
            Text('Favorite Tasks',
            style: RhodiumLibre.copyWith(fontSize: 25)),
            if(favorites.length > 0)
            for(int index = 0; index < favorites.length; index++)
            GestureDetector(
              onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>IdeaDetail(idea: favorites[index]))),
              child: ListTile(leading: (index == 0)?FaIcon(FontAwesomeIcons.solidHeart,color: Colors.red[700])
                  :(index == 1)?FaIcon(FontAwesomeIcons.solidHeart,color: Colors.blue)
                  :FaIcon(FontAwesomeIcons.solidHeart,color: Colors.amber),
              title: Text(favorites[index].ideaTitle,
              style: Lato.copyWith(fontSize: 18),
              overflow: TextOverflow.ellipsis,
              ),
              trailing: Icon(Icons.arrow_forward_ios)),
            )
            else
            Text('No tasks available',
            style: Lato.copyWith(fontSize: 19))
            ],
        ),
      ),
    );
  }
}