extension DynamicParsing on dynamic {
  double toDouble() {
    return double.parse(this);
  }

  //
  String fill(List values) {
    //
    String data = toString();
    for (var value in values) {
      data = data.replaceFirst("%s", value.toString());
    }
    return data;
  }
}