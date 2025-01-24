
import 'tapped_accessibility_platform_interface.dart';

class TappedAccessibility {
  Future<String?> getPlatformVersion() {
    return TappedAccessibilityPlatform.instance.getPlatformVersion();
  }
}
