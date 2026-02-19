import 'package:flutter/cupertino.dart';
import '../Home/home_page.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Navigate to HomePage after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (_) =>  HomePage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF4F46E5),
            Color(0xFF6366F1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Spacer(),

            // Logo
            Icon(
              CupertinoIcons.sparkles,
              size: 90,
              color: CupertinoColors.white,
            ),

            SizedBox(height: 20),

            // App Name
            Text(
              "Your App",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.white,
              ),
            ),

            SizedBox(height: 8),

            // Subtitle
            Text(
              "Smart. Simple. Fast.",
              style: TextStyle(
                fontSize: 16,
                color: CupertinoColors.white,
              ),
            ),

            Spacer(),

            // Loader
            CupertinoActivityIndicator(
              radius: 14,
              color: CupertinoColors.white,
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
