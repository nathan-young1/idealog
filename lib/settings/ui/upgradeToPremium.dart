import 'package:flutter/material.dart';
import 'package:idealog/design/textStyles.dart';

class UpgradeToPremium extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(width: 12),
                  IconButton(icon: Icon(Icons.arrow_back,color: Colors.black87),
                  iconSize: 35,
                  onPressed: ()=>Navigator.pop(context)),
                  SizedBox(width: 10),
                  Text('Premium Access',style: Poppins.copyWith(fontSize: 28))
                ],
              ),

              SizedBox(height: 60),
              Padding(
                padding: EdgeInsets.only(left: 30),
                child: Text('Features',style: Overpass.copyWith(fontWeight: FontWeight.w200,fontSize: 30),),
              )
          ],
        ),
      ),
    );
  }
}