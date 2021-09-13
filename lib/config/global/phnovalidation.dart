Future<String> phonenovalidation(phone) async {
  String phoneNo;
  phoneNo = phone;
  if (phoneNo.indexOf("7") == 0 && phoneNo.length == 9) {
    phoneNo = '+959' + phoneNo;
  } else if (phoneNo.indexOf("9") == 0 && phoneNo.length == 9) {
    phoneNo = '+959' + phoneNo;
  } else if (phoneNo.indexOf("+") != 0 &&
      phoneNo.indexOf("7") != 0 &&
      phoneNo.indexOf("9") != 0 &&
      (phoneNo.length == 8 || phoneNo.length == 9 || phoneNo.length == 7)) {
    phoneNo = '+959' + phoneNo;
  } else if (phoneNo.indexOf("09") == 0 &&
      (phoneNo.length == 10 || phoneNo.length == 11 || phoneNo.length == 9)) {
    phoneNo = '+959' + phoneNo.substring(2);
  } else if (phoneNo.indexOf("959") == 0 &&
      (phoneNo.length == 11 || phoneNo.length == 12 || phoneNo.length == 10)) {
    phoneNo = '+959' + phoneNo.substring(3);
  }
  print("My phone no" + phoneNo);
  return phoneNo;
}