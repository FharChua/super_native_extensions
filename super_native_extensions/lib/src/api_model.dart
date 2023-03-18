import 'dart:typed_data';
import 'dart:ui';

class ImageData {
  ImageData({
    required this.width,
    required this.height,
    required this.bytesPerRow,
    required this.data,
    required this.sourceImage,
    this.devicePixelRatio,
  });

  final int width;
  final int height;
  final int bytesPerRow;
  final Uint8List data;
  final Image sourceImage;
  final double? devicePixelRatio;

  static Future<ImageData> fromImage(
    Image image, {
    double? devicePixelRatio,
  }) async {
    final bytes =
        await image.toByteData(format: ImageByteFormat.rawStraightRgba);
    return ImageData(
        width: image.width,
        height: image.height,
        bytesPerRow: image.width * 4,
        data: bytes!.buffer.asUint8List(),
        sourceImage: image,
        devicePixelRatio: devicePixelRatio);
  }
}

/// Image representation of part of user interface.
class TargettedImage {
  TargettedImage(this.image, this.rect);

  /// Image to be used as avatar image.
  final Image image;

  /// Initial position of avatar image (in global coordinates).
  final Rect rect;
}

class TargettedImageData {
  TargettedImageData({
    required this.imageData,
    required this.rect,
  });

  final ImageData imageData;
  final Rect rect;
}

extension TargettedImageIntoRaw on TargettedImage {
  Future<TargettedImageData> intoRaw(double devicePixelRatio) async {
    return TargettedImageData(
      imageData:
          await ImageData.fromImage(image, devicePixelRatio: devicePixelRatio),
      rect: rect,
    );
  }
}

//
// Drag
//

/// Represents result of a drag & drop operation.
enum DropOperation {
  /// No drop operation performed.
  none,

  /// Drag cancelled by user pressing escape key.
  ///
  /// Supported on: macOS, Windows, Linux.
  userCancelled,

  /// Drag operation is generally supported but forbidden in this instance.
  ///
  /// Supported on: iOS; Maps to [none] on other platforms.
  forbidden,

  /// Supported on: macOS, iOS, Windows, Linux, Android, Web.
  copy,

  /// Supported on: macOS, iOS (only within same app), Windows, Linux.
  move,

  /// Supported on: macOS, Windows, Linux.
  link
}
