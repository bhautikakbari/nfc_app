import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nfc_app/view_models/nfc_view_model.dart';
import 'package:nfc_app/views/home_screen.dart';
import 'package:nfc_app/services/nfc_service.dart';
import 'package:nfc_app/repositories/nfc_repository.dart';
import 'package:nfc_app/services/mock_nfc_service.dart';
import 'package:nfc_app/constants/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:nfc_app/controllers/theme_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set this flag to false when you want to use real NFC
  const bool useMockNFC = true;

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  runApp(MyApp(useMockNFC: useMockNFC));
}

class MyApp extends StatelessWidget {
  final bool useMockNFC;

  const MyApp({super.key, this.useMockNFC = false});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeController(),
        ),
        Provider<NFCService>(
          create: (_) => useMockNFC ? MockNFCService() : NFCService(),
        ),
        ProxyProvider<NFCService, NFCRepository>(
          update: (_, nfcService, __) => NFCRepository(nfcService: nfcService),
        ),
        ChangeNotifierProxyProvider<NFCRepository, NFCViewModel>(
          create: (context) => NFCViewModel(
            repository: Provider.of<NFCRepository>(context, listen: false),
          ),
          update: (_, repository, viewModel) =>
          viewModel ?? NFCViewModel(repository: repository),
        ),
      ],
      child: Consumer<ThemeController>(
        builder: (context, themeController, _) {
          return MaterialApp(
            title: 'NFC Scanner',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeController.themeMode,
            home: const HomeScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
