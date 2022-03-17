import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future<File> pickImage({String imageSource}) async {
  //TODO: pick image using camera feature.

  File _avatarImageFile;
  XFile _pickedImage;
  if (imageSource == 'Gallery')
    _pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
  else
    _pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
  if (_pickedImage != null) {
    _avatarImageFile = File(_pickedImage.path);
    return _avatarImageFile;
  } else {
    print('Please select an image.....');
    return null;
  }
}
