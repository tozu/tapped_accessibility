import 'package:flutter_test/flutter_test.dart';
import 'package:tapped_accessibility/tapped_accessibility.dart';
import 'package:tapped_accessibility/tapped_accessibility_platform_interface.dart';
import 'package:tapped_accessibility/tapped_accessibility_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockTappedAccessibilityPlatform
    with MockPlatformInterfaceMixin
    implements TappedAccessibilityPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final TappedAccessibilityPlatform initialPlatform = TappedAccessibilityPlatform.instance;

  test('$MethodChannelTappedAccessibility is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelTappedAccessibility>());
  });

  test('getPlatformVersion', () async {
    TappedAccessibility tappedAccessibilityPlugin = TappedAccessibility();
    MockTappedAccessibilityPlatform fakePlatform = MockTappedAccessibilityPlatform();
    TappedAccessibilityPlatform.instance = fakePlatform;

    expect(await tappedAccessibilityPlugin.getPlatformVersion(), '42');
  });
}
