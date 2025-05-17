class OcrResult {
  final String text;
  OcrResult({required this.text});
}

abstract class ScanTextUseCase {
  Future<OcrResult> call(String imagePath);
}
