import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart'; // ✅ Tambahan

import 'firebase_options.dart';
import 'screens/user/cart_provider.dart';
import 'screens/auth/welcome_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/user/home_screen.dart';
import 'screens/user/akun_screen.dart';
import 'screens/user/kontak_kami_screen.dart';
import 'screens/admin/admin_home_screen.dart';
import 'screens/admin/manage_orders_screen.dart'; // ✅ Tambahan

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('id_ID', null); // ✅ Inisialisasi lokal Indonesia
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
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
          '/kontak': (context) => const KontakKamiScreen(),
          '/admin-home': (context) => const AdminHomeScreen(),
          '/admin-orders': (context) => const ManageOrdersScreen(), // ✅ Route pesanan admin
        },
      ),
    );
  }
}
