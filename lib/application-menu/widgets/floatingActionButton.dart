import 'package:flutter/material.dart';
import 'package:idealog/Idea/ui/TaskManager/widgets/taskSearcher.dart';
import 'package:idealog/application-menu/controllers/bottomNavController.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/global/routes.dart';
import 'package:provider/provider.dart';

class MenuFloatingActionButton extends StatelessWidget {
  const MenuFloatingActionButton({
    Key? key,
    required this.searchFieldController,
  }) : super(key: key);

  final TextEditingController searchFieldController;

  @override
  Widget build(BuildContext context) {
    return Visibility(
          visible: (Provider.of<BottomNavController>(context).currentPage == ActiveNavTab.Ideas),
          child: FloatingActionButton(
            tooltip: "Add a new idea",
            elevation: 10,
            backgroundColor: DarkBlue,
            onPressed: () async { 
              // Close the keyboard.
              FocusScope.of(context).unfocus();
              Navigator.pushNamed(context, addNewIdeaPage);
              await Future.delayed(Duration(milliseconds: 500),()=> clearSearch(searchFieldController, context));
              },
            child: Icon(Icons.add,size: 32,color: Colors.white)
          ),
        );
  }
}