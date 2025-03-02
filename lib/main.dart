import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:account/provider/scienceCompetitionProvider.dart';
import 'package:account/homeScreen.dart'; // import หน้า Home

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ScienceCompetitionProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // เอาแถบ Debug ออก
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(), // ใช้ SplashScreen ก่อนเข้า Home
    );
  }
}

// ✅ Splash Screen แบบไม่มีการโหลดค้าง
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      // เมื่อโหลดเสร็จแล้วให้ไปหน้า Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage(title: 'การแข่งขันวิทยาศาสตร์')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/flutter_logo.png', width: 100), // แสดงโลโก้
            const SizedBox(height: 20),
            const CircularProgressIndicator(), // แสดง Loading
          ],
        ),
      ),
    );
  }
}
