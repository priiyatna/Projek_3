import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/akun_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/cart_provider.dart'; // CartProvider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()), // Provider keranjang
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Toko Deryko',
        initialRoute: '/',
        routes: {
          '/': (context) => const WelcomeScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/forgot-password': (context) => const ForgotPasswordScreen(), 
          '/home': (context) => const HomeScreen(),
          '/akun': (context) => const AccountScreen(),
          // Tambahkan route ke keranjang di sini kalau sudah buat halaman KeranjangScreen nanti
        },
      ),
    );
  }
}
