import 'dart:math';

class CatImageProvider {
  static final List<String> _defaultCatImages = [
    'assets/images/cats/cat_1.jpg',
    'assets/images/cats/cat_2.jpg',
    'assets/images/cats/cat_3.jpg',
    'assets/images/cats/cat_4.jpg',
  ];

  static final Set<String> _usedImages = {};

  static String getRandomCatImage() {
    // If all images used, reset the set
    if (_usedImages.length == _defaultCatImages.length) {
      _usedImages.clear();
    }

    // Get unused images
    final availableImages =
        _defaultCatImages.where((img) => !_usedImages.contains(img)).toList();

    final random = Random();
    final selectedImage =
        availableImages[random.nextInt(availableImages.length)];

    _usedImages.add(selectedImage);
    return selectedImage;
  }
}
