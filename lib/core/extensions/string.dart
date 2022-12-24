extension StringHelpers on String {
  double? get doubleValue {
    return double.tryParse(this);
  }

  int? get intValue {
    return int.tryParse(this);
  }
}

extension OptionalStringHelpers on String? {
  bool get isNotNullNorEmpty {
    return this?.isNotEmpty ?? false;
  }
}
