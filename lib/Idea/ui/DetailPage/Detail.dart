import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:idealog/Databases/idealog-db/idealog_Db.dart';
import 'package:idealog/Idea/ui/DetailPage/views/Tasks/SearchBar/SearchNotifier.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/design/colors.dart';
import 'package:provider/provider.dart';
import 'views/Tasks/MultiSelectTile/Notifier.dart';
import 'views/Tasks/TaskList.dart';
import 'views/appBar/appBar.dart';

class IdeaDetail extends StatefulWidget {
  final Idea idea;
  late final TextEditingController? description;
  IdeaDetail({required this.idea}){
    description = TextEditingController(text: idea.moreDetails);
  }

  @override
  _IdeaDetailState createState() => _IdeaDetailState();
}

class _IdeaDetailState extends State<IdeaDetail> {
  
  @override
  void initState() { 
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) => SearchController.instance.stopSearch());
    super.initState();
  }

  bool descriptionEnabled = false;
  FocusNode descriptionFocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: MultiProvider(
          providers: [
          ChangeNotifierProvider<Idea>.value(value: widget.idea),
          ChangeNotifierProvider<MultiSelect>.value(value: MultiSelect.instance),
          ],
          child: Column(
            children: [
              DetailAppBar(idea: widget.idea),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 50),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20,left: 15,right: 10),
                          child: DottedBorder(
                            color: Colors.grey,
                            padding: EdgeInsets.all(10),
                            dashPattern: [5, 5],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Flexible(
                                  flex: 5,
                                  child: TextField(
                                    focusNode: descriptionFocus,
                                    maxLines: null,
                                    maxLength: (descriptionEnabled)?300:null,
                                    controller: widget.description,
                                    enabled: (descriptionEnabled),
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.done,
                                     onSubmitted: (_) async {
                                        descriptionEnabled=false;
                                        widget.idea.changeMoreDetail(widget.description!.text);
                                       await IdealogDb.instance.changeMoreDetail(idea: widget.idea);
                                       setState((){});
                                       },
                                    decoration: InputDecoration(
                                      disabledBorder: InputBorder.none,
                                      filled: (descriptionEnabled),
                                      labelText: 'Description',
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: (!descriptionEnabled),
                                  child: Flexible(
                                    flex: 1,
                                    child: IconButton(icon: Icon(Icons.edit_outlined,color: Black242424),
                                      onPressed: ()=> setState((){
                                      descriptionEnabled=true;
                                      descriptionFocus.requestFocus();
                                      })),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                       SizedBox(height: 30),
                       DetailTasksList(idea: widget.idea)
                      ],
                    ),
                  ),
                ),
              ),
            ]),
        ),
      ),
    );
  }
}
