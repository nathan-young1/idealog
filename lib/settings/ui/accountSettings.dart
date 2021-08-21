import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:idealog/Prefs&Data/GoogleUserData.dart';
import 'package:idealog/customDecoration/inputDecoration.dart';
import 'package:idealog/customWidget/profilePicWidget.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:idealog/global/routes.dart';
import 'package:idealog/settings/code/PremiumClass.dart';
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
                          Text('Account Settings',style: dosis.copyWith(fontSize: 28))
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
          
        //   Padding(
        //     padding: const EdgeInsets.only(top: 30),
        //     child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //         SizedBox(height: 10),
        //         Padding(
        //           padding: EdgeInsets.only(left: 25),
        //           child: Text('Your Account Features',style: overpass.copyWith(fontWeight: FontWeight.w200,fontSize: 30),),
        //         ),
        //         Padding(
        //           padding: EdgeInsets.only(left: 30,top: 10),
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               PremiumFeatureTile('Backup Data'),
        //               SizedBox(height: 10),
        //               PremiumFeatureTile('Biometric Authentication')
        //             ],
        //           ),
        //         ),
        //     ],
        // ),
        //   ),

        //   SizedBox(height: 20),
        //   Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 30),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Container(
        //           height: 60,
        //           width: 150,
        //           color: LightGray,
        //           child: Row(
        //             children: [
        //               Icon(Icons.calendar_today_outlined),
        //               Column(
        //                 children: [
        //                   Text('Start Date:'),
        //                   Padding(
        //                     padding: const EdgeInsets.only(left: 10),
        //                     child: Text(convertDateTimeObjToAFormattedString(Premium.instance.premiumPurchaseDate!)),
        //                   )
        //                 ],
        //               )
        //             ],
        //           ),
        //         ),
        //         Container(
        //           height: 60,
        //           width: 150,
        //           color: LightPink,
        //           child: Row(
        //             children: [
        //               Icon(Icons.calendar_today_outlined),
        //               Column(
        //                 children: [
        //                   Text('Expiration Date:'),
        //                   Padding(
        //                     padding: const EdgeInsets.only(left: 10),
        //                     child: Text(convertDateTimeObjToAFormattedString(Premium.instance.premiumExpirationDate!)),
        //                   )
        //                 ],
        //               )
        //             ],
        //           ),
        //         )
        //     ],),
        //   ),

        //   SizedBox(height: 30),
        //   Column(
        //     children: [
        //       ListTile(
        //         title: Text('Log out',style: poppins.copyWith(fontSize: 20)),
        //         trailing: Padding(
        //             padding: EdgeInsets.symmetric(horizontal: 10),
        //             child: Container(
        //               height: 35,
        //               width: 35,
        //               child: Icon(FeatherIcons.logOut,size: 25,color: LightPink)))
        //       ),

        //       Padding(
        //             padding: const EdgeInsets.only(left: 35, right: 35, top: 5),
        //             child: Text('Note: if you have backed up your ideas to this google account, it will still be retained.'),
        //       )
        //     ],
        //   ),
        //   SizedBox(height: 15),
        //   DottedLine()

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40,vertical: 40),
            child: Container(
              padding: EdgeInsets.all(20),
              height: 80,
              decoration: elevatedBoxDecoration.copyWith(color: Colors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Sign in with Google',style: TextStyle(fontSize: 20)),
                  Icon(FontAwesomeIcons.google,size: 40, color: Colors.teal[500])
                ],
              ),
            ),
          ),

          DottedLine(),
          GestureDetector(
              onTap: ()=> Navigator.pushNamed(context, upgradeToPremiumPage),
              child: Column(
                children: [
                  ListTile(
                    title: Text('Get premium',style: dosis.copyWith(fontSize: 20),),
                    trailing: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: LightGray,
                          ),
                          child: Icon(Icons.arrow_forward_ios,size: 20,color: Colors.black87)))
                  ),
            
                  Padding(
                    padding: const EdgeInsets.only(left: 35, right: 35, top: 5),
                    child: Text('Note: Get premium access to enjoy special features.'),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            DottedLine()
          ],
        ),
      ),
    );
  }
}