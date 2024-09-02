import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mall_app/Pages/login_page.dart';
import 'package:mall_app/Shared_Preference/auth_service_sharedPreference.dart';
import 'package:mall_app/Shared_Preference/storage_preference_util.dart';
import 'package:mall_app/Utils/global_utils.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() {
    return _UserProfileScreenState();
  }
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  File? file;
  String notificationCount = '';

  ImagePicker image = ImagePicker();
  ImageCropper cropImage = ImageCropper();

  @override
  void initState() {
    super.initState();
    sessionManager.updateLastLoggedInTimeAndLoggedInStatus();
  }

  getImage() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          //height: MediaQuery.of(context).size.height * 0.2,
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose an image from...',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  TextButton.icon(
                    onPressed: () {
                      getImageFromGallery();
                      Navigator.pop(context);
                    },
                    label: const Text('Gallery'),
                    icon: const Icon(
                      Icons.image,
                      size: 40,
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      getImageFromCam();
                    },
                    label: const Text('Camera'),
                    icon: const Icon(
                      Icons.camera,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> getImageFromCam() async {
    var img = await ImagePicker().pickImage(source: ImageSource.camera);

    if (img!.path != null) {
      CroppedFile? imageCropper = await cropImage.cropImage(
        sourcePath: img.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        maxWidth: 512,
        maxHeight: 512,
      );

      if (imageCropper != null) {
      } else {
        globalUtils.showNegativeSnackBar(msg: "File not found");
      }
    }
  }

  getImageFromGallery() async {
    //pick from gallery
    var img = await image.pickImage(source: ImageSource.gallery);

    if (img!.path != null) {
      log('Selected Image Path : ${img.path}');
      // setState(() {
      //   file = File(img.path);
      // });
      CroppedFile? imageCropper = await cropImage.cropImage(
        sourcePath: img.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        maxWidth: 512,
        maxHeight: 512,
      );

      if (imageCropper != null) {
      } else {
        globalUtils.showNegativeSnackBar(msg: "File not found");
      }
    }
  }

  Future<bool> _clickOnLogOut() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text(
              'Do you want to Logout from the App?',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.w700, fontSize: 18),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('No'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      StorageUtil.clearAll();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    child: const Text('Yes'),
                  ),
                ],
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('User Profile'),
        ),
        body: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [],
        ),
      ),
    );
  }
}
