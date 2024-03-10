import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:pharmcare/records.dart';

class PDF extends StatefulWidget {
  const PDF({super.key, required this.pdf_url, required this.img_url});

  final pdf_url;
  final img_url;

  @override
  State<StatefulWidget> createState() {
    return _PDFState();
  }
}

class _PDFState extends State<PDF> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Center(
        child: widget.img_url == ''
            ? SfPdfViewer.network(
                widget.pdf_url,
                key: _pdfViewerKey,
              )
            : Image.network(
                widget.img_url,
                height: 500,
                width: 500,
                fit: BoxFit.cover,
              ),
      );

  }
}
