import 'package:eliana/credentials.dart';
import 'package:simple_s3/simple_s3.dart';

class StorageService {
  final SimpleS3 _simpleS3 = SimpleS3();

  Future<String?> upload(selectedFile) async {
    String? result;

    if (result == null) {
      try {
        result = await _simpleS3.uploadFile(
          selectedFile!,
          Credentials.s3_bucketName,
          Credentials.s3_poolD,
          AWSRegions.apSouthEast1,
          debugLog: true,
          s3FolderPath: "eliana/recorded_sounds",
          accessControl: S3AccessControl.publicReadWrite,
        );
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }
    return result;
  }
}
