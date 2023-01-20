import 'package:brain_tumor_app/core/extensions/context_extension.dart';
import 'package:brain_tumor_app/core/init/lang/locale_keys.g.dart';
import 'package:brain_tumor_app/product/constants/text_theme.dart';
import 'package:brain_tumor_app/product/generation/colors.gen.dart';
import 'package:brain_tumor_app/view/test_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ScrollController _controller = ScrollController();
  final GlobalKey _key1 = GlobalKey();
  final GlobalKey _key2 = GlobalKey();
  final GlobalKey _key3 = GlobalKey();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _buildFloatingActionButton(),
      body: Container(
        padding: EdgeInsets.fromLTRB(context.mediumValue, context.paddingTop + context.mediumValue, context.mediumValue, 0),
        child: ListView(
          controller: _controller,
          padding: const EdgeInsets.all(0),
          children: [
            // WELCOME
            Text(LocaleKeys.welcome.tr(), style: TEXT_THEME_SEMIBOLD.headline1!.copyWith(fontSize: 36, height: 1.3, color: ColorName.green)),

            // TITLE
            Padding(
              padding: EdgeInsets.only(top: context.mediumValue, bottom: context.highValue),
              child: Text(LocaleKeys.title.tr(), style: TEXT_THEME_REGULAR.headline2!.copyWith(height: 1.5)),
            ),

            // NAVIGATION
            _buildNavigator(),

            // WHAT IS TUMOR?
            _buildWhatIsTumor(),

            // WHAT ARE SYMTOMPS?
            _buildSymtomps(),

            // HOW TO USE
            _buildHowToUse(),

            SizedBox(height: context.highValue),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Beyin Tümörü Nedir?
        GestureDetector(
          onTap: () => animate(_key1),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: Colors.transparent,
            child: Text(LocaleKeys.what_is_brain_tumor.tr(), style: TEXT_THEME_REGULAR.headline3!.copyWith(color: ColorName.green, decoration: TextDecoration.underline)),
          ),
        ),

        // Belirtileri Nelerdir?
        GestureDetector(
          onTap: () => animate(_key2),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: Colors.transparent,
            child: Text(LocaleKeys.what_are_symtomps.tr(), style: TEXT_THEME_REGULAR.headline3!.copyWith(color: ColorName.green, decoration: TextDecoration.underline)),
          ),
        ),

        // Nasıl Kullanılır?
        GestureDetector(
          onTap: () => animate(_key3),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: Colors.transparent,
            child: Text(LocaleKeys.how_to_use.tr(), style: TEXT_THEME_REGULAR.headline3!.copyWith(color: ColorName.green, decoration: TextDecoration.underline)),
          ),
        ),
      ],
    );
  }

  Widget _buildWhatIsTumor() {
    return Column(
      key: _key1,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: context.normalValue, top: context.highValue),
          child: Text(
            LocaleKeys.what_is_brain_tumor.tr(),
            style: TEXT_THEME_SEMIBOLD.headline1!.copyWith(color: ColorName.green),
          ),
        ),
        Text(
          LocaleKeys.tumor_info.tr(),
          style: TEXT_THEME_LIGHT.headline3!.copyWith(height: 1.3),
        ),
      ],
    );
  }

  Widget _buildSymtomps() {
    return Column(
      key: _key2,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: context.normalValue, top: context.highValue),
          child: Text(
            LocaleKeys.what_are_symtomps.tr(),
            style: TEXT_THEME_SEMIBOLD.headline1!.copyWith(color: ColorName.green),
          ),
        ),
        Text(
          LocaleKeys.symptomps.tr(),
          style: TEXT_THEME_LIGHT.headline3!.copyWith(height: 1.3),
        ),
      ],
    );
  }

  Widget _buildHowToUse() {
    return Column(
      key: _key3,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: context.normalValue, top: context.highValue),
          child: Text(
            LocaleKeys.how_to_use.tr(),
            style: TEXT_THEME_SEMIBOLD.headline1!.copyWith(color: ColorName.green),
          ),
        ),
        Text(
          LocaleKeys.how_to_use_info.tr(),
          style: TEXT_THEME_LIGHT.headline3!.copyWith(height: 1.3),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return CupertinoButton(
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TestView())),
      color: ColorName.green,
      borderRadius: BorderRadius.circular(50),
      padding: const EdgeInsets.all(20),
      child: Text(LocaleKeys.test.tr(), style: TEXT_THEME_SEMIBOLD.headline3!.copyWith(color: ColorName.white)),
    );
  }

  void animate(key) {
    _controller.position.ensureVisible(
      key.currentContext!.findRenderObject()!,
      alignment: 0,
      duration: const Duration(milliseconds: 300),
    );
  }
}
