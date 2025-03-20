import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

/// A service class to handle all media-related operations
class MediaService {
  static final MediaService _instance = MediaService._internal();
  final ImagePicker _picker = ImagePicker();

  // Singleton pattern
  factory MediaService() {
    return _instance;
  }

  MediaService._internal();

  /// Take a photo using the device camera
  Future<File?> takePhoto({
    int imageQuality = 80,
    BuildContext? context,
  }) async {
    try {
      // Request camera permission
      var status = await Permission.camera.request();

      if (status.isGranted) {
        final XFile? photo = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: imageQuality,
        );

        if (photo != null) {
          // Copy the file to app's documents directory to ensure it's accessible
          final File savedFile = await _saveFileToAppDirectory(
            File(photo.path),
          );
          print("Photo saved to: ${savedFile.path}");
          return savedFile;
        }
      } else {
        _showPermissionDeniedMessage(context, 'Camera');
      }
      return null;
    } catch (e) {
      print("Error taking photo: $e");
      _showErrorMessage(context, 'Error accessing camera: $e');
      return null;
    }
  }

  /// Pick an image from the gallery
  Future<File?> pickImageFromGallery({
    int imageQuality = 80,
    BuildContext? context,
  }) async {
    try {
      // Request photos permission
      var status = await Permission.photos.request();

      if (status.isGranted) {
        final XFile? image = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: imageQuality,
        );

        if (image != null) {
          // Copy the file to app's documents directory to ensure it's accessible
          final File savedFile = await _saveFileToAppDirectory(
            File(image.path),
          );
          print("Gallery image saved to: ${savedFile.path}");
          return savedFile;
        }
      } else {
        _showPermissionDeniedMessage(context, 'Photos');
      }
      return null;
    } catch (e) {
      print("Error picking image: $e");
      _showErrorMessage(context, 'Error accessing gallery: $e');
      return null;
    }
  }

  /// Pick a video from the gallery
  Future<File?> pickVideoFromGallery({BuildContext? context}) async {
    try {
      // Request photos permission
      var status = await Permission.photos.request();

      if (status.isGranted) {
        final XFile? video = await _picker.pickVideo(
          source: ImageSource.gallery,
        );

        if (video != null) {
          return File(video.path);
        }
      } else {
        _showPermissionDeniedMessage(context, 'Photos');
      }
      return null;
    } catch (e) {
      _showErrorMessage(context, 'Error accessing videos: $e');
      return null;
    }
  }

  /// Record a video using the device camera
  Future<File?> recordVideo({BuildContext? context}) async {
    try {
      // Request camera permission
      var status = await Permission.camera.request();

      if (status.isGranted) {
        final XFile? video = await _picker.pickVideo(
          source: ImageSource.camera,
        );

        if (video != null) {
          return File(video.path);
        }
      } else {
        _showPermissionDeniedMessage(context, 'Camera');
      }
      return null;
    } catch (e) {
      _showErrorMessage(context, 'Error recording video: $e');
      return null;
    }
  }

  /// Pick a file from the device storage
  Future<File?> pickFile({
    List<String>? allowedExtensions,
    BuildContext? context,
  }) async {
    try {
      // Request storage permission
      var status = await Permission.storage.request();

      if (status.isGranted) {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: allowedExtensions != null ? FileType.custom : FileType.any,
          allowedExtensions: allowedExtensions,
        );

        if (result != null && result.files.single.path != null) {
          return File(result.files.single.path!);
        }
      } else {
        _showPermissionDeniedMessage(context, 'Storage');
      }
      return null;
    } catch (e) {
      _showErrorMessage(context, 'Error picking file: $e');
      return null;
    }
  }

  /// Get the current location of the device
  Future<Map<String, dynamic>?> getCurrentLocation({
    BuildContext? context,
  }) async {
    try {
      // Request location permission
      var status = await Permission.location.request();

      if (status.isGranted) {
        // Check if location services are enabled
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          _showErrorMessage(context, 'Location services are disabled');
          return null;
        }

        // Get current position
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        // Get address from coordinates
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          String address =
              '${place.street}, ${place.locality}, ${place.country}';

          return {
            'latitude': position.latitude,
            'longitude': position.longitude,
            'address': address,
          };
        }

        return {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'address': 'Unknown location',
        };
      } else {
        _showPermissionDeniedMessage(context, 'Location');
      }
      return null;
    } catch (e) {
      _showErrorMessage(context, 'Error accessing location: $e');
      return null;
    }
  }

  /// Save a file to a temporary directory
  Future<File?> saveFileToTemp(File file, {String? filename}) async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      final String tempPath = tempDir.path;

      final String fileName = filename ?? path.basename(file.path);
      final String filePath = '$tempPath/$fileName';

      // Copy the file to the temp directory
      return await file.copy(filePath);
    } catch (e) {
      print('Error saving file: $e');
      return null;
    }
  }

  // Helper method to save file to app's documents directory
  Future<File> _saveFileToAppDirectory(File sourceFile) async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String fileName = path.basename(sourceFile.path);
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String newFileName = "${timestamp}_$fileName";
    final String targetPath = path.join(appDocDir.path, newFileName);

    return await sourceFile.copy(targetPath);
  }

  // Helper methods for showing messages
  void _showPermissionDeniedMessage(BuildContext? context, String permission) {
    if (context != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$permission permission denied')));
    }
  }

  void _showErrorMessage(BuildContext? context, String message) {
    if (context != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
    print(message);
  }
}
