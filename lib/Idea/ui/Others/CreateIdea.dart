import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
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
  ValueNotifier<List<Task>> allNewTasks = ValueNotifier([]);
  TextEditingController deadline = TextEditingController();
  TextEditingController ideaTitle = TextEditingController();
  TextEditingController moreDetails = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();

  bool checkIfIdeaAlreadyExists({required String ideaTitle,required BuildContext context})=>
     Provider.of<List<Idea>>(context,listen: false).map((ideaModel) => ideaModel.ideaTitle).contains(ideaTitle);

  late Function(Task task) addBottomSheetTaskToList;

  @override
  void initState() { 
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) => SearchController.instance.stopSearch());

    addBottomSheetTaskToList = (Task task){
       allNewTasks.value.add(task);
       setState(() {});
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
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
                      SizedBox(height: 10),
                      Container(
                        decoration: elevatedBoxDecoration,
                        child: TextFormField(
                          controller: ideaTitle,
                          validator: (value){
                            if(value!.isEmpty)
                            return "Idea title is required";
    
                            else if(checkIfIdeaAlreadyExists(ideaTitle: value,context: context))
                            return "Idea title already exists";
                            
                          },
                          style: TextStyle(fontSize: 18),
                          decoration: formTextField.copyWith(labelText: 'Idea title', prefixIcon: Icon(Icons.text_fields))
                        ),
                      ),
    
                      SizedBox(height: 20),
                      Container(
                        decoration: elevatedBoxDecoration,
                        child: TextFormField(
                          controller: moreDetails,
                          maxLines: null,
                          minLines: 5,
                          style: TextStyle(fontSize: 18),
                          keyboardType: TextInputType.multiline,
                          decoration: formTextField.copyWith(labelText: 'Idea Description...'),
                        ),
                      ),
    
                      SizedBox(height: 25),
                      Text('Tasks required',style: TextStyle(fontSize: 25)),
                      SizedBox(height: 15),
                      Info(),
    
                      SizedBox(height: 15),
                      ListOfTasks(),
    
                      SizedBox(height: 10),
                      AddTaskButton(addBottomSheetTaskToList),
    
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
                      allNewTasks: allNewTasks.value);
                },
              child: Container(
                height: 65,
                color: DarkBlue,
                child: Center(
                  child: Text('Save',style: overpass.copyWith(fontSize: 32,color: Colors.white)),
                )),
            ),
        ),
      );
  }

  // ignore: non_constant_identifier_names
  Widget ListOfTasks(){
    return ValueListenableBuilder(
      valueListenable: allNewTasks,
      builder: (context, List<Task> tasks, _) => Column(
          children: tasks.reversed.map((taskRow) =>
            Row(
              children: [
                Icon(Icons.circle,color: Colors.grey,size: 20),
                SizedBox(width: 25),
                Expanded(child: Container(child: Text(taskRow.task))),
                IconButton(
                icon: Icon(CommunityMaterialIcons.close,color: Colors.grey),
                onPressed: (){ 
                  allNewTasks.value.remove(taskRow); 
                  setState(() {});})
              ])
              ).toList()),
    );
  }
}



class AddTaskButton extends StatelessWidget {
  Function(Task task) addBottomSheetTaskToList;
  AddTaskButton(this.addBottomSheetTaskToList);

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
                AddTaskBottomSheet(addBottomSheetTaskToList));
                },
                
      child: Container(
        decoration: elevatedBoxDecoration,
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
