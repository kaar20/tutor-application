import '/controller/auth.dart';
import 'package:flutter/material.dart';

class SingIn extends StatefulWidget {
  final Function toggleView;
  SingIn({required this.toggleView});

  @override
  _SingInState createState() => _SingInState();
}

class _SingInState extends State<SingIn> {
  final AuthService _auth = AuthService();

  // form validation key check
  final _formKey = GlobalKey<FormState>();

  // text field state
  String email = '';
  String password = '';
  String error = '';
  late int userT;
  String usertype = '';
  Color pl = Colors.black;
  Color gn = const Color(0xff22BF8D);
  Color pn = const Color(0xffFF337E);
  Color yl = const Color(0xffF0C742);

  final TextStyle _label = const TextStyle(
    color: Colors.black,
    fontSize: 14,
  );

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double header = height * 0.2;
    final double body = height * 0.74;
    final double foot = height * 0.06;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Container(
        //color: yl,
        child: Column(
          children: <Widget>[
            // header
            Container(
              color: yl,
              height: header,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(40),
                  ),
                ),
                height: 100,
                child: const Center(
                  child: Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: body,
              //color: Colors.yellowAccent,
              decoration: BoxDecoration(
                color: yl,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  // bottomLeft: Radius.circular(40),
                  // bottomRight: Radius.circular(40),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 80.0, horizontal: 50.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      //email
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        //style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          labelStyle: _label,
                          labelText: 'Email',
                          fillColor: Colors.white,
                        ),
                        validator: (val) => val!.isEmpty ? 'Enter email!' : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                      //password
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusColor: Colors.black,
                          labelStyle: _label,
                          labelText: 'Password',
                          //hintText: 'Email',
                          fillColor: Colors.white,
                        ),
                        validator: (val) =>
                            val!.length < 6 ? 'Password too short' : null,
                        obscureText: true,
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),

                      //sign in button
                      const SizedBox(
                        height: 100.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.only(
                          //     topRight: Radius.circular(20.0),
                          //     topLeft: Radius.circular(20.0),
                          //     bottomRight: Radius.circular(20.0),
                          //     bottomLeft: Radius.circular(20.0),
                          //   ),
                          // ),
                          // color: Colors.black,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              dynamic result = await _auth
                                  .signInWithEmailAndPassword(email, password);
                              if (result == null) {
                                setState(() => error = 'Wrong credential');
                              }
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.only(top: 18, bottom: 18),
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),

                      //SizedBox(height: 5.0),
                      Text(
                        error,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ],
                  )),
            ),
            Container(
              color: yl,
              alignment: Alignment.centerRight,
              height: foot,
              width: double.infinity,
              child: TextButton(
                //color: yl,
                onPressed: () {
                  widget.toggleView();
                },
                child: Text(
                  'REGISTER',
                  style: TextStyle(
                    color: pl,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
