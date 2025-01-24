import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tapped_accessibility/tapped_accessibility_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelTappedAccessibility platform = MethodChannelTappedAccessibility();
  const MethodChannel channel = MethodChannel('tapped_accessibility');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
