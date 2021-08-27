import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:idealog/Prefs&Data/phoneSizeInfo.dart';
import 'package:idealog/Prefs&Data/prefs.dart';
import 'package:idealog/customWidget/flushbar.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:idealog/global/paths.dart';
import 'package:idealog/settings/code/PremiumClass.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class UpgradeToPremium extends StatefulWidget {
  @override
  _UpgradeToPremiumState createState() => _UpgradeToPremiumState();
}

class _UpgradeToPremiumState extends State<UpgradeToPremium> {

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: percentHeight(2.5)),
                Row(
                  children: [
                    SizedBox(width: 12),
                    IconButton(icon: Icon(Icons.arrow_back),
                    iconSize: 35,
                    onPressed: ()=>Navigator.pop(context)),
                    SizedBox(width: 10),
                    AutoSizeText("Premium Access", 
                          style: AppFontWeight.medium,
                          maxFontSize: AppFontSize.fontSize_28,
                          minFontSize: AppFontSize.medium,
                          ),
                  ],
                ),
        
                Center(
                  child: Container(
                    width: percentWidth(70),
                    constraints: BoxConstraints(maxWidth: 250.w),

                  child: Image.asset(
                  Provider.of<Paths>(context).pathToPremiumAccessPic,
                  fit: BoxFit.contain)
                  ),
                ),
        
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: AutoSizeText("Features", 
                          style: AppFontWeight.medium,
                          maxFontSize: AppFontSize.fontSize_28,
                          minFontSize: AppFontSize.medium,
                          ),
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
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: 'Duration: ',
                            style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.medium, color: Black242424)
                          ),
                          TextSpan(text: '1 year',
                          style: AppFontWeight.reqular.copyWith(fontSize: AppFontSize.normal, color: Black242424)
                          )
                        ]
                        )
                        )
                  ]),
                ),
                SizedBox(height: 30),
                _PurchaseButton(),
                SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class PremiumFeatureTile extends StatelessWidget {
  final String _feature;
  PremiumFeatureTile(this._feature);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
      Icon(Icons.circle,size: 17, color: Theme.of(context).bottomNavigationBarTheme.backgroundColor!),
      SizedBox(width: 10),
      Text(_feature,style: AppFontWeight.reqular.copyWith(fontSize: AppFontSize.fontSize_20))
    ]
    );
  }
}

class _PurchaseButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IgnorePointer(
          ignoring: Provider.of<Premium>(context).isPremiumUser,
          child: Container(
            height: 55,
            width: 220,
            child: ElevatedButton.icon(
            
            onPressed: () async { 
              if(!await Premium.instance.buyProduct()) anErrorOccuredFlushBar(context: context);
              },
            style: ButtonStyle(
              elevation: MaterialStateProperty.resolveWith((states) => Provider.of<Premium>(context).isPremiumUser ?0 :null),
              backgroundColor: MaterialStateColor.resolveWith((states) => Provider.of<Premium>(context).isPremiumUser ?(Prefrences.instance.isDarkMode) ?LightDark :LightGray :Theme.of(context).bottomNavigationBarTheme.backgroundColor!),
              shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))
            ),
             icon: Icon(FontAwesomeIcons.solidCreditCard,size: 30,color: Provider.of<Premium>(context).isPremiumUser?Theme.of(context).bottomNavigationBarTheme.backgroundColor!:Colors.white),
             label: Padding(
               padding: EdgeInsets.only(left: 12),
               child: Text(Provider.of<Premium>(context).isPremiumUser?'Purchased':'Get Access',style: dosis.copyWith(fontSize: 20,color: Provider.of<Premium>(context).isPremiumUser? (Prefrences.instance.isDarkMode) ?Colors.white :Colors.black:Colors.white)),
             )),
          ),
        ),
      ],
    );
  }
}