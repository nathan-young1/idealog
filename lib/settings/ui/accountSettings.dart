import 'package:flutter/material.dart';
import 'package:idealog/Prefs&Data/GoogleUserData.dart';
import 'package:idealog/customWidget/profilePicWidget.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:idealog/settings/code/PremiumClass.dart';
import 'package:idealog/settings/ui/upgradeToPremium.dart';
import 'package:provider/provider.dart';

class AccountSettings extends StatelessWidget {
  const AccountSettings({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? _userProfilePic = Provider.of<GoogleUserData>(context).userPhotoUrl;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              color: LightGray,
              child: Column(
                children: [
                  SizedBox(height: 20),
                      Row(
                        children: [
                          SizedBox(width: 12),
                          IconButton(icon: Icon(Icons.arrow_back),
                          iconSize: 35,
                          onPressed: ()=>Navigator.pop(context)),
                          SizedBox(width: 10),
                          Text('Account Settings',style: poppins.copyWith(fontSize: 28))
                        ],
                      ),

                  SizedBox(height: 10),
                  Column(
                    children: [
                      (_userProfilePic != null)
                      ?ProfilePicture(photoUrl: _userProfilePic,height: 100,width: 100)
                      :Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: DarkGray),
                        child: Icon(Icons.person, size: 60, color: Colors.white)
                      ),
                      SizedBox(height: 5),
                      Text(GoogleUserData.instance.userEmail ?? 'Anonymous', style: TextStyle(fontSize: 20)),
                      SizedBox(height: 5),
                      Text(Premium.instance.isPremiumUser?"Premium Account":"Basic Account",style: TextStyle(fontSize: 20,color:Premium.instance.isPremiumUser?Colors.teal[500]:DarkRed))
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: Text('Your Account Features',style: overpass.copyWith(fontWeight: FontWeight.w200,fontSize: 30),),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30,top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PremiumFeatureTile('Backup Data'),
                      SizedBox(height: 10),
                      PremiumFeatureTile('Biometric Authentication')
                    ],
                  ),
                ),
            ],
        ),
          ),
          ],
        ),
      ),
    );
  }
}