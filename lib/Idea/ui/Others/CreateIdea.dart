import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LengthLimitingTextInputFormatter;
import 'package:idealog/Idea/code/ideaManager.dart';
import 'package:idealog/SearchBar/SearchNotifier.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/customAppBar/appBar.dart';
import 'package:idealog/customDecoration/inputDecoration.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:provider/provider.dart';
import 'ListOfTasksToAdd.dart';
import 'OpenBottomSheet.dart';

class NewIdea extends StatefulWidget {

  static final List<Map> tasksForIdea = [];

  @override
  _NewIdeaState createState() => _NewIdeaState();
}

class _NewIdeaState extends State<NewIdea> {

  List<Task> allNewTasks = [];
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

    addBottomSheetTaskToList = (Task task)=> setState(() => allNewTasks.add(task));
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
                          inputFormatters:[
                          LengthLimitingTextInputFormatter(50),
                          ],
                          validator: (value){
                            if(value!.isEmpty)
                            return "Idea title is required";
    
                            else if(checkIfIdeaAlreadyExists(ideaTitle: value,context: context))
                            return "Idea title already exists";
                            
                          },
                          style: TextStyle(fontSize: 18),
                          decoration: formTextField.copyWith(labelText: 'Idea title', prefixIcon: Icon(Icons.text_fields), fillColor: Theme.of(context).cardTheme.color)
                        ),
                      ),
    
                      SizedBox(height: 20),
                      Container(
                        decoration: elevatedBoxDecoration,
                        child: TextFormField(
                          controller: moreDetails,
                          maxLines: null,
                          inputFormatters:[
                          LengthLimitingTextInputFormatter(300),
                          ],
                          minLines: 5,
                          style: TextStyle(fontSize: 18),
                          keyboardType: TextInputType.multiline,
                          decoration: formTextField.copyWith(labelText: 'Idea Description...', fillColor: Theme.of(context).cardTheme.color),
                        ),
                      ),
    
                      SizedBox(height: 25),
                      Text('Tasks required',style: TextStyle(fontSize: 25)),
                      SizedBox(height: 15),
                      HowToAddTaskInfo(),
    
                      SizedBox(height: 15),
                      ListOfTasksToAdd(tasks: allNewTasks),
    
                      SizedBox(height: 10),
                      OpenBottomSheet(addBottomSheetTaskToList),
    
                      SizedBox(height: 50)
                    ],
                  ),
                ),),
            ),
          ),

          bottomNavigationBar: GestureDetector(
            onTap: () async {
                FocusScope.of(context).unfocus();

                if(formKey.currentState!.validate())
                    await IdeaManager.addIdeaToDb(
                    context: context,
                    ideaTitle: ideaTitle.text,
                    moreDetails: moreDetails.text,
                    allNewTasks: allNewTasks);
              },
            child: Container(
              height: 65,
              color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
              child: Center(
                child: Text('Save',style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.large,color: Colors.white)),
              )),
          ),
        ),
      );
  }
}


class HowToAddTaskInfo extends StatelessWidget {
  const HowToAddTaskInfo({
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
