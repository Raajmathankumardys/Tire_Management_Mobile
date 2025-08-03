import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import '../../../../helpers/components/widgets/Add_Edit_Modal/add_edit_modal_top.dart';
import '../../../../helpers/components/widgets/button/app_primary_button.dart';
import '../../../../helpers/components/widgets/input/app_input_field.dart';
import '../../../../helpers/constants.dart';
import '../../cubit/income_cubit.dart';
import '../../cubit/income_state.dart';

class AddEditIncome extends StatefulWidget {
  final BuildContext ctx;
  final String tripId;
  final Income? income;
  const AddEditIncome({
    super.key,
    required this.ctx,
    required this.tripId,
    this.income,
  });

  @override
  State<AddEditIncome> createState() => _AddEditIncomeState();
}

class _AddEditIncomeState extends State<AddEditIncome> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController incomedateController = TextEditingController();
  TextEditingController incomeSourceController = TextEditingController();
  DateTime _incomedate = DateTime.now();
  String? _attachmentUrl;
  bool isload = false;

  Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    if (widget.income != null) {
      amountController.text = widget.income!.amount.toString();
      descriptionController.text = widget.income!.description;
      incomedateController.text = _formatDate(widget.income!.incomeDate);
      _incomedate = widget.income!.incomeDate;
      incomeSourceController.text = widget.income!.incomeSource;
    }
  }

  /*Future<void> _pickAttachment() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _attachmentUrl = result.files.single.path;
      });
      _uploadFile(File(_attachmentUrl!));
    }
  }*/

  /*Future<void> _uploadFile(File file) async {
    setState(() {
      isload = true;
    });
    try {
      // Initialize Dio
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path,
            filename: p.basename(file.path)),
      });
      Response response = await dio.post(
        'https://tms-backend-1-80jm.onrender.com/api/v1/api/attachments/upload',
        data: formData,
      );

      if (response.statusCode == 200) {
        ToastHelper.showCustomToast(context, "File Uploaded Successfully",
            Colors.green, Icons.file_copy);
        setState(() {
          _attachmentUrl = response.data['attachmentUrl'];
          isload = false; // assuming the response returns fileUrl
        });
      } else {
        setState(() {
          _attachmentUrl = '';
          isload = false;
        });
        throw Exception('File upload failed');
      }
    } catch (e) {
      setState(() {
        _attachmentUrl = '';
        isload = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading file: $e')),
      );
    }
  }

  Future<void> _downloadFile(String fileName) async {
    setState(() {
      isload = true;
    });
    // Check and request storage permission
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    try {
      Response response = await dio.get(
        'https://tms-backend-1-80jm.onrender.com/api/v1/api/attachments/download/$fileName',
        options: Options(responseType: ResponseType.bytes),
      );
      if (response.statusCode == 200) {
        ToastHelper.showCustomToast(
            context,
            "File Downloaded Successfully in download folder",
            Colors.green,
            Icons.file_copy);

        final bytes = response.data;

        // Define the path to the Downloads directory
        final downloadsDir = Directory('/storage/emulated/0/Download');

        // Ensure the Downloads directory exists (this is usually pre-existing)
        if (!await downloadsDir.exists()) {
          await downloadsDir.create(recursive: true);
        }

        // Get the file extension from the fileName (handles any file type)
        String fileExtension = p.extension(fileName);
        if (fileExtension.isEmpty) {
          fileExtension = '.unknown'; // Default extension if none found
        }

        // Set the file path with a unique name based on current timestamp and file extension
        final filePath =
            '${downloadsDir.path}/Attchement${DateTime.now().millisecondsSinceEpoch}$fileExtension';
        final file = File(filePath);

        // Write the bytes to the file
        await file.writeAsBytes(bytes, flush: true);

        setState(() {
          isload = false;
        });
      } else {
        setState(() {
          isload = false;
        });
        ToastHelper.showCustomToast(
            context,
            'File download failed with status code: ${response.statusCode}',
            Colors.red,
            Icons.error);
      }
    } catch (e) {
      setState(() {
        isload = false;
      });
      print(e);
      ToastHelper.showCustomToast(
          context, 'Error downloading file: $e', Colors.red, Icons.error);
    }
  }*/

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 12,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              add_edit_modal_top(
                title: widget.income == null
                    ? incomeconstants.addincome
                    : incomeconstants.editincome,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                child: Column(
                  children: [
                    AppInputField(
                        name: constants.textfield,
                        label: "Income Source",
                        hint: "enter income source",
                        controller: incomeSourceController,
                        required: true),
                    AppInputField(
                        name: constants.numberfield,
                        label: incomeconstants.amount,
                        hint: incomeconstants.amounthint,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d{0,2}')),
                        ],
                        controller: amountController,
                        required: true),
                    AppInputField(
                      name: constants.datefield,
                      label: incomeconstants.incomedate,
                      isDatePicker: true,
                      controller: incomedateController,
                      required: true,
                      onDateSelected: (date) {
                        setState(() {
                          _incomedate = date!;
                          incomedateController.text = _formatDate(date);
                        });
                      },
                    ),
                    AppInputField(
                        name: constants.textfield,
                        label: incomeconstants.description,
                        hint: incomeconstants.descriptionhint,
                        controller: descriptionController),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AppPrimaryButton(
                          width: 130,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          title: constants.cancel,
                        ),
                        AppPrimaryButton(
                          width: 130,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final newincome = Income(
                                id: widget.income?.id,
                                tripId: widget.tripId,
                                amount: double.parse(amountController.text),
                                incomeDate: _incomedate,
                                description: descriptionController.text,
                                incomeSource: incomeSourceController.text,
                              );

                              if (widget.income == null) {
                                widget.ctx
                                    .read<IncomeCubit>()
                                    .addIncome(newincome);
                              } else {
                                widget.ctx
                                    .read<IncomeCubit>()
                                    .updateIncome(newincome);
                              }
                              Navigator.pop(context);
                            }
                          },
                          title: widget.income == null
                              ? constants.save
                              : constants.update,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
