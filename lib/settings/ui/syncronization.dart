import 'package:flutter/material.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:idealog/global/strings.dart';

class Syncronization extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
        children: [
          Container(
            height: 300,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
              image: DecorationImage(
              colorFilter: ColorFilter.mode(LightGray.withOpacity(0.4), BlendMode.dstATop),
              image: ExactAssetImage(pathToDataSyncIllustration),
              fit: BoxFit.cover)
            ),
            child: Stack(
              children: [
              Positioned(
                top: 10,
                child: Row(
                  children: [
                    SizedBox(width: 15),
                    IconButton(icon: Icon(Icons.arrow_back,color: Colors.black87),
                      iconSize: 35,
                      onPressed: ()=>Navigator.pop(context)),
                    SizedBox(width: 12),
                    Text('Data Syncronization',style: Poppins.copyWith(fontSize: 24))
                  ],
                ),
              ),

              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Black242424.withOpacity(0.4),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  ),
                  child: Center(child: Text('Last Synced at: Mar 15, 2021',
                  style: Overpass.copyWith(fontSize: 18,color: Colors.white),)),
                ),
              )
            ],),
          ),

          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info_outline,color: Colors.teal.withOpacity(0.5),size: 30),
              SizedBox(width: 10),
              Text('Your data will be synced every 24 hours.',
              style: Overpass.copyWith(fontSize: 15,fontWeight: FontWeight.w300))
            ],
          )
        ],),
      ),
    );
  }
}