import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/components/condition_widget.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/services/Validator.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'chat_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_id';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool showSpinner = false;
  String email = '';
  String password = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Validator(),
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      height: 200.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                    Validator().validateEmail(email);
                  },
                  decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  textAlign: TextAlign.center,
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                    Validator().validatePassword(password);
                  },
                  decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password'),
                ),
                SizedBox(
                  height: 24.0,
                ),
                Consumer<Validator>(
                  builder: (context2, validator, Widget? child) {
                    return RoundedButton(
                      color: Colors.blueAccent,
                      text: 'Register',
                      onPressed: validator.isEverythingValid
                          ? () async {
                              setState(() => showSpinner = true);
                              try {
                                final UserCredential user = await _auth.createUserWithEmailAndPassword(
                                    email: email, password: password);
                                user.user!.sendEmailVerification();
                                print('ohayo2');
                                if (user != null) Navigator.pushNamed(context, ChatScreen.id);
                              } catch (e) {
                                print('ohayoooo :    ' + e.toString());
                              }
                              setState(() => showSpinner = false);
                            }
                          : null,
                    );
                  },
                ),
                Consumer<Validator>(
                  builder: (context2, validator, Widget? child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email must:'),
                        ConditionWidget('be in valid format', validator.hasValidEmail),
                        SizedBox(height: 12),
                        Text('Password must:'),
                        ConditionWidget('Be a minimum of 8 characters.', validator.hasEnoughLength),
                        ConditionWidget(
                            'Include at least one lowercase letter (a-z).', validator.hasOneSmallChar),
                        ConditionWidget(
                            'Include at least one uppercase letter (A-Z).', validator.hasOneCapitalChar),
                        ConditionWidget('Include at least one number (0-9).', validator.hasOneNumber),
                        ConditionWidget('Include at least one symbol.', validator.hasOneSymbol),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
