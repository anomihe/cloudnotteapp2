// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:advance_pdf_viewer_fork/advance_pdf_viewer_fork.dart';
// import 'package:http/http.dart' as http;

// /// A reusable PDF Viewer widget that supports multiple PDF sources and navigation.
// class ReusablePdfViewer extends StatefulWidget {
//   final PdfSourceType sourceType;
//   final String? networkUrl;
//   final String? assetPath;
//   final String? filePath;
//  // final Uint8List? memoryData;

//   const ReusablePdfViewer({
//     Key? key,
//     required this.sourceType,
//     this.networkUrl,
//     this.assetPath,
//     this.filePath,
//    // this.memoryData,
//   }) : super(key: key);

//   @override
//   State<ReusablePdfViewer> createState() => _ReusablePdfViewerState();
// }

// enum PdfSourceType { network, asset, file, /*memory*/ }

// class _ReusablePdfViewerState extends State<ReusablePdfViewer> {
//   PDFDocument? _document;
//   PageController? _viewerController;
//   bool _isLoading = true;
//   String? _errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     _loadPdf();
//   }

//   Future<void> _loadPdf() async {
//     try {
//       PDFDocument document;
//       switch (widget.sourceType) {
//         case PdfSourceType.network:
//           if (widget.networkUrl == null) throw 'Network URL is null';
//           document = await PDFDocument.fromURL(widget.networkUrl!);
//           break;
//         case PdfSourceType.asset:
//           if (widget.assetPath == null) throw 'Asset path is null';
//           document = await PDFDocument.fromAsset(widget.assetPath!);
//           break;
//         case PdfSourceType.file:
//           if (widget.filePath == null) throw 'File path is null';
//           document = await PDFDocument.fromFile(File(widget.filePath!));
//           break;
//         // case PdfSourceType.memory:
//         //   if (widget.memoryData == null) throw 'Memory data is null';
//         //   document = await PDFDocument.(widget.memoryData!);
//         //   break;
//       }

//       setState(() {
//         _document = document;
//         _viewerController = PageController();
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {

//         print('pdfview error $e');
//         _errorMessage = 'Failed to load PDF: $e';
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _viewerController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('PDF Viewer'),
//         actions: _buildNavigationActions(),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _errorMessage != null
//               ? Center(child: Text(_errorMessage!))
//               : PDFViewer(
//                   document: _document!,
//                   controller: _viewerController,
//                   scrollDirection: Axis.vertical,
//                   showNavigation: false,
//                   showPicker: false,
//                   showIndicator: true,
//                   enableSwipeNavigation: true,
//                 ),
//       floatingActionButton: (!_isLoading && _viewerController != null)
//           ? FloatingActionButton(
//               onPressed: _showJumpToPageDialog,
//               child: const Icon(Icons.format_list_numbered),
//             )
//           : null,
//     );
//   }

//   List<Widget> _buildNavigationActions() {
//     if (_isLoading || _viewerController == null) return [];

//     return [
//       IconButton(
//         icon: const Icon(Icons.first_page),
//         onPressed: () => _viewerController!.jumpTo( 1.0),
//       ),
//       IconButton(
//         icon: const Icon(Icons.navigate_before),
//         onPressed: () => _viewerController!.previousPage(
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeInOut,
//         ),
//       ),
//       IconButton(
//         icon: const Icon(Icons.navigate_next),
//         onPressed: () => _viewerController!.nextPage(   duration: const Duration(milliseconds: 300),
//           curve: Curves.easeInOut,),
//       ),
//       const SizedBox(width: 8),
//     ];
//   }

//   void _showJumpToPageDialog() {
//     final TextEditingController pageController = TextEditingController();
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Jump to Page'),
//         content: TextField(
//           controller: pageController,
//           keyboardType: TextInputType.number,
//           decoration: const InputDecoration(
//             labelText: 'Page Number',
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//     TextButton(
//   onPressed: () {
//     final page = int.tryParse(pageController.text.trim());
//     if (page != null && page > 0) {
//       Navigator.pop(context);
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         _viewerController?.jumpToPage(page);
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Invalid page number')),
//       );
//     }
//   },
//   child: const Text('Go'),
// ),

//         ],
//       ),
//     ).then((_) {
//       pageController.dispose();
//     });
//   }
// }
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:http/http.dart' as http;

/// A reusable PDF Viewer widget that supports multiple PDF sources and navigation.
class ReusablePdfViewer extends StatefulWidget {
  final PdfSourceType sourceType;
  final String? networkUrl;
  final String? assetPath;
  final String? filePath;
  final bool automaticallyImplyLeading;
  final bool showTitle;
  final bool showNavigationActions;
  // final Uint8List? memoryData;

  const ReusablePdfViewer({
    Key? key,
    required this.sourceType,
    this.networkUrl,
    this.assetPath,
    this.filePath,
    this.automaticallyImplyLeading = true,
    this.showTitle = true,
    this.showNavigationActions = true,
    // this.memoryData,
  }) : super(key: key);

  @override
  State<ReusablePdfViewer> createState() => _ReusablePdfViewerState();
}

enum PdfSourceType { network, asset, file /*memory*/ }

class _ReusablePdfViewerState extends State<ReusablePdfViewer> {
  PDFDocument? _document;
  PageController? _viewerController;
  bool _isLoading = true;
  String? _errorMessage;
  bool _mounted = true;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    if (!mounted) return;

    try {
      PDFDocument? document;
      switch (widget.sourceType) {
        case PdfSourceType.network:
          if (widget.networkUrl == null) throw 'Network URL is null';
          document = await PDFDocument.fromURL(widget.networkUrl!);
          break;
        case PdfSourceType.asset:
          if (widget.assetPath == null) throw 'Asset path is null';
          document = await PDFDocument.fromAsset(widget.assetPath!);
          break;
        case PdfSourceType.file:
          if (widget.filePath == null) throw 'File path is null';
          document = await PDFDocument.fromFile(File(widget.filePath!));
          break;
        // case PdfSourceType.memory:
        //   if (widget.memoryData == null) throw 'Memory data is null';
        //   document = await PDFDocument.fromData(widget.memoryData!);
        //   break;
      }

      if (!mounted) return;

      setState(() {
        _document = document;
        _viewerController = PageController();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        print('pdfview error $e');
        _errorMessage = 'Failed to load PDF: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _mounted = false;
    _viewerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: widget.automaticallyImplyLeading,
        title: widget.showTitle
            ? const Text('PDF Viewer')
            : Row(
                children: _buildNavigationActions(),
              ),
        actions:
            widget.showNavigationActions ? _buildNavigationActions() : null,
      ),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }

    if (_document == null) {
      return const Center(child: Text('PDF document not available'));
    }

    return PDFViewer(
      document: _document!,
      controller: _viewerController,
      scrollDirection: Axis.vertical,
      showNavigation: false,
      showPicker: false,
      showIndicator: true,
      enableSwipeNavigation: true,
    );
  }

  Widget? _buildFloatingActionButton() {
    if (_isLoading || _viewerController == null || _document == null) {
      return null;
    }

    return FloatingActionButton(
      onPressed: _showJumpToPageDialog,
      child: const Icon(Icons.format_list_numbered),
    );
  }

  List<Widget> _buildNavigationActions() {
    if (_isLoading || _viewerController == null || _document == null) {
      return [];
    }

    return [
      IconButton(
        icon: const Icon(Icons.first_page),
        onPressed: () {
          _viewerController?.jumpToPage(0); // First page is 0, not 1
        },
      ),
      IconButton(
        icon: const Icon(Icons.navigate_before),
        onPressed: () {
          if ((_viewerController?.page ?? 0) > 0) {
            _viewerController?.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        },
      ),
      IconButton(
        icon: const Icon(Icons.navigate_next),
        onPressed: () {
          final currentPage = _viewerController?.page ?? 0;
          if (_document != null && currentPage < (_document!.count! - 1)) {
            _viewerController?.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        },
      ),
      const SizedBox(width: 8),
    ];
  }

  void _showJumpToPageDialog() {
    if (!mounted) return;

    // Use a separate method to build and show the dialog
    // This creates a clean scope for the controller
    _buildAndShowDialog(context);
  }

  void _buildAndShowDialog(BuildContext parentContext) {
    // Create the controller in this method's scope
    final pageController = TextEditingController();

    // Use a stateful builder to properly manage dialog state
    showDialog(
      context: parentContext,
      builder: (dialogContext) => StatefulBuilder(
        builder: (builderContext, setDialogState) {
          return AlertDialog(
            title: const Text('Jump to Page'),
            content: TextField(
              controller: pageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Page Number',
              ),
              // Handle submission directly in the TextField
              onSubmitted: (value) => _handlePageNavigation(
                  dialogContext, pageController.text, pageController),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // First set controller text to empty to avoid further access
                  pageController.text = '';
                  Navigator.of(dialogContext).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => _handlePageNavigation(
                    dialogContext, pageController.text, pageController),
                child: const Text('Go'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _handlePageNavigation(BuildContext dialogContext, String pageText,
      TextEditingController controller) {
    // Parse page number
    final page = int.tryParse(pageText.trim());

    if (page != null && page > 0 && page <= (_document?.count ?? 0)) {
      // Clear text before navigation to prevent access after pop
      controller.text = '';

      // Dismiss dialog
      Navigator.of(dialogContext).pop();

      // Schedule navigation for next frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _viewerController != null) {
          _viewerController!.jumpToPage(page - 1);
        }
      });
    } else {
      // Show error message without dismissing dialog
      ScaffoldMessenger.of(dialogContext).showSnackBar(
        const SnackBar(content: Text('Invalid page number')),
      );
    }
  }
}
