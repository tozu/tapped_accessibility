import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'tapped_accessibility_platform_interface.dart';

/// An implementation of [TappedAccessibilityPlatform] that uses method channels.
class MethodChannelTappedAccessibility extends TappedAccessibilityPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('tapped_accessibility');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
