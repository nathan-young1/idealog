import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:idealog/Idea/ui/DetailPage/Detail.dart';
import 'package:idealog/application-menu/controllers/bottomNavController.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:idealog/global/paths.dart';
import 'package:idealog/productivity/code/productivityManager.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class FeaturedIdeas extends StatelessWidget {
  const FeaturedIdeas({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var favorites = Provider.of<ProductivityManager>(context).getFavoriteTasks();
    return Container(
        decoration: BoxDecoration(
          color: ProductivityPink,
        ),
        padding: EdgeInsets.symmetric(vertical: 20,horizontal: 30),
      child: Column(
        children: [
          Text('Featured Ideas',
          style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.medium)),
          if(favorites.isNotEmpty)
          Container(
            child: Stack(
            children: [
              Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for(int index = 0; index < favorites.length; index++)
                  Favorite_Idea_Tile(favorites: favorites, index: index)
              ]),
              
              Favorite_Illustration(favorites: favorites)
            ]),
          )
          else
          Text('No favorite ideas available',
          style: AppFontWeight.reqular.copyWith(fontSize: AppFontSize.fontSize_20))
          ],
      ),
    );
  }
}

// ignore: camel_case_types
class Favorite_Idea_Tile extends StatelessWidget {
  const Favorite_Idea_Tile({
    Key? key,
    required this.favorites,
    required this.index,
  }) : super(key: key);

  final List<Idea> favorites;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.pushReplacement(context, PageTransition(child: IdeaDetail(idea: favorites[index]), type: PageTransitionType.rightToLeftWithFade));
        // reset the bottom nav controller.
        BottomNavController.instance.resetPageWithoutAnimating(ActiveNavTab.Ideas);
        },
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          children:[ (index == 0)
          ?FaIcon(FontAwesomeIcons.solidHeart,color: MostFavorite1Color)
          :(index == 1)?FaIcon(FontAwesomeIcons.solidHeart,color: MostFavorite2Color)
          :FaIcon(FontAwesomeIcons.solidHeart,color: MostFavorite3Color),

          SizedBox(width: 25),
          Text( favorites[index].ideaTitle, style: AppFontWeight.reqular.copyWith(fontSize: AppFontSize.fontSize_20), overflow: TextOverflow.ellipsis)
          ]),
      ),
    );
  }
}

// ignore: camel_case_types
class Favorite_Illustration extends StatelessWidget {
  const Favorite_Illustration({
    Key? key,
    required this.favorites,
  }) : super(key: key);

  final List<Idea> favorites;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: favorites.length > 1,
      child: Positioned(
        right: 0,
        top: 0,
        bottom: 0,
        child: Center(
          child: SvgPicture.asset(Provider.of<Paths>(context).pathToFavoritePic,
          height: 100,
          width: 140),
        ),
      ),
    );
  }
}