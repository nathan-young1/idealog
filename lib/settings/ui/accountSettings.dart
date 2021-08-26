import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:idealog/Prefs&Data/GoogleUserData.dart';
import 'package:idealog/authentication/authHandler.dart';
import 'package:idealog/customDecoration/inputDecoration.dart';
import 'package:idealog/customWidget/alertDialog/alertDialogComponents.dart';
import 'package:idealog/customWidget/alertDialog/logOutDialog.dart';
import 'package:idealog/customWidget/flushbar.dart';
import 'package:idealog/customWidget/profilePicWidget.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:idealog/global/internetConnectionChecker.dart';
import 'package:idealog/global/routes.dart';
import 'package:idealog/global/top_level_methods.dart';
import 'package:idealog/settings/code/PremiumClass.dart';
import 'package:idealog/settings/ui/upgradeToPremium.dart';
import 'package:provider/provider.dart';

class AccountSettings extends StatelessWidget {
  const AccountSettings({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body: Consumer2<GoogleUserData, Premium>(
          builder: (_, googleUserData, premium, __)=>
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                _AccountSettingsAvatar(userProfilePic: googleUserData.userPhotoUrl),
                if (googleUserData.userEmail == null) _SignInWithGoogleContainer(),
                if(premium.isPremiumUser) _SubscriptionStatusContainer(),
                if(!premium.isPremiumUser) _GetPremiumAccessContainer(),
                if(googleUserData.userEmail != null) _SignOutFromGoogleContainer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AccountSettingsAvatar extends StatelessWidget {
  const _AccountSettingsAvatar({
    Key? key,
    required String? userProfilePic,
  }) : _userProfilePic = userProfilePic, super(key: key);

  final String? _userProfilePic;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  Text('Account Settings',style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.fontSize_28))
                ],
              ),
          
          SizedBox(height: 10),
          Column(
            children: [
              (_userProfilePic != null)
              ?ProfilePicture(photoUrl: _userProfilePic!,height: 100,width: 100)
              :Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(shape: BoxShape.circle, color: DarkGray),
                child: Icon(Icons.person, size: 60, color: Colors.white)
              ),
              SizedBox(height: 5),
              Text(GoogleUserData.instance.userEmail ?? 'Anonymous', style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.fontSize_20)),
              SizedBox(height: 5),
              Text(Premium.instance.isPremiumUser?"Premium Account":"Basic Account",style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.fontSize_20, color:Premium.instance.isPremiumUser?Colors.teal[500]:DarkRed))
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _SubscriptionStatusContainer extends StatelessWidget {
  const _SubscriptionStatusContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
      Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.only(left: 25),
            child: Text('Your Account Features',style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.fontSize_23)),
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
        
      SizedBox(height: 20),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PremiumDateContainer(isExpirationDateContainer: false),
            PremiumDateContainer(isExpirationDateContainer: true)
        ],),
      ),
      ]);
  }
}

class PremiumDateContainer extends StatelessWidget {
  const PremiumDateContainer({
    Key? key,
    required this.isExpirationDateContainer
  }) : super(key: key);

  final bool isExpirationDateContainer;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 155,
      decoration: BoxDecoration(
      color: (isExpirationDateContainer) ?LightPink :LightGray,
      borderRadius: BorderRadius.circular(5)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          (isExpirationDateContainer)
            ?Icon(FeatherIcons.flag, color: Colors.white)
            :Icon(Icons.calendar_today_outlined, color: Colors.teal),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
               Text(
               (isExpirationDateContainer)
                ?'Expiration Date:'
                :'Start Date:', 
                style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.fontSize_16,
                 color: (isExpirationDateContainer) ?Colors.white :null)),

              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  convertDateTimeObjToAFormattedString(
                  (isExpirationDateContainer)
                    ?Premium.instance.premiumExpirationDate!
                    :Premium.instance.premiumPurchaseDate!),
                  style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.fontSize_16,
                    color: (isExpirationDateContainer) ?Colors.white :null))
              )
            ],
          )
        ],
      ),
    );
  }
}

class _SignOutFromGoogleContainer extends StatelessWidget {
  const _SignOutFromGoogleContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()async { 
        bool? userWantsToLogout = await showLogOutDialog(context: context);
        if (userWantsToLogout == null) /* navigator.pop occured without a value.*/return;

        if(userWantsToLogout) await signOutFromGoogle();
        else /* backup now was clicked.*/ Navigator.pushNamed(context, backupPage);
        },
      child: Column(
        children: [
          SizedBox(height: 15),
    
          ListTile(
            title: Text('Log out',style: AppFontWeight.reqular.copyWith(fontSize: AppFontSize.fontSize_23)),
            trailing: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  height: 35,
                  width: 35,
                  child: Icon(FeatherIcons.logOut,size: 25,color: LightPink)))
          ),
    
          Padding(
                padding: const EdgeInsets.only(left: 35, right: 35, top: 5),
                child: Text('Note: if you have backed up your ideas to this google account, it will still be retained.', style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.fontSize_15)),
          ),
    
          SizedBox(height: 15),
          DottedLine()
        ],
      ),
    );
  }
}

class _GetPremiumAccessContainer extends StatelessWidget {
  const _GetPremiumAccessContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: ()=> Navigator.pushNamed(context, upgradeToPremiumPage),
        child: Column(
          children: [
            SizedBox(height: 30),

            ListTile(
              title: Text('Get premium',style: AppFontWeight.reqular.copyWith(fontSize: AppFontSize.fontSize_23)),
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
              child: Text('Note: Get premium access to enjoy special features.', style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.fontSize_15)),
            ),

            SizedBox(height: 20),
            DottedLine()
          ],
        ),
      );
  }
}

class _SignInWithGoogleContainer extends StatelessWidget {
  const _SignInWithGoogleContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()async {
        if(UserInternetConnectionChecker.userHasInternetConnection){
          showSigningInAlertDialog(context: context);
          if(await signInWithGoogle()){
            // if google sign in was a success.
            await downloadBackupFileIfAnyExistsThenWriteToDb();
            // remove the dialog.
            Navigator.of(context).pop();
          } else {
            // remove the dialog.
            Navigator.of(context).pop();
            anErrorOccuredFlushBar(context: context);
          }

        } else anErrorOccuredFlushBar(context: context);
        },
      child: Padding(
        padding: EdgeInsets.only(left: 40,top: 30, right: 40),
        child: Container(
          padding: EdgeInsets.all(20),
          height: 80,
          decoration: elevatedBoxDecoration.copyWith(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Sign in with Google',style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.fontSize_23)),
              Icon(FontAwesomeIcons.google,size: 40, color: Colors.teal[500])
            ],
          ),
        ),
      ),
    );
  }
}