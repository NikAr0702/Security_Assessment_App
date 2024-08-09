import 'package:get/get.dart';

class TextAnalyzerService extends GetxService {
  // Function to check null safety and balance of brackets in the extracted text
  Map<String, dynamic> analyzeText(String text) {
    if (text.isEmpty) {
      return {'status': false, 'message': 'Text is empty'};
    }

    // Check for balanced brackets
    bool isBalanced = _checkBracketsBalance(text);

    return {
      'status': isBalanced,
      'message': isBalanced
          ? 'Text is null safe and brackets are balanced'
          : 'Brackets are not balanced in the text',
    };
  }

  bool _checkBracketsBalance(String text) {
    final brackets = {
      '(': ')',
      '{': '}',
      '[': ']',
    };

    final stack = <String>[];

    for (int i = 0; i < text.length; i++) {
      final char = text[i];

      if (brackets.keys.contains(char)) {
        stack.add(char);
      } else if (brackets.values.contains(char)) {
        if (stack.isEmpty || brackets[stack.removeLast()] != char) {
          return false;
        }
      }
    }

    return stack.isEmpty;
  }
}
