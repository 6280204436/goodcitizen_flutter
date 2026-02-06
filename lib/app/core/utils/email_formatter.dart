import '../../export.dart';

class EmailTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final oldText = oldValue.text;
    final newText = newValue.text.toLowerCase(); // Convert input to lowercase

    // Allow only valid email characters (lowercase letters, numbers, and email symbols)
    final filteredText = newText.replaceAll(RegExp(r'[^a-z0-9@._-]'), '');

    // Calculate the difference in length between the new and filtered text
    final diff = newText.length - filteredText.length;

    // Adjust the selection position
    final baseOffset = newValue.selection.baseOffset - diff;
    final extentOffset = newValue.selection.extentOffset - diff;

    return TextEditingValue(
      text: filteredText,
      selection: TextSelection(
        baseOffset: baseOffset.clamp(0, filteredText.length),
        extentOffset: extentOffset.clamp(0, filteredText.length),
      ),
    );
  }
}

class NameTextInputFormatter extends TextInputFormatter {
  final RegExp _nameRegExp = RegExp(r"[a-zA-Z\s'-]");

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final filteredText = newValue.text.characters
        .where((char) => _nameRegExp.hasMatch(char))
        .join();

    return TextEditingValue(
      text: filteredText,
      selection: newValue.selection,
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class CapitalizeFirstLetterTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    String capitalizedText = newValue.text[0].toUpperCase() + newValue.text.substring(1);

    return newValue.copyWith(
      text: capitalizedText,
      selection: newValue.selection,
    );
  }
}

class NoInitialDotInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,
      TextEditingValue newValue) {
    // Prevent entering a space as the initial character
    if (newValue.text.startsWith('.')) {
      return oldValue;
    }
    return newValue;
  }
}