import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// A 1x1 transparent PNG so Image.asset decoding succeeds in tests.
final Uint8List transparentPng = Uint8List.fromList(<int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
  0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
  0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
]);

/// Encodes an empty asset manifest using the same codec Flutter uses to read
/// `AssetManifest.bin`. Without this, Image.asset crashes with "Message
/// corrupted" because the test asset handler returns raw PNG bytes.
final ByteData emptyAssetManifest = (StandardMessageCodec()
        .encodeMessage(<Object?, Object?>{})) as ByteData;

/// Installs a mock asset bundle so Image.asset and asset-manifest lookups
/// succeed in widget tests, and gives the binding a large surface so screens
/// with fixed-height content don't trigger overflow assertions. Call from
/// `setUp`.
void mockAssets({double width = 800, double height = 1200}) {
  final binding = TestWidgetsFlutterBinding.instance;
  binding.window.physicalSizeTestValue = Size(width, height);
  binding.window.devicePixelRatioTestValue = 1.0;

  binding.defaultBinaryMessenger
      .setMockMessageHandler('flutter/assets', (message) async {
    final key = String.fromCharCodes(message!.buffer.asUint8List());
    if (key.contains('AssetManifest')) {
      return ByteData.sublistView(emptyAssetManifest);
    }
    return ByteData.sublistView(transparentPng);
  });
}
