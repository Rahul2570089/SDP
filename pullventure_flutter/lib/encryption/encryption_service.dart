import 'package:encrypt/encrypt.dart';
import 'package:pullventure_flutter/encryption/abstract_encryption.dart';

class EncryptionService implements AbstractEncryption {
  final Encrypter _encrypter;
  final _iv = IV.fromLength(16);

  EncryptionService(this._encrypter);

  @override
  String encrypt(String text) {
    return _encrypter.encrypt(text, iv: _iv).base64;
  }

  @override
  String decrypt(String encryptedText) {
    final encrypted = Encrypted.fromBase64(encryptedText);
    return _encrypter.decrypt(encrypted, iv: _iv);
  }
}