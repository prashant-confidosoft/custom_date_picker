import 'package:custom_date_picker/bottom_date_picker.dart';

extension BottomPickerExtension on CSBottomDateTimePicker {
  void assertInitialValues() {
    if (minDateTime != null && maxDateTime != null) {
      assert(minDateTime!.isBefore(maxDateTime!));
    }
    if (maxDateTime != null &&
        initialDateTime == null &&
        DateTime.now().isAfter(maxDateTime!)) {
      initialDateTime = maxDateTime;
    }

    if (minDateTime != null &&
        initialDateTime == null &&
        DateTime.now().isBefore(minDateTime!)) {
      initialDateTime = minDateTime;
    }
  }
}
