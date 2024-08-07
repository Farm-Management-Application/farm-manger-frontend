import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class EstimationResultScreen extends StatelessWidget {
  final String livestockType;
  final dynamic result;
  final bool isSingleGroup;

  EstimationResultScreen({
    required this.livestockType,
    required this.result,
    this.isSingleGroup = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Estimation de Production pour $livestockType',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Color(0xFF285429),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Résultats de l\'Estimation',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Cette estimation est basée sur la période sélectionnée. Elle calcule les ventes totales, le coût de la consommation de nourriture et le profit généré.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Table(
                border: TableBorder.all(color: Color(0xFF285429)),
                columnWidths: {
                  0: FlexColumnWidth(3),
                  1: FlexColumnWidth(2),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: Colors.grey[200]),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Description',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF285429)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Valeur',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF285429)),
                        ),
                      ),
                    ],
                  ),
                  if (isSingleGroup) ..._buildSingleGroupTableRows(),
                  if (!isSingleGroup) ..._buildMultipleGroupsTableRows(),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () => _generatePdf(context),
                  child: Text('Télécharger le rapport en PDF'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF285429),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<TableRow> _buildSingleGroupTableRows() {
    if (livestockType == 'Poulets') {
      return [
        _buildTableRow('Âge du groupe', '${result['eggProduction']['chickenAge']} mois'),
        _buildTableRow('Production d\'œufs', '${result['eggProduction']['eggProduction']}'),
        _buildTableRow('Ventes Totales', '${result['eggProduction']['totalSales']} FCFA'),
        _buildTableRow('Total d\'alvéole d\'œufs', '${result['eggProduction']['trays']}'),
        _buildTableRow('Coût Total de la Consommation de Nourriture', '${result['eggProduction']['totalConsumption']} FCFA'),
        _buildTableRow('Profit', '${result['eggProduction']['profit']} FCFA'),
        _buildTableRow('Durée', '${result['eggProduction']['duration']}'),
      ];
    } else if (livestockType == 'Poissons') {
      return [
        _buildTableRow('Âge du groupe', '${result['fishAge']} mois'),
        _buildTableRow('Prix Total', '${result['totalPrice']} FCFA'),
        _buildTableRow('Consommation Totale', '${result['foodConsumptionTotal']} sacs'),
        _buildTableRow('Profit', '${result['profit']} FCFA'),
      ];
    } else if (livestockType == 'Porcs') {
      return [
        _buildTableRow('Âge du groupe', '${result['pigAge']}'),
        _buildTableRow('Prix Total', '${result['totalPrice']} FCFA'),
        _buildTableRow('Consommation Totale', '${result['foodConsumptionTotal']} sacs'),
        _buildTableRow('Profit', '${result['profit']} FCFA'),
      ];
    }
    return [];
  }

  List<TableRow> _buildMultipleGroupsTableRows() {
    if (livestockType == 'Poulets') {
      return [
        _buildTableRow('Production d\'œufs', '${result['eggProduction']}'),
        _buildTableRow('Ventes Totales', '${result['totalSales']} FCFA'),
        _buildTableRow('Total d\'alvéole d\'œufs', '${result['totalEggTrays']}'),
        _buildTableRow('Coût Total de la Consommation de Nourriture', '${result['totalFoodConsumptionCost']} FCFA'),
        _buildTableRow('Profit', '${result['profit']} FCFA'),
        _buildTableRow('Durée', '${result['duration']}'),
      ];
    } else if (livestockType == 'Poissons') {
      return [
        _buildTableRow('Total Poissons éligibles', '${result['totalEligibleFish']} poissons'),
        _buildTableRow('Prix Total', '${result['totalPrice']} FCFA'),
        _buildTableRow('Consommation Totale', '${result['totalFoodConsumptionCost']} sacs'),
        _buildTableRow('Profit', '${result['profit']} FCFA'),
        _buildTableRow('Date de début', '${result['oldestGroupCreationDate']}'),
        _buildTableRow('Durée', '${result['weeksInAge']} semaines'),
      ];
    } else if (livestockType == 'Porcs') {
      return [
        _buildTableRow('Total Porcs éligibles', '${result['totalEligiblePigCount']} porcs'),
        _buildTableRow('Prix Total', '${result['totalPrice']} FCFA'),
        _buildTableRow('Consommation Totale', '${result['totalFoodConsumption']} sacs'),
        _buildTableRow('Profit', '${result['totalProfit']} FCFA'),
        _buildTableRow('Date de début', '${result['oldestGroupCreationDate']}'),
        _buildTableRow('Durée', '${result['weeksInAge']} semaines'),
      ];
    }
    return [];
  }

  TableRow _buildTableRow(String description, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(description),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value),
        ),
      ],
    );
  }

  Future<void> _generatePdf(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Estimation de Production pour $livestockType',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Cette estimation est basée sur la période sélectionnée. Elle calcule les ventes totales, le coût de la consommation de nourriture et le profit généré.',
                style: pw.TextStyle(fontSize: 16),
              ),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                border: pw.TableBorder.all(),
                headers: ['Description', 'Valeur'],
                data: <List<String>>[
                  for (var row in isSingleGroup ? _buildSingleGroupTableRows() : _buildMultipleGroupsTableRows())
                    [
                      (row.children![0] as Padding).child as String,
                      (row.children![1] as Padding).child as String,
                    ]
                ],
              ),
            ],
          );
        },
      ),
    );

    final directory = await getExternalStorageDirectory();
    final filePath = '${directory!.path}/estimation_${livestockType}_${DateTime.now().toIso8601String()}.pdf';
    final file = File(filePath);

    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF enregistré sous $filePath')),
    );
  }
}