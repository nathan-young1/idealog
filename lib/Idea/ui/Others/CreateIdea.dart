import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:idealog/Databases/idealog-db/idealog_config.dart';
import 'package:idealog/Idea/code/ideaManager.dart';
import 'package:idealog/SearchBar/SearchNotifier.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/customAppBar/appBar.dart';
import 'package:idealog/customDecoration/inputDecoration.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:provider/provider.dart';

import 'TaskBottomSheet.dart';

class NewIdea extends StatefulWidget {

  static final List<Map> tasksForIdea = [];

  @override
  _NewIdeaState createState() => _NewIdeaState();
}

class _NewIdeaState extends State<NewIdea> {
  Idea newIdea = Idea.test();
  TextEditingController deadline = TextEditingController();
  TextEditingController ideaTitle = TextEditingController();
  TextEditingController moreDetails = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();

  bool checkIfIdeaAlreadyExists({required String ideaTitle,required BuildContext context})=>
     Provider.of<List<Idea>>(context,listen: false).map((ideaModel) => ideaModel.ideaTitle).contains(ideaTitle);

  Function(List<Map> tasksForIdea) addAllTaskFromBottomSheet = (List<Map> tasksForIdea)=> tasksForIdea.addAll(tasksForIdea);

  @override
  void initState() { 
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) => SearchController.instance.stopSearch());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<Idea>.value(
      value: newIdea,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20,right: 15),
                  child: Column(
                    children: [
                      CustomAppBar(title: 'ADD IDEA'),
                      TextFormField(
                        controller: ideaTitle,
                        validator: (value){
                          if(value!.isEmpty)
                          return "idea title is required";
    
                          else if(checkIfIdeaAlreadyExists(ideaTitle: value,context: context))
                          return "idea title already exists";
                          
                        },
                        style: TextStyle(fontSize: 18),
                        maxLength: 50,
                        decoration: underlineAndFilled.copyWith(
                          labelText: 'Idea title',
                          prefixIcon: Icon(Icons.text_fields)
                        )
                      ),
    
                      SizedBox(height: 20),
                      TextFormField(
                        controller: moreDetails,
                        maxLines: null,
                        maxLength: 300,
                        minLines: 5,
                        style: TextStyle(fontSize: 18),
                        keyboardType: TextInputType.multiline,
                        decoration: underlineAndFilled.copyWith(labelText: 'More details on idea...'),
                      ),
    
                      SizedBox(height: 25),
                      Text('Tasks required',style: TextStyle(fontSize: 25)),
                      SizedBox(height: 15),
                      Info(),
    
                      SizedBox(height: 15),
                      ListOfTasks(),
    
                      SizedBox(height: 10),
                      AddTaskButton(newIdea),
    
                      SizedBox(height: 50)
                    ],
                  ),
                ),),
            ),
          ),
            bottomNavigationBar: GestureDetector(
              onTap: () async {
                  if(formKey.currentState!.validate())
                      await IdeaManager.addIdeaToDb(
                      context: context,
                      ideaTitle: ideaTitle.text,
                      moreDetails: moreDetails.text,
                      newIdea: newIdea);
                },
              child: Container(
                height: 65,
                color: DarkBlue,
                child: Center(
                  child: Text('Save',style: overpass.copyWith(fontSize: 32,color: Colors.white)),
                )),
            ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
}

class ListOfTasks extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: Provider.of<Idea>(context).uncompletedTasks.reversed.map((taskRow) =>
        Row(
          children: [
          Icon(Icons.circle,color: Colors.grey,size: 20),
          SizedBox(width: 25),
          Expanded(child: Container(child: Text(taskRow.task))),
          IconButton(
          icon: Icon(CommunityMaterialIcons.close,color: Colors.grey),
          onPressed: ()=>
            Provider.of<Idea>(context,listen: false).deleteTask(taskRow))
          ])
          ).toList());
}
}



class AddTaskButton extends StatelessWidget {
  final Idea _idea;
  AddTaskButton(this._idea);

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){ 
        // close the keyboard if open , before opening bottom sheet
        FocusScope.of(context).unfocus();
        showModalBottomSheet(
                enableDrag: false,
                isScrollControlled: true,
                isDismissible: false,
                context: context,
                builder: (BuildContext context) => 
                AddTaskBottomSheet(_idea));
                },
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(offset: Offset(0,0),blurRadius: 10,color: Colors.black.withOpacity(0.2))
          ]
        ),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Container(  
                padding: EdgeInsets.only(left: 20),
                height: 50,
                color: Colors.white,
                child: Align(
                  alignment: Alignment(-1, 0),
                  child: Text('New Task', style: poppins.copyWith(fontSize: 20)))
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: 50,
                color: LightPink,
                child: Icon(Icons.add,size: 35, color: Colors.white),
              ),
            )
          ],
        )
      ),
    );
  }
}

class Info extends StatelessWidget {
  const Info({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      Icon(Icons.info,color: LightPink.withOpacity(0.7),size: 25),
      Text(' Press ',style: TextStyle(fontSize: 20)),
      Container(
        padding: EdgeInsets.all(6),
        child: Icon(Icons.add),
      ),
      Text(' to add task.',style: TextStyle(fontSize: 20))
    ],);
  }
}
