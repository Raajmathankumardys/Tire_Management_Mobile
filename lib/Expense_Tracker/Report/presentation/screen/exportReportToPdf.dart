import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> exportReportToPdf(Map<String, dynamic> report) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return [
          pw.Center(
              child: pw.Text('Report Summary',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold))),
          pw.SizedBox(height: 20),

          /// Trip Profitability Table
          pw.Text('Trip Profitability',
              style:
                  pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 15),
          pw.Table.fromTextArray(
            headers: [
              'Trip',
              'Start Date',
              'End Date',
              'Vehicle No.',
              'Driver Name',
              'Income',
              'Expenses',
              'Profit',
              'Status'
            ],
            data: report['tripProfitability']['tripData']
                .map<List<String>>((trip) {
              return [
                trip['name'].toString(),
                trip['startDate'].toString(),
                trip['endDate'].toString(),
                trip['vehicleNumber'].toString(),
                trip['driverName'].toString(),
                '${trip['income']}',
                '${trip['expenses']}',
                '${trip['profit']}',
                trip['status'].toString(),
              ];
            }).toList(),
            cellStyle: pw.TextStyle(fontSize: 10),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            border: pw.TableBorder.all(width: 0.5),
          ),

          pw.SizedBox(height: 20),

          /// Monthly Profitability
          pw.Text('Monthly Profitability',
              style:
                  pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.Table.fromTextArray(
            headers: ['Month', 'Income', 'Expenses', 'Profit'],
            data: report['tripProfitability']['monthlyData']
                .map<List<String>>((month) {
              return [
                month['month'].toString(),
                '${month['income']}',
                '${month['expenses']}',
                '${month['profit']}',
              ];
            }).toList(),
            cellStyle: pw.TextStyle(fontSize: 10),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            border: pw.TableBorder.all(width: 0.5),
          ),

          pw.SizedBox(height: 20),

          /// Quarterly Profitability
          pw.Text('Quarterly Profitability',
              style:
                  pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.Table.fromTextArray(
            headers: ['Quarter', 'Income', 'Expenses', 'Profit'],
            data: report['tripProfitability']['quarterlyData']
                .map<List<String>>((qtr) {
              return [
                qtr['quarter'].toString(),
                '${qtr['income']}',
                '${qtr['expenses']}',
                '${qtr['profit']}',
              ];
            }).toList(),
            cellStyle: pw.TextStyle(fontSize: 10),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            border: pw.TableBorder.all(width: 0.5),
          ),

          pw.SizedBox(height: 20),

          /// Expense Breakdown Table
          pw.Text('Overall Expense Breakdown by Category',
              style:
                  pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.Table.fromTextArray(
            headers: ['Category', 'Amount', 'Percentage'],
            data: report['expenseBreakdown']['categoryBreakdown']
                .map<List<String>>((cat) {
              return [
                cat['category'].toString(),
                '${cat['amount']}',
                '${cat['percentage']}%',
              ];
            }).toList(),
            cellStyle: pw.TextStyle(fontSize: 10),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            border: pw.TableBorder.all(width: 0.5),
          ),

          pw.SizedBox(height: 20),

          /// Trip-wise Expense Table
          pw.Text('Trip-wise Expense Breakdown',
              style:
                  pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          ...report['expenseBreakdown']['tripExpenses'].map<pw.Widget>((trip) {
            final categoryEntries = (trip['expensesByCategory'] as Map).entries;
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Trip: ${trip['tripName']}',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('Total Expenses: ${trip['totalExpenses']}'),
                pw.Table.fromTextArray(
                  headers: ['Category', 'Amount'],
                  data: categoryEntries
                      .map<List<String>>((e) => [e.key, '${e.value}'])
                      .toList(),
                  cellStyle: pw.TextStyle(fontSize: 10),
                  border: pw.TableBorder.all(width: 0.5),
                ),
                pw.SizedBox(height: 10),
              ],
            );
          }).toList(),

          /// Income vs Expense Table
          pw.Text('Income vs Expense (Comparison)',
              style:
                  pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.Table.fromTextArray(
            headers: ['Period', 'Income', 'Expenses', 'Profit'],
            data: report['incomeVsExpense']['comparisons']
                .map<List<String>>((entry) {
              return [
                entry['period'].toString(),
                '${entry['income']}',
                '${entry['expenses']}',
                '${entry['profit']}',
              ];
            }).toList(),
            cellStyle: pw.TextStyle(fontSize: 10),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            border: pw.TableBorder.all(width: 0.5),
          ),

          pw.SizedBox(height: 10),

          pw.Text('Overall Summary',
              style:
                  pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.Text(
            'Total Income: ${report['incomeVsExpense']['totals']['totalIncome']}\n'
            'Total Expenses: ${report['incomeVsExpense']['totals']['totalExpenses']}\n'
            'Total Profit: ${report['incomeVsExpense']['totals']['totalProfit']}\n'
            'Profit Percentage: ${report['incomeVsExpense']['totals']['profitPercentage'].toStringAsFixed(2)}%',
            style: pw.TextStyle(fontSize: 12),
          ),
        ];
      },
    ),
  );

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}
