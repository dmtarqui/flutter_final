import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

final imageProvider = StateProvider<XFile?>((ref) => null);

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: OcrHomePage());
  }
}

class OcrHomePage extends ConsumerWidget {
  const OcrHomePage({super.key});

  Future<void> _pickImage(
    BuildContext context,
    WidgetRef ref,
    ImageSource source,
  ) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    ref.read(imageProvider.notifier).state = pickedFile;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageFile = ref.watch(imageProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('SpecsOCR'),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.black87,
      body: Center(
        child:
            imageFile == null
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_outlined,
                      size: 100,
                      color: Colors.deepPurple.shade200,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'No Image Selected',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                )
                : Image.file(
                  // ignore: unnecessary_null_comparison
                  File(imageFile.path),
                  width: 250,
                  height: 250,
                  fit: BoxFit.contain,
                ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed:
                  imageFile != null
                      ? () {
                        print('Image: ${imageFile.toString()}');
                      }
                      : null,
              child: const Text('Scan Text'),
            ),
            ElevatedButton(
              onPressed: () => _pickImage(context, ref, ImageSource.gallery),
              child: const Text('Pick Image'),
            ),
            ElevatedButton(
              onPressed:
                  imageFile != null
                      ? () => ref.read(imageProvider.notifier).state = null
                      : null,
              child: const Text('Clear Image'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () => _pickImage(context, ref, ImageSource.camera),
        child: const Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
