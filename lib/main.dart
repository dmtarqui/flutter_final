import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'data/db_helper.dart';
import 'application/ocr_controller.dart';

final imageProvider = StateProvider<XFile?>((ref) => null);
final ocrTextProvider = StateProvider<String>((ref) => '');

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: OcrHomePage());
  }
}

class OcrHomePage extends ConsumerWidget {
  const OcrHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ocrState = ref.watch(ocrControllerProvider);
    final ocrController = ref.read(ocrControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'OCR Scanner',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Colors.black87,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ocrState.image == null
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image_outlined, size: 100, color: Colors.white),
                    const SizedBox(height: 10),
                    const Text(
                      'No Image Selected',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                )
                : Image.file(
                  File(ocrState.image!.path),
                  width: 300,
                  height: 300,
                  fit: BoxFit.contain,
                ),
            const SizedBox(height: 20),
            if (ocrState.ocrText.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  ocrState.ocrText,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  maxLines: 6, // Limit to 5 lines
                  overflow: TextOverflow.ellipsis, // Show "..." if too long
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed:
                  ocrState.image != null
                      ? () async {
                        await ocrController.scanText();
                        final scannedText = ocrState.ocrText;
                        if (scannedText.isNotEmpty) {
                          await DbHelper().insertHistory(scannedText);
                        }
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text('Scanned Text'),
                                content: SingleChildScrollView(
                                  child: Text(
                                    scannedText.isNotEmpty
                                        ? scannedText
                                        : 'No text found.',
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(),
                                    child: const Text('Close'),
                                  ),
                                ],
                              ),
                        );
                      }
                      : null,
              child: const Icon(Icons.document_scanner, color: Colors.black),
            ),
            ElevatedButton(
              onPressed: () => ocrController.pickImage(ImageSource.gallery),
              child: const Icon(Icons.image_search, color: Colors.black),
            ),
            ElevatedButton(
              onPressed:
                  ocrState.image != null
                      ? () {
                        ocrController.clear();
                      }
                      : null,
              child: const Icon(Icons.clear, color: Colors.black),
            ),
            ElevatedButton(
              onPressed: () async {
                final history = await DbHelper().getHistory();
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('History'),
                        content: SizedBox(
                          width: double.maxFinite,
                          child:
                              history.isEmpty
                                  ? const Text('No history yet.')
                                  : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: history.length,
                                    itemBuilder: (context, index) {
                                      final item = history[index];
                                      return ListTile(
                                        title: Text(item['text'] ?? ''),
                                        subtitle: Text(item['createdAt'] ?? ''),
                                      );
                                    },
                                  ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                );
              },
              child: const Icon(Icons.history, color: Colors.black),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60.0),
        child: SizedBox(
          width: 60,
          height: 60,
          child: FloatingActionButton(
            shape: const CircleBorder(),
            backgroundColor: Colors.white,
            hoverColor: Colors.blueAccent,
            onPressed: () => ocrController.pickImage(ImageSource.camera),
            child: const Icon(Icons.camera_alt, color: Colors.black),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
