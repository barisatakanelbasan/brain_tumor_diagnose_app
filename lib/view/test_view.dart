import 'package:brain_tumor_app/core/extensions/context_extension.dart';
import 'package:brain_tumor_app/core/init/lang/locale_keys.g.dart';
import 'package:brain_tumor_app/product/constants/text_theme.dart';
import 'package:brain_tumor_app/product/generation/assets.gen.dart';
import 'package:brain_tumor_app/product/generation/colors.gen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:lottie/lottie.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

class TestView extends StatefulWidget {
  const TestView({super.key});

  @override
  State<TestView> createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  List? results;
  double confidence = 0.0;

  Future<void> loadModel() async {
    await Tflite.loadModel(
      model: 'assets/tf/tflite_model.tflite',
      labels: 'assets/tf/labels.txt',
    );
  }

  Future<void> applyModelOnImage() async {
    if (_image != null) {
      results = await Tflite.runModelOnImage(
        path: _image!.path,
        numResults: 10,
        threshold: 0.05,
        imageMean: 127.5,
        imageStd: 127.5,
      );
      setState(() {
        confidence = double.parse((results![0]['confidence'] * 100.0).toString().substring(0, 2));
      });
    }
  }

  @override
  void initState() {
    loadModel();
    super.initState();
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _buildGalleryFab(),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(context.mediumValue, context.paddingTop + context.mediumValue, context.mediumValue, 40),
            child: Column(
              children: [
                // LOTTIE
                _buildLottie(context),

                // INFO
                _buildInfoText(context),

                // FRAME
                _buildPhotoFrame(context),

                // BUTTON
                _buildTestButton(context),

                // RESULT
                _buildResult(),
              ],
            ),
          ),
          _buildBackButton(),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.only(right: 10, bottom: 10),
        margin: EdgeInsets.only(top: context.paddingTop + context.normalValue, left: context.mediumValue),
        child: Icon(
          CupertinoIcons.chevron_back,
          color: ColorName.green,
          size: context.mediumValue * 1.2,
        ),
      ),
    );
  }

  Center _buildLottie(BuildContext context) => Center(child: LottieBuilder.asset(Assets.lotties.brain, height: context.width * .4));

  Container _buildInfoText(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: context.mediumValue),
        child: Text(LocaleKeys.upload_photo.tr(), style: TEXT_THEME_SEMIBOLD.headline1!.copyWith(color: ColorName.green, height: 1.3), textAlign: TextAlign.center));
  }

  Container _buildPhotoFrame(BuildContext context) {
    return Container(
      height: context.width * .6,
      width: context.width * .6,
      decoration: BoxDecoration(
        border: Border.all(color: ColorName.green, width: 2),
        borderRadius: BorderRadius.circular(12),
        image: _image != null ? DecorationImage(image: AssetImage(_image!.path), fit: BoxFit.cover) : null,
      ),
    );
  }

  Padding _buildTestButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: context.mediumValue),
      child: CupertinoButton(
        onPressed: () async {
          await applyModelOnImage();
        },
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        borderRadius: BorderRadius.circular(12),
        color: ColorName.green,
        child: Text(LocaleKeys.test.tr(), style: TEXT_THEME_SEMIBOLD.headline1!.copyWith(color: ColorName.white)),
      ),
    );
  }

  Widget _buildResult() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: context.mediumValue, right: context.mediumValue, left: context.mediumValue),
        child: Visibility(
          visible: results != null,
          child: Text('chance_to_have_tumor'.tr(args: ['$confidence']), style: TEXT_THEME_SEMIBOLD.headline2!.copyWith(color: ColorName.green, height: 1.3), textAlign: TextAlign.center),
        ),
      ),
    );
  }

  Widget _buildGalleryFab() {
    return CupertinoButton(
      onPressed: () async {
        await _handleImage();
      },
      color: ColorName.green,
      padding: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(50),
      child: const Icon(CupertinoIcons.photo_on_rectangle),
    );
  }

  _handleImage() async {
    try {
      _image = await _picker.pickImage(source: ImageSource.gallery);
      await _cropImage();
    } catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> _cropImage() async {
    if (_image != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _image!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(toolbarTitle: 'Cropper', toolbarColor: Colors.deepOrange, toolbarWidgetColor: Colors.white, initAspectRatio: CropAspectRatioPreset.original, lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
            presentStyle: CropperPresentStyle.dialog,
            boundary: const CroppieBoundary(
              width: 520,
              height: 520,
            ),
            viewPort: const CroppieViewPort(width: 480, height: 480, type: 'circle'),
            enableExif: true,
            enableZoom: true,
            showZoomer: true,
          ),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          _image = XFile(croppedFile.path);
        });
      }
    }
  }
}
