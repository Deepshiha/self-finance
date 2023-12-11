import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ImageCacheManager {
  static final Map<String, Image> _imageCache = {};
  static const int _maxCacheSize = 50; // Maximum number of images to cache

  static Image getCachedImage(String base64String, double? height, double? width) {
    if (_imageCache.containsKey(base64String)) {
      final cachedImage = _imageCache[base64String]!;
      _reorderCache(base64String, cachedImage);
      return cachedImage;
    } else {
      final decodedImage = Image.memory(
        base64Decode(base64String),
        fit: BoxFit.fill,
        height: height ?? 40.sp,
        width: width ?? 40.sp,
      );

      if (_imageCache.length >= _maxCacheSize) {
        _removeLeastUsedImage();
      }

      _imageCache[base64String] = decodedImage;
      return decodedImage;
    }
  }

  static void _reorderCache(String key, Image value) {
    // Move accessed image to the end to simulate LRU behavior
    _imageCache.remove(key);
    _imageCache[key] = value;
  }

  static void _removeLeastUsedImage() {
    // Remove the least recently used image
    _imageCache.remove(_imageCache.keys.first);
  }
}

class Utility {
  static Widget imageFromBase64String(String base64String, {double? height, double? width}) {
    if (base64String.isNotEmpty) {
      final decodedImage = ImageCacheManager.getCachedImage(base64String, height, width);
      return ClipRRect(
        borderRadius: BorderRadius.circular(100.sp),
        child: decodedImage,
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }

  static String numberFormate(int number) {
    return NumberFormat('#,##0').format(number);
  }

  static bool isValidPhoneNumber(String? value) =>
      RegExp(r'(^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$)').hasMatch(value ?? '');
}

double reduceDecimals(double value) {
  return double.parse(value.toStringAsFixed(2));
}

double textToDouble(String value) {
  return double.parse(value);
}

int textToInt(String value) {
  return int.parse(value);
}

DateTime presentDate() {
  return DateTime.now();
}

Future<String> pickImageFromCamera() async {
  final ImagePicker picker = ImagePicker();
  String result = "";

  final XFile? imgFile = await picker.pickImage(
    source: ImageSource.camera,
    imageQuality: 25,
  );

  if (imgFile != null) {
    Uint8List imgBytes = Uint8List.fromList(
      await imgFile.readAsBytes(),
    );
    result = Utility.base64String(imgBytes);
  }

  return result;
}

Future<String> pickImageFromGallery() async {
  final ImagePicker picker = ImagePicker();
  String result = "";

  final XFile? imgFile = await picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 25,
  );

  if (imgFile != null) {
    Uint8List imgBytes = Uint8List.fromList(
      await imgFile.readAsBytes(),
    );
    result = Utility.base64String(imgBytes);
  }

  return result;
}
