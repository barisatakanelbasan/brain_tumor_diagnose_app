import 'package:brain_tumor_app/core/extensions/context_extension.dart';
import 'package:brain_tumor_app/view/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../product/generation/assets.gen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeView()), (route) => route.isCurrent));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _buildLottie(context),
      ),
    );
  }

  Center _buildLottie(BuildContext context) => Center(child: LottieBuilder.asset(Assets.lotties.brain, height: context.width * .4));
}
