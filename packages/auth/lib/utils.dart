String? extractCodeFromString(String s, int codeLength) {
  var regexRule = r"(\d{4})";
  var regex = RegExp(regexRule);
  return regex.stringMatch(s);
}
