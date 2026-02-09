import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'ticket_widget.dart' show TicketWidget;
import 'package:flutter/material.dart';

class TicketModel extends FlutterFlowModel<TicketWidget> {
  ///  Local state fields for this page.

  String company = ' ';

  String address = ' ';

  String time = ' ';

  String date = ' ';

  bool accepted = false;

  String name = ' ';

  String ticketnumber = ' ';

  int integerImagesSelected = 0;

  List<FFUploadedFile> imagesSelected = [];
  void addToImagesSelected(FFUploadedFile item) => imagesSelected.add(item);
  void removeFromImagesSelected(FFUploadedFile item) =>
      imagesSelected.remove(item);
  void removeAtIndexFromImagesSelected(int index) =>
      imagesSelected.removeAt(index);
  void insertAtIndexInImagesSelected(int index, FFUploadedFile item) =>
      imagesSelected.insert(index, item);
  void updateImagesSelectedAtIndex(
          int index, Function(FFUploadedFile) updateFn) =>
      imagesSelected[index] = updateFn(imagesSelected[index]);

  List<String> listBase64 = [];
  void addToListBase64(String item) => listBase64.add(item);
  void removeFromListBase64(String item) => listBase64.remove(item);
  void removeAtIndexFromListBase64(int index) => listBase64.removeAt(index);
  void insertAtIndexInListBase64(int index, String item) =>
      listBase64.insert(index, item);
  void updateListBase64AtIndex(int index, Function(String) updateFn) =>
      listBase64[index] = updateFn(listBase64[index]);

  bool isTicketParked = false;

  bool isLoaded = false;

  int imageSelectedIndex = 0;

  /// List of Images After Adding to  Gallery
  List<String> imagesArray = [];
  void addToImagesArray(String item) => imagesArray.add(item);
  void removeFromImagesArray(String item) => imagesArray.remove(item);
  void removeAtIndexFromImagesArray(int index) => imagesArray.removeAt(index);
  void insertAtIndexInImagesArray(int index, String item) =>
      imagesArray.insert(index, item);
  void updateImagesArrayAtIndex(int index, Function(String) updateFn) =>
      imagesArray[index] = updateFn(imagesArray[index]);

  /// image array loaded from Tcket
  List<String> savedImagesArray = [];
  void addToSavedImagesArray(String item) => savedImagesArray.add(item);
  void removeFromSavedImagesArray(String item) => savedImagesArray.remove(item);
  void removeAtIndexFromSavedImagesArray(int index) =>
      savedImagesArray.removeAt(index);
  void insertAtIndexInSavedImagesArray(int index, String item) =>
      savedImagesArray.insert(index, item);
  void updateSavedImagesArrayAtIndex(int index, Function(String) updateFn) =>
      savedImagesArray[index] = updateFn(savedImagesArray[index]);

  /// Array of Images of Ticket Arrival converted to uploadedFile type
  ///
  List<FFUploadedFile> savedImagesArrayFiles = [];
  void addToSavedImagesArrayFiles(FFUploadedFile item) =>
      savedImagesArrayFiles.add(item);
  void removeFromSavedImagesArrayFiles(FFUploadedFile item) =>
      savedImagesArrayFiles.remove(item);
  void removeAtIndexFromSavedImagesArrayFiles(int index) =>
      savedImagesArrayFiles.removeAt(index);
  void insertAtIndexInSavedImagesArrayFiles(int index, FFUploadedFile item) =>
      savedImagesArrayFiles.insert(index, item);
  void updateSavedImagesArrayFilesAtIndex(
          int index, Function(FFUploadedFile) updateFn) =>
      savedImagesArrayFiles[index] = updateFn(savedImagesArrayFiles[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - sendjsontourl] action in Ticket widget.
  String? searchResultsTicket;
  // Stores action output result for [Custom Action - sendjsontourl] action in Ticket widget.
  String? ticketSiteId;
  // Stores action output result for [Custom Action - sendjsontourl] action in Ticket widget.
  String? clientData;
  // Stores action output result for [Custom Action - base64toBytesAction] action in Ticket widget.
  FFUploadedFile? savedImageintoFile;
  // State field(s) for PIN widget.
  FocusNode? pinFocusNode;
  TextEditingController? pinTextController;
  String? Function(BuildContext, String?)? pinTextControllerValidator;
  // Stores action output result for [Custom Action - bytestobase64Action] action in Button widget.
  String? bytesToBase64;
  // Stores action output result for [Custom Action - sendjsontourl] action in Button widget.
  String? responsepintoticket;
  // Stores action output result for [Custom Action - sendjsontourl] action in Button widget.
  String? searchResultsTicketInPIN;
  // State field(s) for PINProcessingToCompleted widget.
  FocusNode? pINProcessingToCompletedFocusNode;
  TextEditingController? pINProcessingToCompletedTextController;
  String? Function(BuildContext, String?)?
      pINProcessingToCompletedTextControllerValidator;
  // Stores action output result for [Custom Action - sendjsontourl] action in Button widget.
  String? responsepintoticketCompleted;
  // Stores action output result for [Custom Action - sendjsontourl] action in Button widget.
  String? searchResultsTicketInPINCompleted;
  bool isDataUploading_uploadDataAlw = false;
  FFUploadedFile uploadedLocalFile_uploadDataAlw =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    pinFocusNode?.dispose();
    pinTextController?.dispose();

    pINProcessingToCompletedFocusNode?.dispose();
    pINProcessingToCompletedTextController?.dispose();
  }
}
