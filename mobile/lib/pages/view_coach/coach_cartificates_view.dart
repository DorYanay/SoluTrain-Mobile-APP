import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'package:mobile/schemas.dart';
import 'package:mobile/api.dart';

class CoachCertificatesView extends StatefulWidget {
  static void open(BuildContext context, String autoToken, List<FileSchema> certificates) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return CoachCertificatesView(autoToken, certificates);
      },
    );
  }

  final String autoToken;
  final List<FileSchema> certificates;

  const CoachCertificatesView(this.autoToken, this.certificates, {super.key});

  @override
  State<CoachCertificatesView> createState() => _CoachCertificatesView();
}

class _CoachCertificatesView extends State<CoachCertificatesView> {
  @override
  void initState() {
    super.initState();
  }

  void downloadCertificateOnPressed(FileSchema certificate) {
    String certificateUrl = API.getURL(
        'profile/get-certificate', widget.autoToken, params: {
      'certificate_id': certificate.fileId,
      'auth_token': widget.autoToken
    });

    openFile(url: certificateUrl, fileName: certificate.name);
  }

  Future openFile({required String url, String? fileName}) async {
    final file = await downloadFile(url, fileName!);
    if (file == null) return;

    OpenFile.open(file.path);
  }

  Future<File?> downloadFile(String url, String name) async {
    final appStorage = await getApplicationDocumentsDirectory();

    final file = File('${appStorage.path}/$name');

    try {
      final response = await dio.Dio().get(
        url,
        options: dio.Options(
          responseType: dio.ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: 0,
        ),
      );

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();

      return file;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Certificates'),
      content: SizedBox(
        width: 300, // Set your desired width
        height: 300, // Set your desired height
        child: Scrollbar(
            trackVisibility: true,
            thumbVisibility: true,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: widget.certificates.map((certificate) {
                  return ListTile(
                    title: Text(certificate.name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            downloadCertificateOnPressed(certificate);
                          },
                          icon: const Icon(Icons.download),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            )),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            // Add functionality to close dialog
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
