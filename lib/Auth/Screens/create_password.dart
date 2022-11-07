import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:mobi_pay/config.dart';

class CreatePassword extends StatefulWidget {
  const CreatePassword({Key? key}) : super(key: key);

  @override
  State<CreatePassword> createState() => _RegisterState();
}

class _RegisterState extends State<CreatePassword> {
  final _confirmPassController = TextEditingController();
  final _passwordController = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();
  late String _password;
  double _strength = 0;

  RegExp numReg =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  RegExp letterReg =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  String _displayText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFf8fafc),
        body: Padding(
          padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
          child: SingleChildScrollView(
            child: Form(
              key: formGlobalKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: const HeroIcon(
                          HeroIcons.arrowNarrowLeft,
                          color: Color(primary_color),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Create a new Password',
                        style: TextStyle(
                            fontSize: heading_title,
                            fontWeight: FontWeight.bold,
                            color: Color(primary_text)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: spacing_medium,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    onChanged: (value) => _checkPassword(value),
                    obscureText: true,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w700),
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Color(regular_text)),
                      hintText: 'Enter your Password',
                      suffixIcon: HeroIcon(
                        HeroIcons.eyeOff,
                        solid: true,
                        size: 5,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(input_border),
                            width: input_border_width),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(primary_color),
                            width: input_border_width),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: spacing_extra_small,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _displayText.isNotEmpty
                          ? Container(
                              width: 200,
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                child: LinearProgressIndicator(
                                  value: _strength,
                                  backgroundColor: Colors.grey[300],
                                  color: _strength <= 1 / 4
                                      ? const Color(week)
                                      : _strength == 2 / 4
                                          ? Color(good)
                                          : _strength == 3 / 4
                                              ? const Color(strong)
                                              : const Color(very_strong),
                                  minHeight: 15,
                                ),
                              ),
                            )
                          : Container(),
                      Text(
                        _displayText,
                        style: TextStyle(
                            color: _strength <= 1 / 4
                                ? const Color(week)
                                : _strength == 2 / 4
                                    ? const Color(good)
                                    : _strength == 3 / 4
                                        ? const Color(strong)
                                        : Color(very_strong),
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: spacing_small,
                  ),
                  TextFormField(
                    controller: _confirmPassController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'plese enter Confirm Password';
                      } else if (value != _passwordController.text) {
                        return 'Password not match';
                      }
                      return null;
                    },
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w700),
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      labelStyle: TextStyle(color: Color(regular_text)),
                      hintText: 'Confirm your Password',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(input_border),
                            width: input_border_width),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(primary_color),
                            width: input_border_width),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  SizedBox(
                    height: button_height,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: const Color(primary_color),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35),
                          )),
                      onPressed: _strength < 1 / 2
                          ? null
                          : () {
                              if (formGlobalKey.currentState!.validate()) {
                               
                              }
                            },
                      child: const Text(
                        "Next",
                        style: TextStyle(fontSize: button_text),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void _checkPassword(String value) {
    _password = value.trim();

    if (_password.isEmpty) {
      setState(() {
        _strength = 0;
        _displayText = 'Enter password';
      });
    } else if (_password.length < 6) {
      setState(() {
        _strength = 1 / 4;
        _displayText = 'So Weak';
      });
    } else if (_password.length < 8) {
      setState(() {
        _strength = 2 / 4;
        _displayText = 'Pretty Good';
      });
    } else {
      if (!numReg.hasMatch(_password)) {
        setState(() {
         
          _strength = 3 / 4;
          _displayText = 'Strong';
        });
      } else {
        
        setState(() {
          _strength = 1;
          _displayText = 'Very Strong!';
        });
      }
    }
  }
}
