import 'dart:io';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:etno_app/store/section.dart';
import 'package:etno_app/widgets/appbar_navigation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageEnseres extends StatefulWidget {
  const PageEnseres({super.key});

  @override
  State<StatefulWidget> createState() => PageState();
}

class PageState extends State<PageEnseres> {
  final Section section = Section();
  File? _image;
  String name = '';
  String phone = '';
  String enser = '';

  Future getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera, maxHeight: 1080, maxWidth: 1920, imageQuality: 5);
    if (image == null) return;

    final imageTemporary = File(image.path);
    setState(() {
      _image = imageTemporary;
    });
  }

  Future getImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery, maxHeight: 1080, maxWidth: 1920, imageQuality: 5);
    if (image == null) return;
    final imageTemporary = File(image.path);
    setState(() {
      _image = imageTemporary;
    });
  }

  @override
  Widget build(BuildContext pageContext) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true, primaryColor: Colors.white),
      home: Scaffold(
        appBar: appBarCustom(context ,true,AppLocalizations.of(context)!.section_trash, Icons.language, false, () => null, ),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
              children: [
                TextFormField(
                  onChanged: (value) => setState(() => name = value),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      labelText: AppLocalizations.of(pageContext)!.form_name,
                      border: OutlineInputBorder()
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  onChanged: (value) => setState(() => phone = value),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone),
                      labelText: AppLocalizations.of(pageContext)!.form_phone,
                      border: OutlineInputBorder()
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  onChanged: (value) => setState(() => enser = value),
                  maxLines: 8,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.warning),
                      labelText: AppLocalizations.of(pageContext)!.trash,
                      border: OutlineInputBorder()
                  ),
                ),
                if (_image != null)
                    Image.file(_image!, width: 250.0, height: 250.0, fit: BoxFit.cover),
                ElevatedButton(
                    style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.white)),
                    onPressed: () {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      backgroundColor: Colors.white,
                      title: Column(
                        children: [Text(AppLocalizations.of(context)!.ad_photo, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))],
                      ),
                      content: const Text('Adjuntar foto desde'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: getImageFromGallery,
                          child: const Text('GALERÍA'),
                        ),
                        TextButton(
                          onPressed: getImage,
                          child: const Text('CÁMARA'),
                        ),
                      ],
                    ),
                  );
                }, child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.camera_alt), SizedBox(width: 16.0), Text(AppLocalizations.of(context)!.ad_photo)])),
                ElevatedButton(
                    style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.white)),
                    onPressed: () {
                  if(name != '' && phone != '' && enser != '' && _image != null){
                    section.sendEnser('ecomputerapps@gmail.com', 'Hola mi nombre es $name con el teléfono $phone. \n $enser', 'Enser', _image!);
                    Navigator.pop(context);
                  } else {
                    Fluttertoast.showToast(
                        msg: 'Rellene los campos',
                        toastLength: Toast.LENGTH_SHORT,
                        fontSize: 12,
                        textColor: Colors.white,
                        backgroundColor: Colors.red
                    );
                  }
                },
                    child: Text(AppLocalizations.of(context)!.send)
                )
              ],
            )
          ),
        ),
      ),
    )
    );
  }
}