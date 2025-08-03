import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import '../../../../helpers/DioClient.dart';
import '../../../../helpers/components/widgets/Add_Edit_Modal/add_edit_modal_top.dart';
import '../../../../helpers/components/widgets/Toast/Toast.dart';
import '../../../../helpers/components/widgets/button/app_primary_button.dart';
import '../../../../helpers/components/widgets/input/app_input_field.dart';
import '../../../../helpers/constants.dart';
import '../../cubit/expense_state.dart';

class AddEditExpense extends StatefulWidget {
  final BuildContext ctx;
  final Expense? expense;
  final String tripId;
  const AddEditExpense(
      {super.key, required this.ctx, this.expense, required this.tripId});

  @override
  State<AddEditExpense> createState() => _AddEditExpenseState();
}

class _AddEditExpenseState extends State<AddEditExpense> {
  final _formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final dateController = TextEditingController();
  final descriptionController = TextEditingController();
  final fuelTypeController = TextEditingController();
  final litersFilledController = TextEditingController();
  final pricePerLiterController = TextEditingController();
  final fuelStationNameController = TextEditingController();
  final allowanceTypeController = TextEditingController();
  final tollPlazaNameController = TextEditingController();
  final remarksController = TextEditingController();
  final serviceCenterController = TextEditingController();
  final repairVendorController = TextEditingController();
  final repairWarrantyController = TextEditingController();
  final vehicleRemarksController = TextEditingController();
  final odometerReadingController = TextEditingController();
  final tireIdController = TextEditingController();
  final tireRemarksController = TextEditingController();
  final replacedWithTireIdController = TextEditingController();

  DateTime? _date;
  String? selectedExpenseType;
  String? selectedForType;
  String? selectedTireExpenseType;

  MaintenanceType? maintenanceType;
  VehicleOrTire? vehicleOrTire;
  VehicleMaintenanceType? vehicleMaintenanceType;
  TireMaintenanceType? tireMaintenanceType;

  String? tireId;
  String? replacedWithTireId;
  List<String> _attachmentUrls = [];
  bool isUploading = false;

  Dio dio = DioClient.createDio();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.expense != null) {
      amountController.text = widget.expense!.amount.toString();
      dateController.text = widget.expense!.expenseDate;
      descriptionController.text = widget.expense!.description ?? "";
      selectedExpenseType = widget.expense!.category.name;
      _attachmentUrls = widget.expense!.attachmentUrls ?? [];
      _date = DateTime.parse(widget.expense!.expenseDate);
      // FUEL
      fuelTypeController.text = widget.expense!.fuelType ?? "";
      litersFilledController.text =
          widget.expense!.litersFilled?.toString() ?? "";
      pricePerLiterController.text =
          widget.expense!.pricePerLiter?.toString() ?? "";
      fuelStationNameController.text = widget.expense!.fuelStationName ?? "";

      // DRIVER_ALLOWANCE
      allowanceTypeController.text = widget.expense!.allowanceType ?? "";

      // TOLL
      tollPlazaNameController.text = widget.expense!.tollPlazaName ?? "";

      // MISCELLANEOUS
      remarksController.text = widget.expense!.remarks ?? "";

      // MAINTENANCE
      maintenanceType = widget.expense!.maintenanceType;
      serviceCenterController.text = widget.expense!.serviceCenter ?? "";
      repairVendorController.text = widget.expense!.repairVendor ?? "";
      repairWarrantyController.text = widget.expense!.repairWarranty ?? "";
      vehicleOrTire = widget.expense!.vehicleOrTire;

      // Vehicle Maintenance
      vehicleMaintenanceType = widget.expense!.vehicleMaintenanceType;
      vehicleRemarksController.text = widget.expense!.vehicleRemarks ?? "";
      odometerReadingController.text =
          widget.expense!.odometerReading?.toString() ?? "";

      // Tire Maintenance
      tireId = widget.expense!.tireId;
      tireMaintenanceType = widget.expense!.tireMaintenanceType;
      tireRemarksController.text = widget.expense!.tireRemarks ?? "";
      replacedWithTireId = widget.expense!.replacedWithTireId;

      // Dropdown display helpers
      selectedForType = widget.expense!.vehicleOrTire?.name ?? "";
      selectedTireExpenseType = widget.expense!.tireMaintenanceType?.name ?? "";
    }
  }

  Future<void> _pickAttachments() async {
    if (_attachmentUrls.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You can attach up to 5 files only.")),
      );
      return;
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg', 'docx'],
    );

    if (result != null) {
      List<PlatformFile> files = result.files;

      // Limit remaining files to reach max of 5
      int remainingSlots = 5 - _attachmentUrls.length;
      List<PlatformFile> filesToUpload = files.take(remainingSlots).toList();

      setState(() {
        isUploading = true;
      });

      for (PlatformFile file in filesToUpload) {
        if (file.path != null) {
          await _uploadFile(File(file.path!));
        }
      }

      setState(() {
        isUploading = false;
      });
    }
  }

  Future<void> _uploadFile(File file) async {
    if (_attachmentUrls.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Maximum 5 attachments allowed.")),
      );
      return;
    }

    setState(() {
      isUploading = true;
    });

    try {
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path,
            filename: p.basename(file.path)),
      });

      Response response = await dio.post(
        '/attachments/upload',
        data: formData,
      );

      if (response.statusCode == 200) {
        String uploadedUrl =
            response.data['data']['attachmentUrl'].toString().split('/').last;

        setState(() {
          _attachmentUrls.add(uploadedUrl);
          isUploading = false;
        });

        ToastHelper.showCustomToast(
          context,
          "File Uploaded Successfully",
          Colors.green,
          Icons.file_copy,
        );
      } else {
        setState(() => isUploading = false);
        throw Exception('File upload failed');
      }
    } catch (e) {
      setState(() => isUploading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading file: $e')),
      );
    }
  }

  Future<void> _downloadFile(String fileName) async {
    setState(() {
      isUploading = true;
    });

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    try {
      Response response = await dio.get(
        '/attachments/download/$fileName',
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        final bytes = response.data;
        final downloadsDir = Directory('/storage/emulated/0/Download');

        if (!await downloadsDir.exists()) {
          await downloadsDir.create(recursive: true);
        }

        String fileExtension = p.extension(fileName);
        if (fileExtension.isEmpty) fileExtension = '.unknown';

        final filePath =
            '${downloadsDir.path}/Attachment_${DateTime.now().millisecondsSinceEpoch}$fileExtension';

        final file = File(filePath);
        await file.writeAsBytes(bytes, flush: true);

        ToastHelper.showCustomToast(
          context,
          "File Downloaded Successfully in download folder",
          Colors.green,
          Icons.file_copy,
        );

        setState(() => isUploading = false);
      } else {
        setState(() => isUploading = false);
        ToastHelper.showCustomToast(
          context,
          'File download failed with status code: ${response.statusCode}',
          Colors.red,
          Icons.error,
        );
      }
    } catch (e) {
      setState(() => isUploading = false);
      ToastHelper.showCustomToast(
        context,
        'Error downloading file: $e',
        Colors.red,
        Icons.error,
      );
    }
  }

  Future<void> deleteAttachment(String fileUrl) async {
    try {
      // Extract the filename from the full URL
      final fileName = p.basename(fileUrl);

      setState(() {
        isUploading = true;
      });

      Response response = await dio.delete('/attachments/delete/$fileName');
      if (response.statusCode == 200) {
        setState(() {
          _attachmentUrls.remove(fileUrl);
          isUploading = false;
        });

        ToastHelper.showCustomToast(
          context,
          "File deleted successfully",
          Colors.green,
          Icons.delete,
        );
      } else {
        setState(() => isUploading = false);
        ToastHelper.showCustomToast(
          context,
          "Failed to delete file: ${response.statusCode}",
          Colors.red,
          Icons.error,
        );
      }
    } catch (e) {
      setState(() => isUploading = false);
      ToastHelper.showCustomToast(
        context,
        "Error deleting file: $e",
        Colors.red,
        Icons.error,
      );
    }
  }

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
              // Header
              add_edit_modal_top(
                  title: widget.expense == null
                      ? expenseconstants.addexpense
                      : expenseconstants.editexpense),

              // Form Inputs
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                child: Column(
                  children: [
                    AppInputField(
                      name: constants.dropdownfield,
                      required: true,
                      label: expenseconstants.expensetype,
                      isDropdown: true,
                      defaultValue: selectedExpenseType,
                      dropdownItems: const [
                        DropdownMenuItem(
                            value: "FUEL", child: Text("Fuel Costs")),
                        DropdownMenuItem(
                            value: "DRIVER_ALLOWANCE",
                            child: Text("Driver Allowances")),
                        DropdownMenuItem(
                            value: "TOLL", child: Text("Toll Charges")),
                        DropdownMenuItem(
                            value: "MAINTENANCE", child: Text("Maintenance")),
                        DropdownMenuItem(
                            value: "MISCELLANEOUS",
                            child: Text("Miscellaneous")),
                      ],
                      onDropdownChanged: (value) {
                        setState(() {
                          selectedExpenseType = value;
                        });
                      },
                    ),
                    AppInputField(
                      name: constants.numberfield,
                      required: true,
                      label: expenseconstants.amount,
                      hint: expenseconstants.amounthint,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d{0,2}')),
                      ],
                      controller: amountController,
                    ),
                    AppInputField(
                      name: constants.datefield,
                      required: true,
                      label: expenseconstants.expensedate,
                      isDatePicker: true,
                      controller: dateController,
                      format: DateFormat("yyyy-MM-dd"),
                      onDateSelected: (date) {
                        setState(() {
                          _date = date!;
                          dateController.text = _formatDate(date);
                        });
                      },
                    ),
                    if (selectedExpenseType == "FUEL") ...[
                      AppInputField(
                          name: "fuelType",
                          label: "Fuel Type",
                          controller: fuelTypeController),
                      AppInputField(
                          name: "litersFilled",
                          label: "Liters Filled",
                          keyboardType: TextInputType.number,
                          controller: litersFilledController),
                      AppInputField(
                          name: "pricePerLiter",
                          label: "Price per Liter",
                          keyboardType: TextInputType.number,
                          controller: pricePerLiterController),
                      AppInputField(
                          name: "fuelStationName",
                          label: "Fuel Station Name",
                          controller: fuelStationNameController),
                    ] else if (selectedExpenseType == "DRIVER_ALLOWANCE") ...[
                      AppInputField(
                          name: "allowanceType",
                          label: "Allowance Type",
                          controller: allowanceTypeController),
                    ] else if (selectedExpenseType == "TOLL") ...[
                      AppInputField(
                          name: "tollPlazaName",
                          label: "Toll Plaza Name",
                          controller: tollPlazaNameController),
                    ] else if (selectedExpenseType == "MAINTENANCE") ...[
                      AppInputField(
                        name: "maintenanceType",
                        label: "Maintenance Type",
                        isDropdown: true,
                        defaultValue: maintenanceType?.name,
                        dropdownItems: const [
                          DropdownMenuItem(
                              value: "PREVENTIVE", child: Text("Preventive")),
                          DropdownMenuItem(
                              value: "CORRECTIVE", child: Text("Corrective")),
                          DropdownMenuItem(
                              value: "PREDICTIVE", child: Text("Predictive")),
                          DropdownMenuItem(
                              value: "CONDITION_BASED",
                              child: Text("Condition Based")),
                        ],
                        onDropdownChanged: (val) => setState(() {
                          maintenanceType = MaintenanceType.values
                              .firstWhere((e) => e.name == val);
                        }),
                      ),
                      AppInputField(
                          name: "serviceCenter",
                          label: "Service Center",
                          controller: serviceCenterController),
                      AppInputField(
                          name: "repairVendor",
                          label: "Repair Vendor",
                          controller: repairVendorController),
                      AppInputField(
                          name: "repair_warranty",
                          label: "Repair Warranty (In Months)",
                          keyboardType: TextInputType.number,
                          controller: repairWarrantyController),
                      AppInputField(
                        name: "vehicleOrTire",
                        label: "For",
                        isDropdown: true,
                        defaultValue: vehicleOrTire?.name,
                        dropdownItems: const [
                          DropdownMenuItem(
                              value: "VEHICLE", child: Text("Vehicle")),
                          DropdownMenuItem(value: "TIRE", child: Text("Tire")),
                        ],
                        onDropdownChanged: (val) => setState(() {
                          vehicleOrTire = VehicleOrTire.values
                              .firstWhere((e) => e.name == val);
                          selectedForType = val;
                        }),
                      ),
                      if (selectedForType == "VEHICLE") ...[
                        AppInputField(
                          name: "vehicleMaintenanceType",
                          label: "Vehicle Maintenance Type",
                          isDropdown: true,
                          defaultValue: vehicleMaintenanceType?.name,
                          dropdownItems: VehicleMaintenanceType.values
                              .map((e) => DropdownMenuItem(
                                  value: e.name,
                                  child: Text(e.name
                                      .replaceAll('_', ' ')
                                      .toLowerCase()
                                      .split(' ')
                                      .map((w) =>
                                          '${w[0].toUpperCase()}${w.substring(1)}')
                                      .join(' '))))
                              .toList(),
                          onDropdownChanged: (val) => setState(() {
                            vehicleMaintenanceType = VehicleMaintenanceType
                                .values
                                .firstWhere((e) => e.name == val);
                          }),
                        ),
                        AppInputField(
                            name: "vehicleRemarks",
                            label: "Vehicle Number",
                            controller: vehicleRemarksController),
                        AppInputField(
                            name: "odometerReading",
                            label: "Odometer Reading",
                            keyboardType: TextInputType.number,
                            controller: odometerReadingController),
                      ] else if (selectedForType == "TIRE") ...[
                        AppInputField(
                          name: "tireMaintenanceType",
                          label: "Tire Maintenance Type",
                          isDropdown: true,
                          defaultValue: tireMaintenanceType?.name,
                          dropdownItems: TireMaintenanceType.values
                              .map((e) => DropdownMenuItem(
                                  value: e.name,
                                  child: Text(e.name
                                      .replaceAll('_', ' ')
                                      .toLowerCase()
                                      .split(' ')
                                      .map((w) =>
                                          '${w[0].toUpperCase()}${w.substring(1)}')
                                      .join(' '))))
                              .toList(),
                          onDropdownChanged: (val) => setState(() {
                            tireMaintenanceType = TireMaintenanceType.values
                                .firstWhere((e) => e.name == val);
                            selectedTireExpenseType = val;
                          }),
                        ),
                        AppInputField(
                            name: "tireId",
                            label: "Tire Serial Number",
                            controller: tireIdController),
                        AppInputField(
                            name: "tireRemarks",
                            label: "Tire Remarks",
                            controller: tireRemarksController),
                        if (selectedTireExpenseType == "REPLACEMENT") ...[
                          AppInputField(
                              name: "replacedWithTireId",
                              label: "Replaced With Tire Serial Number",
                              controller: replacedWithTireIdController),
                        ]
                      ]
                    ] else if (selectedExpenseType == "MISCELLANEOUS") ...[
                      AppInputField(
                          name: "remarks",
                          label: "Remarks",
                          hint: "Enter remarks",
                          controller: remarksController),
                    ],
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Attach Receipts (Max 5)",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 8),
                    isUploading
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(
                              color: Colors.blueAccent,
                            ),
                          )
                        : Wrap(
                            spacing: 8,
                            children: [
                              for (int i = 0; i < _attachmentUrls.length; i++)
                                Chip(
                                    label: Text(p.basename(_attachmentUrls[i])),
                                    deleteIcon: Icon(Icons.close),
                                    onDeleted: () =>
                                        {deleteAttachment(_attachmentUrls[i])}),
                              if (_attachmentUrls.length < 5)
                                ActionChip(
                                  avatar: Icon(Icons.attach_file),
                                  label: Text("Add File"),
                                  onPressed: _pickAttachments,
                                ),
                            ],
                          ),

                    /* SizedBox(height: 5.h),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: isUploading
                          ? Center(child: CircularProgressIndicator())
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: _attachmentUrls.map((url) {
                                    return InkWell(
                                      onTap: () =>
                                          _downloadFile(p.basename(url)),
                                      child: Chip(
                                        label: Text(
                                          p.basename(url),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        avatar: Icon(Icons.insert_drive_file,
                                            color: Colors.blueAccent),
                                        deleteIcon: Icon(Icons.close),
                                        onDeleted: () {
                                          setState(() {
                                            _attachmentUrls.remove(url);
                                          });
                                        },
                                      ),
                                    );
                                  }).toList(),
                                ),
                                if (_attachmentUrls.length < 5) ...[
                                  SizedBox(height: 10),
                                  TextButton.icon(
                                    onPressed: _pickAttachments,
                                    icon: Icon(Icons.upload_file,
                                        color: Colors.blueAccent),
                                    label: Text("Upload"),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.blueAccent,
                                    ),
                                  ),
                                ]
                              ],
                            ),
                    ),*/
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
                              final newexpense = Expense(
                                id: widget.expense?.id,
                                tripId: widget.tripId,
                                amount: double.parse(amountController.text),
                                expenseDate: _formatDate(
                                    _date ?? DateTime.now()), // <-- Correct
                                description: descriptionController.text,
                                category: ExpenseCategory.values.firstWhere(
                                  (e) => e.name == selectedExpenseType,
                                  orElse: () => ExpenseCategory.MISCELLANEOUS,
                                ),
                                attachmentUrls: _attachmentUrls.isEmpty
                                    ? null
                                    : _attachmentUrls,
                                fuelType: fuelTypeController.text,
                                litersFilled: double.tryParse(
                                    litersFilledController.text),
                                pricePerLiter: double.tryParse(
                                    pricePerLiterController.text),
                                fuelStationName: fuelStationNameController.text,
                                allowanceType: allowanceTypeController.text,
                                tollPlazaName: tollPlazaNameController.text,
                                remarks: remarksController.text,
                                maintenanceType: maintenanceType,
                                serviceCenter: serviceCenterController.text,
                                repairVendor: repairVendorController.text,
                                repairWarranty: repairWarrantyController.text,
                                vehicleMaintenanceType: vehicleMaintenanceType,
                                vehicleOrTire: vehicleOrTire,
                                vehicleRemarks: vehicleRemarksController.text,
                                odometerReading: int.tryParse(
                                    odometerReadingController.text),
                                tireId: tireIdController.text,
                                tireMaintenanceType: tireMaintenanceType,
                                tireRemarks: tireRemarksController.text,
                                replacedWithTireId:
                                    replacedWithTireIdController.text,
                              );
                              print(newexpense.toJson());

                              /* if (widget.expense == null) {
                                widget.ctx
                                    .read<ExpenseCubit>()
                                    .addExpense(newexpense);
                              } else {
                                widget.ctx
                                    .read<ExpenseCubit>()
                                    .updateExpense(newexpense);
                              }

                              Navigator.pop(context);*/
                            }
                          },
                          title: widget.expense == null
                              ? constants.save
                              : constants.update,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
