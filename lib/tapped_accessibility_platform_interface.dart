import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'tapped_accessibility_method_channel.dart';

abstract class TappedAccessibilityPlatform extends PlatformInterface {
  /// Constructs a TappedAccessibilityPlatform.
  TappedAccessibilityPlatform() : super(token: _token);

  static final Object _token = Object();

  static TappedAccessibilityPlatform _instance = MethodChannelTappedAccessibility();

  /// The default instance of [TappedAccessibilityPlatform] to use.
  ///
  /// Defaults to [MethodChannelTappedAccessibility].
  static TappedAccessibilityPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TappedAccessibilityPlatform] when
  /// they register themselves.
  static set instance(TappedAccessibilityPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
