import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mobile/app_model.dart';
import 'package:mobile/schemas.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'package:mobile/api.dart';


class CertificatesView extends StatefulWidget {
  static void open(BuildContext context, String autoToken) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return CertificatesView(autoToken);
      },
    );
  }

  final String autoToken;
  const CertificatesView(this.autoToken, {super.key});

  @override
  State<CertificatesView> createState() => _CertificatesViewState();
}

class _CertificatesViewState extends State<CertificatesView> {
  CertificatesSchema certificatesData = CertificatesSchema([]);

  @override
  void initState() {
    super.initState();

    refreshCertificates();
  }

  void refreshCertificates(){
    API
        .guestPost('/profile/get-certificates', params: {
      "auth_token": widget.autoToken
    },)
        .then((Response res) {
      if (res.hasError) {
        return;
      }

      CertificatesSchema newData = CertificatesSchema.fromJson(res.data);

      setState(() {
        certificatesData = newData;
      });
    });
  }

  void uploadCertificateOnPressed() {
    FilePicker.platform.pickFiles().then((FilePickerResult? result) {
      if (result?.files.single.path != null) {
        String filePath = result!.files.single.path!;

        API
            .guestPost('/profile/upload-certificate', params: {
          "auth_token": widget.autoToken, "certificate_id": certificatesData
        },
            filePath: filePath)
            .then((Response res) {
          if (res.hasError) {
            return;
          }

          refreshCertificates();
        });
      }
    });
  }

  void _deleteCertificateOnPressed(String certificateId){
    API
        .guestPost('/profile/delete-certificate', params: {
    "auth_token": widget.autoToken,"certificate_id": certificateId
    },)
        .then((Response res) {
      if (res.hasError) {
        return;
      }

      refreshCertificates();
    });
  }

  void downloadCertificateOnPressed(FileSchema certificate){
    String certificateUrl = API.getURL('profile/get-certificate', widget.autoToken, params: {
      'certificate_id': certificate.fileId, 'auth_token': widget.autoToken
    });

    openFile(url: certificateUrl, fileName: certificate.name);
  }

  Future openFile({required String url, String? fileName}) async {
    final file = await downloadFile(url,fileName!);
    if(file == null)return;

    OpenFile.open(file.path);
  }

  Future<File?> downloadFile(String url, String name) async {
    final appStorage = await getApplicationDocumentsDirectory();

    final file = File('${appStorage.path}/$name');

    try{
      final response = await dio.Dio().get(
        url,
        options: dio.Options(
          responseType:dio.ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: 0,
        ),
      );

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();

      return file;
    }catch(e){
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Certificates'),
              ElevatedButton(
                onPressed: uploadCertificateOnPressed,
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.black, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6), // Padding
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_box), // Icon
                    SizedBox(width: 4), // Spacing between icon and text
                    Text(
                      'Add',
                      style: TextStyle(fontSize: 16), // Text style
                    ),
                  ],
                ),
              ),
            ],
          ),
          content: Container(
            width: 300, // Set your desired width
            height: 300, // Set your desired height
            child: Scrollbar(
                trackVisibility: true,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: certificatesData.certificates.map((certificate) {
                      return ListTile(
                        title: Text(certificate.name),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed:(){downloadCertificateOnPressed(certificate);},
                              icon: const Icon(Icons.download),
                            ),
                            if(certificatesData.certificates.length != 1)
                              IconButton(
                                onPressed: (){_deleteCertificateOnPressed(certificate.fileId);},
                                icon: const Icon(Icons.delete),
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