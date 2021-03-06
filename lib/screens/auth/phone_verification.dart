import 'dart:convert';
import 'package:bondo/config/size_config.dart';
import 'package:bondo/services/phone_verification_service.dart';
import 'package:bondo/utils/color.dart';
import 'package:bondo/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PhoneVerification extends StatefulWidget {
  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  String fullName, email, password, number, confirmationCode;
  bool obsure = true;
  Country _selected;
  bool confirmationBody = false;

  static bool isLoading = true;

  static String verificationCode;

  final confrimController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final routes =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    print(routes['phone']);
    PhoneVerificationService.verify(
        number: routes['phone'],
        autoRetrievalTimeout: (String verId) {
          verificationCode = verId;
          print("AutoRetrival Timeout: $verificationCode");
        },
        phoneCodeSent: (String verId, [int forceCodeResend]) {
          verificationCode = verId;
          print("CodeSent : $verificationCode");
        },
        phoneVerificationCompleted: (AuthCredential credential) {
          print(
              'CRED : ${credential.toString()} : ${credential.toString().runtimeType}');
          print(json.encode(credential));
          print(json.encode(credential)[0]);
          print("Success ${credential}");
          Map<String, dynamic> map = credential as Map<String, dynamic>;
          print("MAP : $map");
          print("map c : ${map['jsonObject']['zzb']}");
          if (map['jsonObject']['zzb'] != null) {
            print('${map['jsonObject']['zzb']}');
            setState(() {
              confirmationCode = map['zzb'].toString();
              confrimController.text = confirmationCode;
            });
          }
        },
        phoneVerificationFailed: (AuthException exception) {
          print("${exception.message}");
        });
  }

  send() {
    final routes =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    print(routes['phone']);
    PhoneVerificationService.verify(
        number: routes['phone'],
        autoRetrievalTimeout: (String verId) {
          verificationCode = verId;
          print("AutoRetrival Timeout: $verificationCode");
        },
        phoneCodeSent: (String verId, [int forceCodeResend]) {
          verificationCode = verId;
          print("CodeSent : $verificationCode");
        },
        phoneVerificationCompleted: (AuthCredential credential) {
          print('CRED : ${credential} : AS ST : ${credential.toString()}');
          final js = credential.toString();
          print("js : $js");
          try {
            print(credential.runtimeType);
          } catch (e) {
            print("exception $e");
          }
          print("Success ${credential}");
        },
        phoneVerificationFailed: (AuthException exception) {
          print("${exception.message}");
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 45,
                ),
                _logoView(),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 10,
                ),
                _backCard()
              ]),
        ),
      ),
    );
  }

  Widget _backCard() {
    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.blockSizeVertical * 55,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          color: Colors.white),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: _confirmationCard(),
      ),
    );
  }

  Widget _confirmationCard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: SizeConfig.blockSizeVertical * 2),
        Text(
          "Enter Confirmation Code",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
        ),
        SizedBox(height: SizeConfig.blockSizeVertical * 2),
        Padding(
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: Text('Enter the Code was send to you \nmobile number',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey))),
        Container(
          width: SizeConfig.screenWidth,
          child: PinCodeTextField(
            controller: confrimController,
            length: 6,
            obsecureText: false,
            animationType: AnimationType.fade,
            animationDuration: Duration(milliseconds: 300),
            onChanged: (value) {
              setState(() {
                confirmationCode = value;
              });
            },
          ),
        ),

        SizedBox(
          height: SizeConfig.blockSizeVertical * 5,
        ),
        GestureDetector(
          onTap: () {
            send();
          },
          child: Container(
            height: SizeConfig.blockSizeVertical * 6,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: green),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Continue',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: whitecolor),
                ),
                Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.navigate_next,
                      color: whitecolor,
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _logoView() {
    return Column(
      children: [
        new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                if (confirmationBody == false) {
                  AppRoutes.pop(context);
                }
                if (confirmationBody == true) {
                  setState(() {
                    confirmationBody = false;
                  });
                }
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: whitecolor,
              ),
            )
          ],
        ),
        Image.asset('assets/images/logo.png', scale: 4),
        SizedBox(
          height: 10,
        ),
        Text(
          'Bondo',
          style: TextStyle(
            fontSize: 40,
            color: Colors.white,
          ),
        ),
        Text(
          'World’s local Mic',
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
