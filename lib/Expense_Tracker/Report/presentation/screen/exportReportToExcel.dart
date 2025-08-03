// import 'dart:convert';
// import 'dart:io';
// import 'package:excel/excel.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// Future<void> exportReportToExcel(String reportJsonString) async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   final reportJson = json.decode(reportJsonString);
//   final excel = Excel.createExcel();
//
//   // Trip Profitability Sheet
//   final tripSheet = excel['Trip Profitability'];
//   tripSheet.appendRow([
//     TextCellValue('Trip Name'),
//     TextCellValue('Start Date'),
//     TextCellValue('End Date'),
//     TextCellValue('Vehicle Number'),
//     TextCellValue('Driver Name'),
//     TextCellValue('Income'),
//     TextCellValue('Expenses'),
//     TextCellValue('Profit'),
//     TextCellValue('Status'),
//   ]);
//   for (var trip in reportJson['tripProfitability']['tripData']) {
//     tripSheet.appendRow([
//       TextCellValue(trip['name']),
//       TextCellValue(trip['startDate']),
//       TextCellValue(trip['endDate']),
//       TextCellValue(trip['vehicleNumber']),
//       TextCellValue(trip['driverName']),
//       DoubleCellValue((trip['income'] ?? 0).toDouble()),
//       DoubleCellValue((trip['expenses'] ?? 0).toDouble()),
//       DoubleCellValue((trip['profit'] ?? 0).toDouble()),
//       TextCellValue(trip['status']),
//     ]);
//   }
//
//   // Monthly Report Sheet
//   final monthlySheet = excel['Monthly Report'];
//   monthlySheet.appendRow([
//     TextCellValue('Month'),
//     TextCellValue('Income'),
//     TextCellValue('Expenses'),
//     TextCellValue('Profit'),
//   ]);
//   for (var month in reportJson['tripProfitability']['monthlyData']) {
//     monthlySheet.appendRow([
//       TextCellValue(month['month']),
//       DoubleCellValue((month['income'] ?? 0).toDouble()),
//       DoubleCellValue((month['expenses'] ?? 0).toDouble()),
//       DoubleCellValue((month['profit'] ?? 0).toDouble()),
//     ]);
//   }
//
//   // Quarterly Report Sheet
//   final quarterSheet = excel['Quarterly Report'];
//   quarterSheet.appendRow([
//     TextCellValue('Quarter'),
//     TextCellValue('Income'),
//     TextCellValue('Expenses'),
//     TextCellValue('Profit'),
//   ]);
//   for (var quarter in reportJson['tripProfitability']['quarterlyData']) {
//     quarterSheet.appendRow([
//       TextCellValue(quarter['quarter']),
//       DoubleCellValue((quarter['income'] ?? 0).toDouble()),
//       DoubleCellValue((quarter['expenses'] ?? 0).toDouble()),
//       DoubleCellValue((quarter['profit'] ?? 0).toDouble()),
//     ]);
//   }
//
//   // Expense Breakdown Sheet
//   final expenseSheet = excel['Expense Breakdown'];
//   expenseSheet.appendRow([
//     TextCellValue('Category'),
//     TextCellValue('Amount'),
//     TextCellValue('Percentage'),
//   ]);
//   for (var category in reportJson['expenseBreakdown']['categoryBreakdown']) {
//     expenseSheet.appendRow([
//       TextCellValue(category['category']),
//       DoubleCellValue((category['amount'] ?? 0).toDouble()),
//       DoubleCellValue((category['percentage'] ?? 0).toDouble()),
//     ]);
//   }
//
//   // Income vs Expense Sheet
//   final comparisonSheet = excel['Income vs Expense'];
//   comparisonSheet.appendRow([
//     TextCellValue('Period'),
//     TextCellValue('Income'),
//     TextCellValue('Expenses'),
//     TextCellValue('Profit'),
//   ]);
//   for (var item in reportJson['incomeVsExpense']['comparisons']) {
//     comparisonSheet.appendRow([
//       TextCellValue(item['period']),
//       DoubleCellValue((item['income'] ?? 0).toDouble()),
//       DoubleCellValue((item['expenses'] ?? 0).toDouble()),
//       DoubleCellValue((item['profit'] ?? 0).toDouble()),
//     ]);
//   }
//
//   final totals = reportJson['incomeVsExpense']['totals'];
//   comparisonSheet.appendRow([]);
//   comparisonSheet.appendRow([
//     TextCellValue('Total Income'),
//     DoubleCellValue(totals['totalIncome'].toDouble())
//   ]);
//   comparisonSheet.appendRow([
//     TextCellValue('Total Expenses'),
//     DoubleCellValue(totals['totalExpenses'].toDouble())
//   ]);
//   comparisonSheet.appendRow([
//     TextCellValue('Total Profit'),
//     DoubleCellValue(totals['totalProfit'].toDouble())
//   ]);
//   comparisonSheet.appendRow([
//     TextCellValue('Profit %'),
//     DoubleCellValue(totals['profitPercentage'].toDouble())
//   ]);
//
//   // Save file
//   final List<int>? fileBytes = excel.save();
//   if (fileBytes == null) return;
//
//   // Request permission
//   if (Platform.isAndroid) {
//     final status = await Permission.storage.request();
//     if (!status.isGranted) return;
//   }
//
//   final directory = await getExternalStorageDirectory(); // App-specific dir
//   print(directory);
//   if (directory == null) return;
//   final filePath =
//       '${directory.path}/Trip_Report_${DateTime.now().millisecondsSinceEpoch}.xlsx';
//   final file = File(filePath);
//   await file.writeAsBytes(fileBytes, flush: true);
//
//   print('Excel file saved at: $filePath');
// }
import 'dart:convert';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'package:flutter/material.dart';

Future<void> exportReportToExcel(String reportJsonString) async {
  WidgetsFlutterBinding.ensureInitialized();

  final reportJson = json.decode(reportJsonString);
  final workbook = xlsio.Workbook();

  // Style configuration
  final titleStyle = workbook.styles.add('TitleStyle');
  titleStyle.bold = true;
  titleStyle.hAlign = xlsio.HAlignType.center;
  // Light Gray Background

  final currencyStyle = workbook.styles.add('CurrencyStyle');
  currencyStyle.numberFormat =
      '"₹"#,##0.00'; // Indian currency format for demonstration

  final headerStyle = workbook.styles.add('HeaderStyle');
  headerStyle.bold = true;
  headerStyle.hAlign = xlsio.HAlignType.center;
  // Light Blue Background

  // Trip Profitability Sheet
  final tripSheet = workbook.worksheets[0];
  tripSheet.name = 'Trip Profitability';
  tripSheet.importList([
    [
      'Trip Name',
      'Start Date',
      'End Date',
      'Vehicle Number',
      'Driver Name',
      'Income',
      'Expenses',
      'Profit',
      'Status'
    ]
  ], 1, 1, true);
  tripSheet.getRangeByName('A1:I1').cellStyle =
      headerStyle; // Apply header style

  int tripRow = 2;
  for (var trip in reportJson['tripProfitability']['tripData']) {
    tripSheet.importList([
      [
        trip['name'],
        trip['startDate'],
        trip['endDate'],
        trip['vehicleNumber'],
        trip['driverName'],
        trip['income']?.toDouble() ?? 0.0,
        trip['expenses']?.toDouble() ?? 0.0,
        trip['profit']?.toDouble() ?? 0.0,
        trip['status'],
      ]
    ], tripRow++, 1, false);
    // Apply currency formatting to income, expenses, and profit columns
    tripSheet.getRangeByIndex(tripRow, 6).numberFormat = '₹#,##0.00';
    tripSheet.getRangeByIndex(tripRow, 7).numberFormat = '₹#,##0.00';
    tripSheet.getRangeByIndex(tripRow, 8).numberFormat = '₹#,##0.00';
  }

  // Monthly Report Sheet
  final monthlySheet = workbook.worksheets.addWithName('Monthly Report');
  monthlySheet.importList([
    ['Month', 'Income', 'Expenses', 'Profit']
  ], 1, 1, true);
  monthlySheet.getRangeByName('A1:D1').cellStyle =
      headerStyle; // Apply header style

  int monthRow = 2;
  for (var month in reportJson['tripProfitability']['monthlyData']) {
    monthlySheet.importList([
      [
        month['month'],
        month['income']?.toDouble() ?? 0.0,
        month['expenses']?.toDouble() ?? 0.0,
        month['profit']?.toDouble() ?? 0.0,
      ]
    ], monthRow++, 1, false);
    // Apply currency formatting to income, expenses, and profit columns
    monthlySheet.getRangeByIndex(monthRow, 2).numberFormat = '₹#,##0.00';
    monthlySheet.getRangeByIndex(monthRow, 3).numberFormat = '₹#,##0.00';
    monthlySheet.getRangeByIndex(monthRow, 4).numberFormat = '₹#,##0.00';
  }

  // Quarterly Report Sheet
  final quarterSheet = workbook.worksheets.addWithName('Quarterly Report');
  quarterSheet.importList([
    ['Quarter', 'Income', 'Expenses', 'Profit']
  ], 1, 1, true);
  quarterSheet.getRangeByName('A1:D1').cellStyle =
      headerStyle; // Apply header style

  int quarterRow = 2;
  for (var quarter in reportJson['tripProfitability']['quarterlyData']) {
    quarterSheet.importList([
      [
        quarter['quarter'],
        quarter['income']?.toDouble() ?? 0.0,
        quarter['expenses']?.toDouble() ?? 0.0,
        quarter['profit']?.toDouble() ?? 0.0,
      ]
    ], quarterRow++, 1, false);
    // Apply currency formatting to income, expenses, and profit columns
    quarterSheet.getRangeByIndex(quarterRow, 2).numberFormat = '₹#,##0.00';
    quarterSheet.getRangeByIndex(quarterRow, 3).numberFormat = '₹#,##0.00';
    quarterSheet.getRangeByIndex(quarterRow, 4).numberFormat = '₹#,##0.00';
  }

  // Expense Breakdown Sheet
  final expenseSheet = workbook.worksheets.addWithName('Expense Breakdown');
  expenseSheet.importList([
    ['Category', 'Amount', 'Percentage']
  ], 1, 1, true);
  expenseSheet.getRangeByName('A1:C1').cellStyle =
      headerStyle; // Apply header style

  int expenseRow = 2;
  for (var category in reportJson['expenseBreakdown']['categoryBreakdown']) {
    expenseSheet.importList([
      [
        category['category'],
        category['amount']?.toDouble() ?? 0.0,
        category['percentage']?.toDouble() ?? 0.0,
      ]
    ], expenseRow++, 1, false);
    // Apply currency formatting to amount column
    expenseSheet.getRangeByIndex(expenseRow, 2).numberFormat = '₹#,##0.00';
  }

  // Income vs Expense Sheet
  final compSheet = workbook.worksheets.addWithName('Income vs Expense');
  compSheet.importList([
    ['Period', 'Income', 'Expenses', 'Profit']
  ], 1, 1, true);
  compSheet.getRangeByName('A1:D1').cellStyle =
      headerStyle; // Apply header style

  int compRow = 2;
  for (var item in reportJson['incomeVsExpense']['comparisons']) {
    compSheet.importList([
      [
        item['period'],
        item['income']?.toDouble() ?? 0.0,
        item['expenses']?.toDouble() ?? 0.0,
        item['profit']?.toDouble() ?? 0.0,
      ]
    ], compRow++, 1, false);
    // Apply currency formatting to income, expenses, and profit columns
    compSheet.getRangeByIndex(compRow, 2).numberFormat = '₹#,##0.00';
    compSheet.getRangeByIndex(compRow, 3).numberFormat = '₹#,##0.00';
    compSheet.getRangeByIndex(compRow, 4).numberFormat = '₹#,##0.00';
  }

  final totals = reportJson['incomeVsExpense']['totals'];
  compRow++; // Skip a line
  compSheet.importList([
    ['Total Income', totals['totalIncome']?.toDouble() ?? 0.0],
    ['Total Expenses', totals['totalExpenses']?.toDouble() ?? 0.0],
    ['Total Profit', totals['totalProfit']?.toDouble() ?? 0.0],
    ['Profit %', totals['profitPercentage']?.toDouble() ?? 0.0],
  ], compRow, 1, false);

  // Apply currency formatting to totals
  compSheet.getRangeByIndex(compRow, 2).numberFormat = '₹#,##0.00';
  compSheet.getRangeByIndex(compRow + 1, 2).numberFormat = '₹#,##0.00';
  compSheet.getRangeByIndex(compRow + 2, 2).numberFormat = '₹#,##0.00';
  compSheet.getRangeByIndex(compRow + 3, 2).numberFormat =
      '#0.00%'; // Profit percentage format

  // Save file
  final List<int> bytes = workbook.saveAsStream();
  workbook.dispose();

  // Request permission
  if (Platform.isAndroid) {
    final status = await Permission.manageExternalStorage.request();
    if (!status.isGranted) return;
  }

  // Save to Downloads folder
  final downloadsDir = Directory('/storage/emulated/0/Download');
  if (!await downloadsDir.exists()) await downloadsDir.create(recursive: true);
  final filePath =
      '${downloadsDir.path}/Trip_Report_${DateTime.now().millisecondsSinceEpoch}.xlsx';
  final file = File(filePath);
  await file.writeAsBytes(bytes, flush: true);

  print('Excel file saved at: $filePath');
}
