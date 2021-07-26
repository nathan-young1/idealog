import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:idealog/design/colors.dart';
import 'package:idealog/design/textStyles.dart';
import 'package:idealog/settings/code/PremiumClass.dart';
import 'package:in_app_purchase/in_app_purchase.dart';


const Set<String> _ProductId = <String>{'premium_plan'};

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
                  Text('Premium Access',style: poppins.copyWith(fontSize: 28))
                ],
              ),

              SizedBox(height: 50),
              Padding(
                padding: EdgeInsets.only(left: 40),
                child: Text('Features',style: overpass.copyWith(fontWeight: FontWeight.w200,fontSize: 30),),
              ),
              Padding(
                padding: EdgeInsets.only(left: 50,top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Features('Backup Data'),
                    SizedBox(height: 10),
                    _Features('Biometric Authentication')
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
                          style: poppins.copyWith(color: Colors.black,fontSize: 22,fontWeight: FontWeight.w600)
                        ),
                        TextSpan(text: '1 year',
                        style: overpass.copyWith(color: Colors.black,fontSize: 25)
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

class _Features extends StatelessWidget {
  final String _feature;
  _Features(this._feature);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
      Icon(Icons.circle,size: 17,color: DarkBlue),
      SizedBox(width: 10),
      Text(_feature,style: poppins.copyWith(fontSize: 19))
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
        Container(
          height: 55,
          width: 220,
          child: ElevatedButton.icon(
          onPressed: () async {
            await Premium.initializePlugin();
            await Premium.buyProduct();
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateColor.resolveWith((states) => Colors.teal[800]!),
            shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))
          ),
           icon: Icon(FontAwesomeIcons.solidCreditCard,size: 30),
           label: Padding(
             padding: EdgeInsets.only(left: 12),
             child: Text('Get Access',style: poppins.copyWith(fontSize: 20)),
           )),
        ),
      ],
    );
  }
}