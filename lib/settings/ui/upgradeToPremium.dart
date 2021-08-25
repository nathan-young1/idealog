import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:idealog/customWidget/flushbar.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:idealog/global/paths.dart';
import 'package:idealog/settings/code/PremiumClass.dart';
import 'package:provider/provider.dart';


class UpgradeToPremium extends StatefulWidget {
  @override
  _UpgradeToPremiumState createState() => _UpgradeToPremiumState();
}

class _UpgradeToPremiumState extends State<UpgradeToPremium> {

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
                  Text('Premium Access',style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.fontSize_28))
                ],
              ),

              Center(
                child: Container(
                child: Image.asset(
                Provider.of<Paths>(context).pathToPremiumAccessPic,
                height: 250,
                width: 250,
                fit: BoxFit.contain)
                ),
              ),

              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text('Features',style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.fontSize_28)),
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
                          style: AppFontWeight.medium.copyWith(fontSize: AppFontSize.fontSize_28, color: Black242424)
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
              _PurchaseButton()
          ],
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
      Icon(Icons.circle,size: 17, color: DarkBlue),
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
              if(!await Premium.instance.buyProduct()) phoneCannotCheckBiometricFlushBar(context: context);
              },
            style: ButtonStyle(
              elevation: MaterialStateProperty.resolveWith((states) => Provider.of<Premium>(context).isPremiumUser ?0 :null),
              backgroundColor: MaterialStateColor.resolveWith((states) => Provider.of<Premium>(context).isPremiumUser?LightGray:DarkBlue),
              shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))
            ),
             icon: Icon(FontAwesomeIcons.solidCreditCard,size: 30,color: Provider.of<Premium>(context).isPremiumUser?DarkBlue:Colors.white),
             label: Padding(
               padding: EdgeInsets.only(left: 12),
               child: Text(Provider.of<Premium>(context).isPremiumUser?'Purchased':'Get Access',style: dosis.copyWith(fontSize: 20,color: Provider.of<Premium>(context).isPremiumUser?Colors.black:Colors.white)),
             )),
          ),
        ),
      ],
    );
  }
}