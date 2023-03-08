import 'package:flutter/material.dart';
import 'package:pdfviewer/ui/home/home.ui.dart';
//import 'package:pdfviewer/ui/home/home.ui.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ShowPdf extends StatefulWidget {
  const ShowPdf(
      {Key? key,
      required this.data,
      required this.name,
      required this.pdfViewerKey,
      required this.pdfViewerController})
      : super(key: key);
  // ignore: prefer_typing_uninitialized_variables
  final data;
  final String name;
  final GlobalKey<SfPdfViewerState> pdfViewerKey;
  final PdfViewerController pdfViewerController;
  @override
  _ShowPdfState createState() => _ShowPdfState();
}

class _ShowPdfState extends State<ShowPdf> {
  TextEditingController _search = TextEditingController();
  PdfTextSearchResult _searchResult = PdfTextSearchResult();
  String search = "";
  bool check = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                  (route) => false);
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
        automaticallyImplyLeading: false,
        title: Text(widget.name),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.bookmark,
              color: Colors.white,
            ),
            onPressed: () {
              widget.pdfViewerKey.currentState?.openBookmarkView();
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () async {
              showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        contentPadding: const EdgeInsets.all(15),
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextFormField(
                              controller: _search,
                              decoration: InputDecoration(
                                  hintText: "Search",
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide:
                                          const BorderSide(color: Colors.blue)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: const BorderSide(
                                          color: Colors.blue))),
                            ),
                          ),
                          TextButton(
                              onPressed: () async {
                                search = _search.text;
                                setState(() {
                                  check = true;
                                });
                                Navigator.pop(context);
                                _searchResult =
                                    await widget.pdfViewerController.searchText(
                                  search.toLowerCase(),
                                );
                              },
                              child: const Text("Search"))
                        ]);
                  });
              setState(() {});
            },
          ),
          Visibility(
            visible: check,
            child: IconButton(
              icon: const Icon(
                Icons.clear,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _searchResult.clear();
                  check = false;
                });
              },
            ),
          ),
          Visibility(
            visible: check,
            child: IconButton(
              icon: const Icon(
                Icons.keyboard_arrow_up,
                color: Colors.white,
              ),
              onPressed: () {
                _searchResult.previousInstance();
              },
            ),
          ),
          Visibility(
            visible: check,
            child: IconButton(
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
              ),
              onPressed: () {
                _searchResult.nextInstance();
              },
            ),
          )
        ],
      ),
      body: widget.data,
    );
  }
}
