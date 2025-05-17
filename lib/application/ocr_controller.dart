import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../data/db_helper.dart';

class OcrState {
  final XFile? image;
  final String ocrText;

  OcrState({this.image, this.ocrText = ''});

  OcrState copyWith({XFile? image, String? ocrText}) {
    return OcrState(
      image: image ?? this.image,
      ocrText: ocrText ?? this.ocrText,
    );
  }
}

class OcrController extends StateNotifier<OcrState> {
  OcrController() : super(OcrState());

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    state = state.copyWith(image: pickedFile, ocrText: '');
  }

  Future<void> scanText() async {
    if (state.image == null) return;
    final inputImage = InputImage.fromFilePath(state.image!.path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final recognizedText = await textRecognizer.processImage(inputImage);
    state = state.copyWith(ocrText: recognizedText.text);
    await textRecognizer.close();
    if (recognizedText.text.isNotEmpty) {
      await DbHelper().insertHistory(recognizedText.text);
    }
  }

  void clear() {
    state = OcrState();
  }
}

final ocrControllerProvider = StateNotifierProvider<OcrController, OcrState>(
  (ref) => OcrController(),
);
