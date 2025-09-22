import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ozel_sirket_admin/Features/Auth/view/splash_view.dart';
import 'package:ozel_sirket_admin/Features/Auth/viewmodel/auth_login_view_model.dart';
import 'package:ozel_sirket_admin/Features/Auth/viewmodel/auth_register_view_model.dart';
import 'package:ozel_sirket_admin/Features/Finans/viewModel/finans_viewmodel.dart';
import 'package:ozel_sirket_admin/Features/Kampanyalar/viewModel/kampanya_ekle_view_model.dart';
import 'package:ozel_sirket_admin/Features/Otel/viewmodel/otel_view_model.dart';
import 'package:ozel_sirket_admin/Features/Turlarlar/viewModel/tur_guncelleme_view_model.dart';
import 'package:ozel_sirket_admin/Features/Turlarlar/viewModel/turlar_view_model.dart';
import 'package:ozel_sirket_admin/firebase_options.dart';
import 'package:provider/provider.dart';
import 'Features/Reklamlar/viewModel/reklamlar_view_model.dart';
import 'Features/Reklamlar/viewModel/reklam_ekle_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr_TR', null);

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MyApp());
  } catch (e) {
    if (kDebugMode) {
      print("Firebase initialization failed: $e");
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthLoginViewModel()),
        ChangeNotifierProvider(create: (_) => AuthRegisterViewModel()),
        ChangeNotifierProvider(create: (_) => TurGuncelleViewModel()),
        ChangeNotifierProvider(create: (_) => ReklamlarViewModel()),
        ChangeNotifierProvider(create: (_) => ReklamEkleViewModel()),
        ChangeNotifierProvider(create: (_) => KampanyaEkleViewModel()),
        ChangeNotifierProvider(create: (_) => TurlarViewModel()),
        ChangeNotifierProvider(create: (_) => OdaViewModel()),
        ChangeNotifierProvider(create: (_) => FinansEkleViewModel()),
        ChangeNotifierProvider(create: (_) => FinansGuncelleViewModel()),
        ChangeNotifierProvider(create: (_) => FinansDetayViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Roboto', hintColor: Colors.white),
        home: const SplashView(),
      ),
    );
  }
}
