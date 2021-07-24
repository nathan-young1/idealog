import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:idealog/SearchBar/SearchNotifier.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:idealog/customAppBar/appBar.dart';
import 'package:idealog/customDecoration/inputDecoration.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:provider/provider.dart';

  enum PRIORITY{HIGH,MEDIUM,LOW}

class NewIdea extends StatefulWidget {
  @override
  _NewIdeaState createState() => _NewIdeaState();
}

class _NewIdeaState extends State<NewIdea> {
  Set<String> tasks = <String>{};
  TextEditingController taskField = TextEditingController();
  TextEditingController deadline = TextEditingController();
  TextEditingController ideaTitle = TextEditingController();
  TextEditingController moreDetails = TextEditingController();
  FocusNode taskFieldFocus = FocusNode();
  GlobalKey<FormState> formKey = GlobalKey();

  void addNewTask(){
    if(taskField.text != ''){
      setState(() => tasks.add(taskField.text));
      taskField.clear();
      }
  }

  bool checkIfIdeaAlreadyExists({required String ideaTitle,required BuildContext context})=>
     Provider.of<List<Idea>>(context,listen: false).map((ideaModel) => ideaModel.ideaTitle).contains(ideaTitle);

  @override
  void initState() { 
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) => SearchController.instance.stopSearch());
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
                    Text('Tasks required for idea',style: TextStyle(fontSize: 25)),
                    SizedBox(height: 15),
                    Info(),

                    SizedBox(height: 15),
                    RequiredTasks(),

                    SizedBox(height: 10),
                    TextFormField(
                      controller: taskField,
                      focusNode: taskFieldFocus,
                      keyboardType: TextInputType.text,
                      maxLines: null,
                      maxLength: 350,
                      onFieldSubmitted: (_){
                        taskFieldFocus.requestFocus();
                        addNewTask();
                      },
                      style: TextStyle(fontSize: 18),
                      decoration: underlineAndFilled.copyWith(
                        labelText: 'Task',
                        suffixIcon: IconButton(icon: Icon(Icons.check,color: LightPink.withOpacity(0.7),size: 30),
                        onPressed: () => addNewTask())
                      ),
                    ),

                    SizedBox(height: 50)
                  ],
                ),
              ),),
          ),
        ),
          bottomNavigationBar: GestureDetector(
            onTap: () async {
              FocusNode taskFieldFocus = FocusNode();
              int i=0;
                // taskFieldFocus.addListener((){
                //   // if keyboard is open and text field does not have focus, give the text field focus.
                //   if(MediaQuery.of(context).viewInsets.bottom > 0 && !taskFieldFocus.hasFocus)
                //   taskFieldFocus.requestFocus();
                // });

                // if(formKey.currentState!.validate())
                //     await IdeaManager.addIdeaToDb(
                //     context: context,
                //     ideaTitle: ideaTitle.text,
                //     moreDetails: moreDetails.text,
                //     tasks: tasks);
                showModalBottomSheet(
                enableDrag: false,
                isScrollControlled: true,
                isDismissible: false,
                context: context,
                builder: (BuildContext context) =>
                SingleChildScrollView(
                  child: AnimatedPadding(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              GestureDetector(
                                onTap: ()=> Navigator.pop(context),
                                child: Container(
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: DarkRed, width: 2),
                                    borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: Icon(Icons.close, size: 25, color: DarkRed),
                                ),
                              ),
                      
                              Text('New Task',style: overpass.copyWith(fontSize: 25)),
                      
                              ElevatedButton.icon(onPressed: (){addNewTask();},
                               icon: Icon(Icons.add), label: Text('Add',style: TextStyle(fontSize: 20)),
                               style: ButtonStyle(
                                 backgroundColor: MaterialStateProperty.resolveWith((states) => DarkBlue)
                               ),
                               )
                            ],),
                          ),
                      
                          Text('Set Priority', style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500)),
                          DropdownButton<PRIORITY>(
                            value: PRIORITY.MEDIUM,
                            items: [
                              DropdownMenuItem(child: Text("High"),value:PRIORITY.HIGH),
                              DropdownMenuItem(child: Text("Medium"),value:PRIORITY.MEDIUM),
                              DropdownMenuItem(child: Text("Low"),value:PRIORITY.LOW)
                            ],
                            onChanged: (PRIORITY? value){}),
                          
                          SizedBox(height: 30),
                          Text('Task:', style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500)),
                          SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                              BoxShadow(offset: Offset(0,0),blurRadius: 10,color: Colors.black.withOpacity(0.2))
                            ]
                            ),
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Focus(
                              onFocusChange: (hasFocus){
                                if(!hasFocus && MediaQuery.of(context).viewInsets.bottom > 0){
                                  print(++i);
                                taskFieldFocus.requestFocus();
                                }
                              },
                              child: TextFormField(
                                controller: taskField,
                                focusNode: taskFieldFocus,
                                keyboardType: TextInputType.text,
                                minLines: 2,
                                maxLines: null,
                                onFieldSubmitted: (_){
                                  taskFieldFocus.requestFocus();
                                  addNewTask();
                                },
                                style: TextStyle(fontSize: 18),
                                decoration: underlineAndFilled.copyWith(
                                  labelText: 'Task',
                                  fillColor: Colors.white,
                                  border: InputBorder.none,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none
                                  ),
                                  focusedBorder: InputBorder.none,
                                  
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30)
                        ],
                      ),
                    ),
                  ),
                ));
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
  Widget RequiredTasks() {
    return Column(
      children: [
        for(String task in tasks) 
        Row(
          children: [
          Icon(Icons.circle,color: Colors.grey,size: 20),
          SizedBox(width: 25),
          Expanded(child: Container(child: Text(task))),
          IconButton(
          icon: Icon(CommunityMaterialIcons.close,color: Colors.grey),
          onPressed: (){
            setState(() =>tasks.remove(task));
            })
          ])]
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
      Icon(Icons.info,color: LightPink.withOpacity(0.7),size: 28),
      Text(' Press ',style: TextStyle(fontSize: 20)),
      Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: LightGray,
        ),
        child: Icon(Icons.check),
      ),
      Text(' to add task.',style: TextStyle(fontSize: 20))
    ],);
  }
}
