import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:swad_electric__bill_maker/controllers/services/get_device_message.dart';

class PDFGenerator {
  static Future<void> generateAndShareThermalPdf(
      String utility_bill,
      String account_type,
      String account_ref,
      String account_number,
      String energy_cost,
      String charges,
      String service_support,
      String customer_phone_number,
      String total) async {
    final pdf = pw.Document();

    String getCurrentDate() {
      var date = DateTime.now().toString();

      var dateParse = DateTime.parse(date);

      var formattedDate =
          "${dateParse.day}-${dateParse.month}-${dateParse.year}";
      return formattedDate.toString();
    }

    // Set page size to thermal printer dimensions (57mm width)
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(57 * PdfPageFormat.mm,
            double.infinity), // Infinite height for dynamic content
        build: (pw.Context context) {
          return pw.Column(
            // crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text("Swad Enterprize",
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center),
              pw.SizedBox(height: 4),
              pw.Text("Ranavola Sobuj Chatar Mor,Road 01,Uttara Sector 10",
                  style: pw.TextStyle(
                    fontSize: 8,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center),
              pw.SizedBox(height: 2),
              pw.Divider(),
              pw.Divider(),
              pw.SizedBox(height: 2),
              // ...items.map((item) => pw.Text(
              //       item,
              //       style: pw.TextStyle(
              //         font: pw.Font
              //             .courier(), // Monospaced font for thermal style
              //         fontSize: 8,
              //       ),
              //     )),
              pw.Row(
                  children: [
                    pw.Text("Utility Bill",
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        )),
                    pw.Spacer(),
                    pw.Text("$utility_bill",
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ))
                  ],
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.center),

              pw.Row(
                  children: [
                    pw.SizedBox(height: 10),
                    pw.Text("A/C Type",
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        )),
                    pw.Spacer(),
                    pw.Text("$account_type",
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ))
                  ],
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.center),
              pw.Row(
                  children: [
                    pw.SizedBox(height: 10),
                    pw.Text("A/C Reference",
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        )),
                    pw.Spacer(),
                    pw.Text("$account_ref",
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ))
                  ],
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.center),
              pw.Row(
                  children: [
                    pw.SizedBox(height: 10),
                    pw.Text("A/c Number",
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        )),
                    pw.Spacer(),
                    pw.Text("$account_number",
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ))
                  ],
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.center),
              pw.Divider(),
              pw.Row(
                  children: [
                    pw.SizedBox(height: 10),
                    pw.Text("Energy Cost",
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        )),
                    pw.Spacer(),
                    pw.Text("$energy_cost",
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ))
                  ],
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.center),
              pw.Row(
                  children: [
                    pw.SizedBox(height: 10),
                    pw.Text("Charges",
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                        textAlign: pw.TextAlign.left),
                    pw.Spacer(),
                    pw.Text("$charges",
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ))
                  ],
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.center),

              pw.SizedBox(height: 2),
              pw.Divider(),
              pw.Divider(),
              pw.SizedBox(height: 2),
              pw.Row(
                  children: [
                    pw.Text("Total:",
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        )),
                    pw.Text("$total",
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ))
                  ],
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  crossAxisAlignment: pw.CrossAxisAlignment.center),

              pw.SizedBox(height: 2),
              pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text("Paid",
                        style: pw.TextStyle(
                            fontSize: 20, fontWeight: pw.FontWeight.bold)),
                    pw.Text("At ${getCurrentDate()}",
                        style: pw.TextStyle(
                            fontSize: 7, fontWeight: pw.FontWeight.bold))
                  ]),
              pw.SizedBox(height: 2),
              pw.Text("**Note: To get support contact to $service_support",
                  style:
                      pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold))
              // pw.Text(
              //   "Total: $total",
              //   style: pw.TextStyle(
              //     fontSize: 10,
              //     fontWeight: pw.FontWeight.bold,
              //   ),
              // ),
            ],
          );
        },
      ),
    );

    // Save PDF to temporary directory
    final directory = await getTemporaryDirectory();
    final filePath = "${directory.path}/thermal_example.pdf";
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    // Share the file using share_plus
    // await Share.shareFiles([file.path], text: 'Thermal Receipt PDF');
    await NormalMethodCall.shareToSpecificApp(
        file.path, "com.frogtosea.tinyPrint");
  }
}
