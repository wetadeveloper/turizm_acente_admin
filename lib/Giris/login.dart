import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ozel_sirket_admin/Navbars/home_page.dart';

class LoginSayfasi extends StatefulWidget {
  const LoginSayfasi({super.key});

  @override
  LoginSayfasiState createState() => LoginSayfasiState();
}

class LoginSayfasiState extends State<LoginSayfasi> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    String defaultFontFamily = 'Roboto-Light.ttf';
    double defaultFontSize = 14;
    double defaultIconSize = 17;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 35, bottom: 30),
          width: double.infinity,
          height: double.infinity,
          color: Colors.white70,
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 230,
                      height: 100,
                      alignment: Alignment.center,
                      child: const Text(
                        "Şirket İsmi",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: _emailController,
                      showCursor: true,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        filled: true,
                        prefixIcon: Icon(
                          Icons.mail_outline,
                          color: const Color(0xFF666666),
                          size: defaultIconSize,
                        ),
                        fillColor: const Color(0xFFF2F3F5),
                        hintStyle: TextStyle(
                            color: const Color(0xFF666666), fontFamily: defaultFontFamily, fontSize: defaultFontSize),
                        hintText: "E-Mail",
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: _passwordController,
                      obscureText: _isObscure,
                      showCursor: true,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        filled: true,
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: const Color(0xFF666666),
                          size: defaultIconSize,
                        ),
                        //Göz Tuşu
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                          child: Icon(
                            _isObscure ? Icons.visibility_off : Icons.visibility,
                            color: const Color(0xFF666666),
                            size: defaultIconSize,
                          ),
                        ),

                        fillColor: const Color(0xFFF2F3F5),
                        hintStyle: TextStyle(
                          color: const Color(0xFF666666),
                          fontFamily: defaultFontFamily,
                          fontSize: defaultFontSize,
                        ),
                        hintText: "Şifre",
                      ),
                    ),
                    const SizedBox(height: 15),
                    SignInButtonWidget(
                      onPressed: () async {
                        try {
                          final email = _emailController.text;
                          final password = _passwordController.text;

                          final userCredential =
                              await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

                          if (userCredential.user != null) {
                            // Giriş başarılı, kullanıcıyı bir sonraki sayfaya yönlendirin
                            if (context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(),
                                ),
                              );
                            }
                          } else {
                            // Kullanıcı yoksa, hata mesajı gösterin
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Kullanıcı bulunamadı.'),
                                ),
                              );
                            }
                          }
                        } catch (e) {
                          // Hata mesajı gösterin
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Giriş yapılırken bir hata oluştu.'),
                              ),
                            );
                          }
                        }
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
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

class SignInButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const SignInButtonWidget({super.key, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey,
            ),
            BoxShadow(
              color: Colors.grey,
            ),
          ],
          gradient: LinearGradient(
              colors: [Colors.black, Colors.grey],
              begin: FractionalOffset(0.2, 0.2),
              end: FractionalOffset(1.0, 1.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: MaterialButton(
          highlightColor: Colors.transparent,
          splashColor: Colors.grey,
          onPressed: onPressed,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
            child: Text(
              "Giriş Yap",
              style: TextStyle(color: Colors.white, fontSize: 25.0, fontFamily: "WorkSansBold"),
            ),
          ),
        ));
  }
}
