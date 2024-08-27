// lib/screens/group_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/chicken.dart';
import '../models/fish.dart';
import '../models/pig.dart';
import '../services/chicken_service.dart';
import '../services/fish_service.dart';
import '../services/pig_service.dart';
import 'estimation_result_screen.dart';
import '../utils/utilFunctions.dart';
import '../widgets/loading_widget.dart';

class GroupDetailScreen extends StatefulWidget {
  final dynamic group;
  final String livestockType;

  GroupDetailScreen({required this.group, required this.livestockType});

  @override
  _GroupDetailScreenState createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  final ChickenService _chickenService = ChickenService();
  final FishService _fishService = FishService();
  final PigService _pigService = PigService();

  String _timeFrame = 'month';
  int _value = 1;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _showCustomDatePickers = false;

  bool get _isEligibleForEstimation {
    if (widget.livestockType == 'Poulets') {
      final int ageInMonths = DateTime.now().difference(widget.group.birthDate).inDays ~/ 30;
      return ageInMonths >= 6; // Assuming 6 months as the eligibility age for egg production
    }
    return true;
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        // If the end date is before the start date, reset the end date
        if (_endDate != null && _endDate!.isBefore(_startDate!)) {
          _endDate = null;
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate!.add(Duration(days: 1)),
      firstDate: _startDate!,
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
}

void _showEstimationModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Material(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Estimation de la production',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF285429),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          widget.livestockType == 'Poulets'
                              ? 'Cela calcule la production d\'œufs pour le groupe et la période sélectionnée (pour une période donnée), en s\'assurant que les poulets sont en âge de pondre des œufs. Il estime le prix total de tous les plateaux d\'œufs produits et le profit après déduction des coûts de consommation des sacs.'
                              : widget.livestockType == 'Poissons'
                                  ? 'Cela calcule le revenu total de la vente des poissons qui sont en âge d\'être vendus pour le groupe sélectionné.'
                                  : 'Cela calcule le revenu total de la vente des porcs qui sont en âge d\'être vendus pour le groupe sélectionné.',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        SizedBox(height: 20),
                        if (widget.livestockType == 'Poulets') ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: DropdownButtonFormField<String>(
                              value: _timeFrame,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _timeFrame = newValue!;
                                  _showCustomDatePickers = _timeFrame == 'custom';
                                });
                              },
                              items: <String>['month', 'week', 'custom'].map<DropdownMenuItem<String>>((String value) {
                                String displayValue;
                                switch (value) {
                                  case 'month':
                                    displayValue = 'mois';
                                    break;
                                  case 'week':
                                    displayValue = 'semaine';
                                    break;
                                  case 'custom':
                                    displayValue = 'personnalisé';
                                    break;
                                  default:
                                    displayValue = value;
                                }
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(displayValue),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                labelText: 'Période',
                                labelStyle: TextStyle(color: Color(0xFF285429)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFF285429)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFF285429)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          if (!_showCustomDatePickers)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Valeur',
                                  labelStyle: TextStyle(color: Color(0xFF285429)),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF285429)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF285429)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                initialValue: _value.toString(),
                                onChanged: (value) {
                                  setState(() {
                                    _value = int.parse(value);
                                  });
                                },
                              ),
                            ),
                          if (_showCustomDatePickers) ...[
                            ListTile(
                              title: Text(
                                "Date de début: ${_startDate != null ? _startDate!.toLocal().toString().split(' ')[0] : 'Sélectionner'}",
                                style: TextStyle(color: Color(0xFF285429)),
                              ),
                              trailing: Icon(Icons.calendar_today, color: Color(0xFF285429)),
                              onTap: () => _selectStartDate(context),
                            ),
                            ListTile(
                              title: Text(
                                "Date de fin: ${_endDate != null ? _endDate!.toLocal().toString().split(' ')[0] : 'Sélectionner'}",
                                style: TextStyle(color: Color(0xFF285429)),
                              ),
                              trailing: Icon(Icons.calendar_today, color: Color(0xFF285429)),
                              onTap: () => _selectEndDate(context),
                            ),
                          ],
                        ],
                        SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: _isEligibleForEstimation ? () {
                              Navigator.pop(context);
                              _estimateProduction();
                            } : null,
                            child: Text('Confirmer'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF285429),
                              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        if (!_isEligibleForEstimation)
                          Center(
                            child: Text(
                              'Les poulets doivent avoir au moins 6 mois pour être éligibles à la ponte.',
                              style: TextStyle(color: Colors.red, fontSize: 16),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
    },
  );
}
  // Future<void> _estimateProduction() async {
  //   final Map<String, dynamic> requestData = {
  //     'timeFrame': _timeFrame,
  //     'value': _value,
  //   };

  //   if (_timeFrame == 'custom' && _startDate != null && _endDate != null) {
  //     requestData['startDate'] = _startDate!.toIso8601String();
  //     requestData['endDate'] = _endDate!.toIso8601String();
  //   }

  //   dynamic result;
  //   try {
  //     if (widget.livestockType == 'Poulets') {
  //       result = await _chickenService.estimateEggProductionForGroup(widget.group.id, requestData);
  //     } else if (widget.livestockType == 'Poissons') {
  //       result = await _fishService.estimatePriceForGroup(widget.group.id);
  //     } else if (widget.livestockType == 'Porcs') {
  //       result = await _pigService.estimatePriceForGroup(widget.group.id);
  //     }

  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => EstimationResultScreen(
  //           livestockType: widget.livestockType,
  //           result: result,
  //           isSingleGroup: true,
  //         ),
  //       ),
  //     );
  //   } catch (e) {
  //     if (e.toString().contains('Fish group not yet ready for sale') ||
  //         e.toString().contains('Pig group not yet ready for sale')) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Groupe de ${widget.livestockType} pas encore prêt à la vente')),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Échec de l\'estimation de la production: $e')),
  //       );
  //     }
  //   }
  // }

  Future<void> _estimateProduction() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent, // Transparent background
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8, // Adjust the width as needed
            height: MediaQuery.of(context).size.height * 0.3, // Adjust the height to your preference
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white, // Background color
              borderRadius: BorderRadius.circular(10),
            ),
            child: LoadingWidget(
              title: "Estimation de la production",
              subtitle: "Veuillez patienter pendant que nous estimons la production...",
            ),
          ),
        );
      },
    );

    final Map<String, dynamic> requestData = {
      'timeFrame': _timeFrame,
      'value': _value,
    };

    if (_timeFrame == 'custom' && _startDate != null && _endDate != null) {
      requestData['startDate'] = _startDate!.toIso8601String();
      requestData['endDate'] = _endDate!.toIso8601String();
    }

    dynamic result;
    try {
      if (widget.livestockType == 'Poulets') {
        result = await _chickenService.estimateEggProductionForGroup(widget.group.id, requestData);
      } else if (widget.livestockType == 'Poissons') {
        result = await _fishService.estimatePriceForGroup(widget.group.id);
      } else if (widget.livestockType == 'Porcs') {
        result = await _pigService.estimatePriceForGroup(widget.group.id);
      }

      Navigator.pop(context); // Close the loading dialog

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EstimationResultScreen(
            livestockType: widget.livestockType,
            result: result,
            isSingleGroup: true,
          ),
        ),
      );
    } catch (e) {
      Navigator.pop(context); // Close the loading dialog

      if (e.toString().contains('Fish group not yet ready for sale') ||
          e.toString().contains('Pig group not yet ready for sale')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Groupe de ${widget.livestockType} pas encore prêt à la vente')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Échec de l\'estimation de la production: $e')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    String groupName = widget.group.name;
    // if (widget.livestockType == 'Poulets') {
    //   groupName = widget.group.title;
    // } else if (widget.livestockType == 'Poissons' || widget.livestockType == 'Porcs') {
    //   groupName = widget.group.name;
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Détails du groupe de ${widget.livestockType}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF285429),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                groupName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF285429),
                ),
              ),
            ),
            SizedBox(height: 20),
            Divider(),
            ListTile(
              title: Text('Nombre total', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF285429))),
              subtitle: Text('${widget.group.totalCount}'),
            ),
            // Divider(),
            // ListTile(
            //   title: Text('Consommation de nourriture', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF285429))),
            //   subtitle: Text('${widget.group.foodConsumption.sacks} sacs par mois à ${widget.group.foodConsumption.pricePerSack} FCFA par sac'),
            // ),
            Divider(),
            ListTile(
              title: Text('Date de naissance', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF285429))),
              subtitle: Text('${widget.group.birthDate.toLocal().toIso8601String().split('T')[0]}'),
            ),
            Divider(),
            ListTile(
              title: Text('Âge', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF285429))),
              subtitle: Text(calculateAge(widget.group.birthDate)),
            ),
            if (widget.livestockType == 'Porcs') ...[
              Divider(),
              ListTile(
                title: Text('Type', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF285429))),
                subtitle: Text('${widget.group.type}'),
              ),
            ],
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _isEligibleForEstimation ? () => _showEstimationModal(context) : null,
                child: Text('Estimer la production'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF285429),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            if (!_isEligibleForEstimation)
              Center(
                child: Text(
                  'Les poulets doivent avoir au moins 6 mois pour être éligibles à la ponte.',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}