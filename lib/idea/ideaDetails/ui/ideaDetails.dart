import 'package:flutter/material.dart';
import 'package:idealog/core-models/ideasModel.dart';
import 'package:idealog/customDecoration/boxDecoration.dart';
import 'package:idealog/idea/ideaDetails/ui/detailTaskList.dart';
import 'package:idealog/sqlite-db/sqlite.dart';
import 'detailAppBar.dart';

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
  bool descriptionEnabled = false;
  FocusNode descriptionFocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            DetailAppBar(idea: widget.idea),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20,left: 15,right: 10),
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
                               onSubmitted: (_) async {setState((){
                                 descriptionEnabled=false;
                                 widget.idea.changeMoreDetail(widget.description!.text);
                                 });
                                 await Sqlite.updateDb(widget.idea.uniqueId, idea: widget.idea);},
                              decoration: InputDecoration(
                                disabledBorder: InputBorder.none,
                                filled: (descriptionEnabled),
                                enabledBorder: UnderlineInputBorder(),
                                labelText: 'Description',
                              ),
                            ),
                          ),
                          Visibility(
                            visible: (!descriptionEnabled),
                            child: Flexible(
                              flex: 1,
                              child: IconButton(icon: Icon(Icons.edit),onPressed: ()=>setState((){
                                descriptionEnabled=true;
                                descriptionFocus.requestFocus();})),
                            ),
                          )
                        ],
                      ),
                    ),
                   SizedBox(height: 20),
                   DetailTasksList(idea: widget.idea)
                  ],
                ),
              ),
            ),
          ]),
      ),
    );
  }
}
