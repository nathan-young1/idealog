import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewIdea extends StatefulWidget {
  @override
  _NewIdeaState createState() => _NewIdeaState();
}

class _NewIdeaState extends State<NewIdea> {
  List<String> tasks = [];
  TextEditingController taskField = TextEditingController();
  FocusNode taskFieldFocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          toolbarHeight: kToolbarHeight*1.2,
          leading: Padding(
            padding: EdgeInsets.all(30.w),
            child: Icon(Icons.arrow_back_ios,size: 35.r,),
          ),
          title: Padding(
            padding: EdgeInsets.only(top: 30.w),
            child: Text('ADD IDEA'),
          ),
          titleTextStyle: TextStyle(fontSize: 19),
        ),
        body: SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Idea title',
                    prefixIcon: Icon(Icons.text_fields)
                  ),
                ),
                TextFormField(
                  maxLines: null,
                  minLines: 5,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)
                    ),
                    labelText: 'More details on idea...'
                  ),
                ),
                CheckboxListTile(
                  title: Text('Set Deadline'),
                  value: true,
                  onChanged: (bool? value){}),
                Row(
                  children: [
                    Text('Deadline: '),
                    Container(
                      width: 200,
                      child: TextField(
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.date_range),
                          labelText: 'dd/mm/year'
                        ),
                      ),
                    )
                  ],
                ),
                Text('Add Tasks required for idea'),
                Row(children: [
                  Icon(Icons.info),
                  Text('Press '),
                  Container(
                    color: Colors.grey,
                    child: Text('Enter'),
                  ),
                  Text('to add task.')
                ],),
                _allTasks(),
                TextFormField(
                  controller: taskField,
                  focusNode: taskFieldFocus,
                  onFieldSubmitted: (newTask){
                    taskFieldFocus.requestFocus();
                    if(newTask != ''){
                    setState(() => tasks.add(newTask));
                    taskField.text = '';
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Task',
                    suffixIcon: IconButton(icon: Icon(Icons.cancel),
                    onPressed: () => taskField.text = '')
                  ),
                )
              ],
            ),),
        ),
          bottomNavigationBar: Container(
            height: 50,
            color: Colors.green,
            child: Center(
              child: Text('Save'),
            ),),
      ),
    );
  }

  Widget _allTasks() {
    return Column(
      children: [
        for(String task in tasks) 
        Row(children: [
          Icon(Icons.circle),
          Container(child: Text(task)),
          IconButton(
          icon: Icon(Icons.cancel),
          onPressed: (){
            setState(() =>tasks.remove(task));
            })
          ])]
    );
}
}
