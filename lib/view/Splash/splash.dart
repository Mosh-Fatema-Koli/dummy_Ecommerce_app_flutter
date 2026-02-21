import 'package:flutter/cupertino.dart';
import '../Home/page/home_page.dart';


class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  void _navigate(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (_) => const HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Run after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigate(context);
    });

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
      child: const SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),

            Icon(
              CupertinoIcons.sparkles,
              size: 90,
              color: CupertinoColors.white,
            ),

            SizedBox(height: 20),

            Text(
              "Your App",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.white,
              ),
            ),

            SizedBox(height: 8),

            Text(
              "Smart. Simple. Fast.",
              style: TextStyle(
                fontSize: 16,
                color: CupertinoColors.white,
              ),
            ),

            Spacer(),

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
