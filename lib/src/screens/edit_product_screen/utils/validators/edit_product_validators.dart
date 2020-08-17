class EditProductValidators {
  static String titleValidator(String value) {
    if (value.isEmpty) {
      return 'please, provide a title';
    }

    return null;
  }

  static String priceValidator(String value) {
    if (value.isEmpty) {
      return 'Please enter a price';
    }

    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }

    if (double.parse(value) <= 0) {
      return 'Please enter a number greater than zero ';
    }

    return null;
  }

  static String imageURLValidator(String value) {
    if (value.isEmpty) {
      return 'Please enter an image URL';
    }

    if (!value.endsWith('.jpg') && !value.endsWith('.png')) {
      return 'Please enter a valid URL';
    }

    return null;
  }

  static String descriptionValidator(String value) {
    if (value.isEmpty) {
      return 'Please enter a description';
    }

    if (value.length < 10) {
      return 'Should be at least 10 characters long';
    }

    return null;
  }
}
