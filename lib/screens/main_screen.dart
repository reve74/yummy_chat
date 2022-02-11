import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:yummy_chat/config/palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yummy_chat/screens/chat_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({Key? key}) : super(key: key);

  @override
  _LoginSignupScreenState createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  bool? isSignupScreen = true;
  bool showSpinner = false;
  final _formKey = GlobalKey<FormState>();
  String userName = '';
  String userEmail = '';
  String userPassword = '';

  final _authentication = FirebaseAuth.instance; // 사용자 등록과 인증에 사용할 인스턴스 생성

  void _tryValidation() {
    // 밸리데이션 확인을 위한 메소드
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: GestureDetector(
          // 바깥 영역 선택 시 키보드 해제
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [
              //배경
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: Container(
                  height: 300,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('image/red.jpg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.only(top: 90, left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Welcome',
                            style: const TextStyle(
                              letterSpacing: 1.0,
                              fontSize: 25,
                              color: Colors.white,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    isSignupScreen! ? ' to Yummy chat!' : ' back',
                                style: const TextStyle(
                                  letterSpacing: 1.0,
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          isSignupScreen!
                              ? 'Signup to continuue'
                              : 'Signin to continue',
                          style: const TextStyle(
                            letterSpacing: 1.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //텍스트 폼 필드
              AnimatedPositioned(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeIn,
                top: 180,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                  padding: EdgeInsets.only(top: 20.0),
                  height: isSignupScreen! ? 280.0 : 250.0,
                  width: MediaQuery.of(context).size.width - 40,
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSignupScreen = false;
                                });
                              },
                              child: Column(
                                children: [
                                  Text(
                                    'LOGIN',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: !isSignupScreen!
                                          ? Palette.activeColor
                                          : Palette.textColor1,
                                    ),
                                  ),
                                  if (!isSignupScreen!)
                                    Container(
                                      margin: EdgeInsets.only(top: 3),
                                      height: 2,
                                      width: 55,
                                      color: Colors.orange,
                                    ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSignupScreen = true;
                                });
                              },
                              child: Column(
                                children: [
                                  Text(
                                    'SIGNUP',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: isSignupScreen!
                                          ? Palette.activeColor
                                          : Palette.textColor1,
                                    ),
                                  ),
                                  if (isSignupScreen!)
                                    Container(
                                      margin: EdgeInsets.only(top: 3),
                                      height: 2,
                                      width: 55,
                                      color: Colors.orange,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (isSignupScreen!)
                          Container(
                            padding: EdgeInsets.only(top: 20),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: TextFormField(
                                      key: ValueKey(1),
                                      validator: (value) {
                                        if (value!.isEmpty || value.length < 4) {
                                          return 'Please enter at least  4 characters';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        userName = value!;
                                      },
                                      onChanged: (value) {
                                        userName = value;
                                      },
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.account_circle,
                                          color: Palette.iconColor,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Palette.textColor1,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(35.0),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Palette.textColor1,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(35.0),
                                          ),
                                        ),
                                        hintText: 'User name',
                                        hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Palette.textColor1,
                                        ),
                                        contentPadding:
                                            EdgeInsets.all(10), // 텍스트 필드 자주 사용
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      key: ValueKey(2),
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            !value.contains('@')) {
                                          return 'Please enter a valid email address';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        userEmail = value!;
                                      },
                                      onChanged: (value) {
                                        userEmail = value;
                                      },
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.email_outlined,
                                          color: Palette.iconColor,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Palette.textColor1,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(35.0),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Palette.textColor1,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(35.0),
                                          ),
                                        ),
                                        hintText: 'Email',
                                        hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Palette.textColor1,
                                        ),
                                        contentPadding:
                                            EdgeInsets.all(10), // 텍스트 필드 자주 사용
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: TextFormField(
                                      obscureText: true,
                                      key: ValueKey(3),
                                      validator: (value) {
                                        if (value!.isEmpty || value.length < 6) {
                                          return 'Password must be at lesat 7 characters long.';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        userPassword = value!;
                                      },
                                      onChanged: (value) {
                                        userPassword = value;
                                      },
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.password_sharp,
                                          color: Palette.iconColor,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Palette.textColor1,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(35.0),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Palette.textColor1,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(35.0),
                                          ),
                                        ),
                                        hintText: 'Password',
                                        hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Palette.textColor1,
                                        ),
                                        contentPadding:
                                            EdgeInsets.all(10), // 텍스트 필드 자주 사용
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (!isSignupScreen!)
                          Container(
                            padding: EdgeInsets.only(top: 20),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      key: ValueKey(4),
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            !value.contains('@')) {
                                          return 'Please enter a valid email address';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        userEmail = value!;
                                      },
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.email_outlined,
                                          color: Palette.iconColor,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Palette.textColor1,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(35.0),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Palette.textColor1,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(35.0),
                                          ),
                                        ),
                                        hintText: 'Email',
                                        hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Palette.textColor1,
                                        ),
                                        contentPadding:
                                            EdgeInsets.all(10), // 텍스트 필드 자주 사용
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: TextFormField(
                                      obscureText: true,
                                      key: ValueKey(5),
                                      validator: (value) {
                                        if (value!.isEmpty || value.length < 6) {
                                          return 'Password must be at lesat 7 characters long.';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        userPassword = value!;
                                      },
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.password_sharp,
                                          color: Palette.iconColor,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Palette.textColor1,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(35.0),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Palette.textColor1,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(35.0),
                                          ),
                                        ),
                                        hintText: 'Password',
                                        hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Palette.textColor1,
                                        ),
                                        contentPadding:
                                            EdgeInsets.all(10), // 텍스트 필드 자주 사용
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              //전송 버튼
              AnimatedPositioned(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeIn,
                top: isSignupScreen! ? 420 : 380,
                right: 0,
                left: 0,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        if (isSignupScreen!) {
                          _tryValidation();
                          try {
                            final newUser = await _authentication
                                .createUserWithEmailAndPassword(
                              email: userEmail,
                              password: userPassword,
                            );

                            await FirebaseFirestore.instance.collection('user').doc(newUser.user!.uid)
                            .set({
                              'userName' : userName,
                              'email' : userEmail,
                            });

                            if (newUser.user != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(),
                                ),
                              );
                              setState(() {
                                showSpinner = false;
                              });
                            }
                          } catch (e) {
                            print(e);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Please check your email and password'),
                                backgroundColor: Colors.blue,
                              ),
                            );
                          }
                        }
                        if (!isSignupScreen!) {
                          setState(() {
                            showSpinner = true;
                          });
                          _tryValidation();
                          try{
                            final newUser =
                            await _authentication.signInWithEmailAndPassword(
                                email: userEmail, password: userPassword);
                            if (newUser.user != null) {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => ChatScreen(),
                              //   ),
                              // );
                            }
                            setState(() {
                              showSpinner = false;
                            });
                          }catch(e) {
                            print(e);
                          }
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.orange,
                              Colors.red,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 1,
                              spreadRadius: 1,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // 구글 로그인 버튼
              AnimatedPositioned(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeIn,
                top: isSignupScreen!
                    ? MediaQuery.of(context).size.height - 100
                    : MediaQuery.of(context).size.height - 120,
                right: 0,
                left: 0,
                child: Column(
                  children: [
                    Text(isSignupScreen! ? 'or Signup with' : 'or Signin with'),
                    SizedBox(
                      height: 10,
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        minimumSize: Size(155, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: Palette.googleColor,
                      ),
                      icon: Icon(Icons.add),
                      label: Text('Google'),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
