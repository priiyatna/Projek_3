import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final auth = FirebaseAuth.instance;
  bool showPassword = false;
  bool isRememberMeChecked = false;

  @override
  void initState() {
    super.initState();
    _loadRememberMeStatus();
    _loadSavedCredentials();
  }

  void _loadRememberMeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isRememberMeChecked = prefs.getBool('remember_me') ?? false;
    });
  }

  void _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('remember_me') ?? false) {
      String? savedEmail = prefs.getString('email');
      String? savedPassword = prefs.getString('password');
      if (savedEmail != null && savedPassword != null) {
        setState(() {
          emailController.text = savedEmail;
          passwordController.text = savedPassword;
        });
      }
    }
  }

  void _saveRememberMeStatus(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remember_me', value);
  }

  void _saveCredentials(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isRememberMeChecked) {
      await prefs.setString('email', email);
      await prefs.setString('password', password);
    } else {
      await prefs.remove('email');
      await prefs.remove('password');
    }
  }

  void login() async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final uid = userCredential.user!.uid;

      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        final role = userDoc.get('role');

        _saveCredentials(emailController.text.trim(), passwordController.text.trim());

        if (role == 'admin') {
          Navigator.pushReplacementNamed(context, '/admin-home');
        } else {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        throw Exception("Data pengguna tidak ditemukan.");
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Terjadi kesalahan. Silakan coba lagi.';
      if (e.code == 'user-not-found') {
        errorMessage = 'Email tidak ditemukan. Silakan daftar dulu.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Password salah. Coba lagi.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Format email tidak valid.';
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Gagal'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Gagal'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/login.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 100, left: 24, right: 24, bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Masuk',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Masukkan email dan kata sandi untuk masuk ke aplikasi Toko Deryko',
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 40),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          filled: true,
                          fillColor: Colors.blue[50],
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: passwordController,
                        obscureText: !showPassword,
                        decoration: InputDecoration(
                          labelText: 'Kata Sandi',
                          filled: true,
                          fillColor: Colors.blue[50],
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              showPassword ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Checkbox(
                            value: isRememberMeChecked,
                            onChanged: (value) {
                              setState(() {
                                isRememberMeChecked = value ?? false;
                                _saveRememberMeStatus(isRememberMeChecked);
                              });
                            },
                          ),
                          const Text(
                            'Remember Me',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/forgot-password');
                        },
                        child: const Text(
                          'Lupa Kata Sandi Anda?',
                          style: TextStyle(color: Color.fromARGB(255, 76, 174, 255)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Belum punya akun? '),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: const Text(
                              'Daftar Sekarang',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
