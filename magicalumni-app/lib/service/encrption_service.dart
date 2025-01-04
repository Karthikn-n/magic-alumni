import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EncryptionService {
  static final  EncryptionService _encryptService = EncryptionService._internal();
  static final dotenv = DotEnv();
  static final encryptKey = Key.fromUtf8(dotenv.get("API_KEY"));
  static final encryptIV = IV.fromUtf8(dotenv.get("IV_KEY"));
  static final encrypter = Encrypter(AES(encryptKey, mode: AESMode.cbc, padding: "PKCS7"));

  String encryptData(Map<String, dynamic> input)
    => encrypter.encrypt(json.encode(input), iv: encryptIV).base64;

  dynamic decryptData(String encryptedData) =>
     json.decode(encrypter.decrypt(Encrypted.fromBase64(encryptedData), iv: encryptIV));

  // this will ensure only one instance is created across the app if We call the Method using
  // EncryptionService() for non-static methods
  // A normal constructor (EncrptionService()) would create a new instance each time it’s called. 
  // The factory constructor overrides this behavior and ensures reuse of the same instance.
  factory EncryptionService(){
    return _encryptService;
  }

  Future<void> init() async {
    await dotenv.load();
  }

  EncryptionService._internal();
}