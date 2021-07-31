import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LengthLimitingTextInputFormatter;
import 'package:idealog/Idea/code/ideaManager.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/customDecoration/inputDecoration.dart';
import 'package:idealog/design/colors.dart';
import 'package:provider/provider.dart';
import 'views/Tasks/MultiSelectTile/Notifier.dart';
import 'views/Tasks/TaskList.dart';
import 'views/appBar/appBar.dart';

class IdeaDetail extends StatelessWidget {

  IdeaDetail({required this.idea}):
  description = TextEditingController(text: idea.moreDetails);

  final Idea idea;
  late final TextEditingController? description;
  final ValueNotifier<bool> descriptionEnabled = ValueNotifier(false);
  final FocusNode descriptionFocus = FocusNode();

  Future<void> submitDescriptionForChange() async {
      descriptionEnabled.value = false;
      await IdeaManager.changeMoreDetail(idea: idea, newMoreDetail: description!.text);
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body: MultiProvider(
          providers: [
          ChangeNotifierProvider<Idea>.value(value: idea),
          ChangeNotifierProvider<MultiSelect>.value(value: MultiSelect.instance),
          ],
          child: Column(
            children: [
              DetailAppBar(idea: idea),
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
                            child: ValueListenableBuilder(
                              valueListenable: descriptionEnabled,
                              builder: (BuildContext context, bool isEnabled, _)=>
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Flexible(
                                    flex: 5,
                                    child: Container(
                                      decoration: (isEnabled)?elevatedBoxDecoration:null,
                                      child: TextField(
                                        autofocus: true,
                                        focusNode: descriptionFocus,
                                        maxLines: null,
                                        controller: description,
                                        enabled: (isEnabled),
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.done,
                                        inputFormatters:[
                                          LengthLimitingTextInputFormatter(300),
                                        ],
                                        onSubmitted: (_) async => await submitDescriptionForChange(),
                                        onEditingComplete: () async => await submitDescriptionForChange(),

                                        decoration: formTextField.copyWith(
                                          filled: (isEnabled),
                                          labelText: 'Description',
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: (!isEnabled),
                                    child: Flexible(
                                      flex: 1,
                                      child: IconButton(
                                        icon: Icon(Icons.edit_outlined,color: Black242424),
                                        onPressed: ()=> descriptionEnabled.value = true
                                        )
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                       SizedBox(height: 30),
                      TaskManager()
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
