import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdfviewer/preferences/pdf.pref.dart';
import 'package:pdfviewer/ui/showpdf/showpdf.ui.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? file;
  late String name;
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  late PdfViewerController _pdfViewerController;
  List<String> recents = [];

  displayPdf() {
    final a = SfPdfViewer.file(file!,
        controller: _pdfViewerController,
        key: _pdfViewerKey,
        canShowPaginationDialog: true,
        pageLayoutMode: PdfPageLayoutMode.continuous,
        enableDoubleTapZooming: true,
        pageSpacing: 8,
        searchTextHighlightColor: Colors.yellowAccent,
        onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
      AlertDialog(
        title: Text(details.error),
        content: Text(details.description),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
    //SfPdfViewer.file(file!);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ShowPdf(
                  data: a,
                  name: name,
                  pdfViewerKey: _pdfViewerKey,
                  pdfViewerController: _pdfViewerController,
                )));
  }

  getrecents() async {
    List<String> result = await Preferences.getRecent();
    setState(() {
      recents = result;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _pdfViewerController = PdfViewerController();
    getrecents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("PDF Viewer"),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () async {
            final result = await FilePicker.platform
                .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
            if (result != null) {
              final path = result.files.single.path!;
              await Preferences.saveRecent(path);
              final fname = result.files.first.name;
              setState(() {
                file = File(path);
                name = fname;
              });
              displayPdf();
            }
          },
          child: const Icon(Icons.add),
        ),
        body: recents.isEmpty
            ? const Center(child: Text("No Recent File"))
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: recents.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          file = File(recents[index]);
                          name = recents[index].split("/").last;
                        });
                        displayPdf();
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height / 8,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 8,
                                spreadRadius: 6,
                              )
                            ]),
                        child: Text(
                            recents[index].split("/").last.toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                      ),
                    ),
                  );
                  // return ListTile(

                  //     title: Text(recents[index].split("/").last),
                  //     onTap: () {
                  //       setState(() {
                  //         file = File(recents[index]);
                  //         name = recents[index].split("/").last;
                  //       });
                  //       displayPdf();
                  //     });
                }));
  }
}
