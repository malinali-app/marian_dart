import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

const path =
    'C:/Users/PierreGancel/Desktop/marian_dart/target/release/marian_candle.dll';

typedef TranslateTextC = Void Function(
    Pointer<Utf8> input, Pointer<Utf8> output, IntPtr maxLength);
typedef TranslateTextDart = void Function(
    Pointer<Utf8> input, Pointer<Utf8> output, int maxLength);

void main() {
  // Load the shared library
  final dylib =
      DynamicLibrary.open(path); // Adjust the path and extension as needed

  // Look up the function
  final TranslateTextDart translateText = dylib
      .lookup<NativeFunction<TranslateTextC>>('translate_text')
      .asFunction();

  // Allocate memory for input and output strings
  final input = 'Bonjour Pierre, as-tu réussi?'.toNativeUtf8();
  final output = calloc<Uint8>(256).cast<Utf8>(); // Adjust the size as needed

  // Call the function
  translateText(input, output, 256);

  // Convert the output C string to Dart string
  final translatedText = output.toDartString();

  // print('Translated text: $translatedText');

  // Free the allocated memory
  calloc.free(input);
  calloc.free(output);
}
