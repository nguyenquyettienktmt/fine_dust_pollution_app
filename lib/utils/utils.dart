
import 'package:app/themes/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static void showToast(String text) {
    if (Utils.isEmpty(text))
      return;
    Fluttertoast.showToast(msg: text, backgroundColor: accent);
  }
  static bool isEmpty(Object text) {
    if (text is String) return text == null || text.isEmpty;
    if (text is List) return text == null || text.isEmpty;
    return text == null;
  }
}