import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yaantrac_app/common/widgets/Toast/Toast.dart';
import 'package:yaantrac_app/common/widgets/button/app_primary_button.dart';
import 'package:yaantrac_app/models/tire.dart';
import 'package:yaantrac_app/trash/add_tire_screen.dart';
import 'package:yaantrac_app/screens/tire_status_screen.dart';
import 'package:yaantrac_app/screens/vehicles_list_screen.dart';
import 'package:yaantrac_app/services/api_service.dart';
import 'package:yaantrac_app/common/widgets/button/action_button.dart';

import '../common/widgets/input/app_input_field.dart';
import 'Homepage.dart';

class TiresListScreen extends StatefulWidget {
  const TiresListScreen({super.key});

  @override
  State<TiresListScreen> createState() => _TiresListScreenState();
}

class _TiresListScreenState extends State<TiresListScreen> {
  late Future<List<TireModel>> futureTires;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late TextEditingController brand;
  late TextEditingController model;
  late TextEditingController size;
  late TextEditingController stock;
  bool _isload = false;
  TireModel? tire;
  @override
  void initState() {
    futureTires = getTires();
    super.initState();
  }

  void _showAddEditModal({TireModel? tire}) {
    final _formKey = GlobalKey<FormState>();
    String brand = tire?.brand ?? '';
    String model = tire?.model ?? '';
    String size = tire?.size ?? '';
    int stock = tire?.stock ?? 0;
    bool isLoading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        tire == null ? "Add Tire" : "Edit Tire",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      AppInputField(
                        label: "Tire Model",
                        hint: "Enter tire model",
                        defaultValue: model,
                        onInputChanged: (value) => model = value ?? '',
                      ),
                      SizedBox(height: 20),
                      AppInputField(
                        label: "Brand",
                        hint: "Enter brand",
                        defaultValue: brand,
                        onInputChanged: (value) => brand = value ?? '',
                      ),
                      SizedBox(height: 20),
                      AppInputField(
                        label: "Size",
                        hint: "Enter size",
                        defaultValue: size,
                        onInputChanged: (value) => size = value ?? '',
                      ),
                      SizedBox(height: 20),
                      AppInputField(
                        label: "Stock",
                        hint: "Enter stock quantity",
                        defaultValue: stock.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onInputChanged: (value) =>
                            stock = int.tryParse(value ?? '0') ?? 0,
                      ),
                      SizedBox(height: 20),
                      isLoading
                          ? CircularProgressIndicator()
                          : AppPrimaryButton(
                              onPressed: () async {
                                print(tire?.id);
                                if (_formKey.currentState!.validate()) {
                                  setState(() => isLoading = true);

                                  try {
                                    final response =
                                        await APIService.instance.request(
                                      tire == null
                                          ? "https://yaantrac-backend.onrender.com/api/tires"
                                          : "https://yaantrac-backend.onrender.com/api/tires/${tire.id}",
                                      tire == null
                                          ? DioMethod.post
                                          : DioMethod.put,
                                      formData: {
                                        "id": tire?.id,
                                        "brand": brand,
                                        "model": model,
                                        "size": size,
                                        "stock": stock,
                                      },
                                      contentType: "application/json",
                                    );

                                    if (response.statusCode == 200) {
                                      ToastHelper.showCustomToast(
                                        context,
                                        tire == null
                                            ? "Tire added successfully"
                                            : "Tire updated successfully",
                                        Colors.green,
                                        tire == null ? Icons.add : Icons.edit,
                                      );

                                      Navigator.pop(context);
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) => HomeScreen(
                                                    currentIndex: 1,
                                                  )),
                                          (route) => false);
                                    } else {
                                      ToastHelper.showCustomToast(
                                          context,
                                          "Failed to process request",
                                          Colors.red,
                                          Icons.error);
                                    }
                                  } catch (err) {
                                    ToastHelper.showCustomToast(
                                        context,
                                        "Network error, please try again.",
                                        Colors.red,
                                        Icons.error);
                                  } finally {
                                    setState(() => isLoading = false);
                                  }
                                }
                              },
                              title: tire == null ? "Add Tire" : "Update Tire",
                            ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _confirmDelete(int tireId) async {
    bool isDeleting = false;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ), // Dark background for contrast
              title: Row(
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: Colors.red, size: 28),
                  SizedBox(width: 8),
                  Text(
                    "Confirm Delete",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: isDeleting
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 10),
                        Text(
                          "Deleting Tire... Please wait",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      "Are you sure you want to delete this tire? This action cannot be undone.",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
              actions: isDeleting
                  ? []
                  : [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Cancel")),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () async {
                          setState(() => isDeleting = true);
                          await _onDelete(tireId);
                          if (context.mounted) Navigator.pop(context);
                        },
                        child: Text("Delete"),
                      ),
                    ],
            );
          },
        );
      },
    );
  }

  Future<void> _onDelete(int tireId) async {
    try {
      final response = await APIService.instance.request(
          "https://yaantrac-backend.onrender.com/api/tires/$tireId",
          DioMethod.delete,
          contentType: "application/json");
      if (response.statusCode == 200) {
        setState(() {
          futureTires = getTires();
        });

        ToastHelper.showCustomToast(
            context, "Tire Deleted Successfully", Colors.red, Icons.delete);
      } else {
        print("Error: ${response.statusMessage}");
      }
    } catch (err) {
      print("Delete Error: $err");
    }
  }

  Future<List<TireModel>> getTires() async {
    try {
      final response = await APIService.instance.request(
        "https://yaantrac-backend.onrender.com/api/tires",
        DioMethod.get,
        contentType: "application/json",
      );
      if (response.statusCode == 200) {
        List<dynamic> tireList = response.data['data'];
        print(tireList);
        return tireList.map((json) => TireModel.fromJson(json)).toList();
      } else {
        throw Exception("Error: ${response.statusMessage}");
      }
    } catch (e) {
      throw Exception("Error fetching tires: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Tires",
              style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          elevation: 2,
          leading: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.topRight,
            //margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: IconButton(
                alignment: Alignment.topRight,
                onPressed: () {
                  _showAddEditModal();
                },
                icon: Icon(
                  Icons.add,
                  size: 24,
                )),
          ),
          backgroundColor: isDarkMode ? Colors.black : Colors.blueAccent,
        ),
        body: FutureBuilder<List<TireModel>>(
          future: futureTires,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.blueAccent));
            } else if (snapshot.hasError) {
              return Center(
                  child: Text("Error: ${snapshot.error}",
                      style: TextStyle(
                          color:
                              isDarkMode ? Colors.grey[900] : Colors.white)));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                  child: Text("No tires available",
                      style: TextStyle(
                          color:
                              isDarkMode ? Colors.grey[900] : Colors.white)));
            } else {
              List<TireModel> tires = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: tires.length,
                itemBuilder: (context, index) {
                  final tire = tires[index];
                  return Card(
                    color: isDarkMode ? Colors.grey[800]! : Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: GestureDetector(
                      onTap: () {
                        if (tire.id != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TireStatusScreen(tireId: tire.id!),
                            ),
                          );
                        } else {
                          ToastHelper.showCustomToast(context, "Tire not found",
                              Colors.yellow, Icons.warning_amber);
                        }
                      },
                      child: ListTile(
                        contentPadding: EdgeInsets.all(12),
                        leading: SvgPicture.asset(
                          "assets/vectors/tire.svg",
                          width: 50,
                          height: 50,
                        ),
                        title: Text(
                          tire.brand,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Model: ${tire.model}",
                                style: TextStyle(color: Colors.grey[400])),
                            Text("Size: ${tire.size}, Stock: ${tire.stock}",
                                style: TextStyle(color: Colors.grey[400])),
                          ],
                        ),
                        trailing: Wrap(
                          spacing: 8,
                          children: [
                            ActionButton(
                                icon: Icons.edit,
                                color: Colors.green,
                                onPressed: () =>
                                    {_showAddEditModal(tire: tire)}),
                            ActionButton(
                                icon: Icons.delete,
                                color: Colors.red,
                                onPressed: () =>
                                    _confirmDelete(tire.id!.toInt())),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ));
  }
}
