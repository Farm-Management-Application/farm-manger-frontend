// lib/screens/detail_screen.dart
import 'package:flutter/material.dart';
import '../services/chicken_service.dart';
import '../services/fish_service.dart';
import '../services/pig_service.dart';
import '../models/chicken.dart';
import '../models/fish.dart';
import '../models/pig.dart';
import 'estimation_result_screen.dart';
import '../utils/utilFunctions.dart';

class DetailScreen extends StatefulWidget {
  final String livestockType;

  DetailScreen({required this.livestockType});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final ChickenService _chickenService = ChickenService();
  final FishService _fishService = FishService();
  final PigService _pigService = PigService();

  late Future<List<dynamic>> _livestockGroupsFuture;
  String _timeFrame = 'month'; // English value for backend
  String _timeFrameDisplay = 'mois'; // French value for display
  int _value = 1;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _showCustomDatePickers = false;

  @override
  void initState() {
    super.initState();
    _livestockGroupsFuture = _fetchData();
  }

  Future<List<dynamic>> _fetchData() async {
    try {
      if (widget.livestockType == 'Poulets') {
        return await _chickenService.getAllChickenGroups();
      } else if (widget.livestockType == 'Poissons') {
        return await _fishService.getAllFishGroups();
      } else if (widget.livestockType == 'Porcs') {
        return await _pigService.getAllPigGroups();
      } else {
        throw Exception('Type de bétail inconnu');
      }
    } catch (e) {
      print('Erreur lors de la récupération des données: $e');
      throw e;
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        if (_endDate != null && _endDate!.isBefore(_startDate!)) {
          _endDate = null;
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  void _showEstimationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
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
                        'Estimer la Production pour Tous les Groupes de Poulets',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF285429),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Cela calcule la production d\'œufs pour tous les groupes de poulets pour la période sélectionnée, en s\'assurant que les poulets sont en âge de pondre, en estimant le prix total de tous les plateaux d\'œufs produits et le profit lorsque la consommation de sacs est déduite.',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: DropdownButtonFormField<String>(
                          value: _timeFrameDisplay,
                          decoration: InputDecoration(
                            labelText: 'Période',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              _timeFrameDisplay = newValue!;
                              _showCustomDatePickers = _timeFrameDisplay == 'personnalisé';
                              _timeFrame = _getTimeFrameValue(newValue);
                            });
                          },
                          items: <String>['mois', 'semaine', 'personnalisé']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      if (!_showCustomDatePickers)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Valeur',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
                            "Début: ${_startDate != null ? _startDate!.toLocal().toIso8601String().split('T')[0] : 'Sélectionner'}",
                            style: TextStyle(color: Color(0xFF285429)),
                          ),
                          trailing: Icon(Icons.calendar_today, color: Color(0xFF285429)),
                          onTap: () => _selectStartDate(context),
                        ),
                        ListTile(
                          title: Text(
                            "Fin: ${_endDate != null ? _endDate!.toLocal().toIso8601String().split('T')[0] : 'Sélectionner'}",
                            style: TextStyle(color: Color(0xFF285429)),
                          ),
                          trailing: Icon(Icons.calendar_today, color: Color(0xFF285429)),
                          onTap: () => _selectEndDate(context),
                        ),
                      ],
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _estimateProductionForAll();
                          },
                          child: Text('Confirmer'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF285429),
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  String _getTimeFrameValue(String displayValue) {
    switch (displayValue) {
      case 'mois':
        return 'month';
      case 'semaine':
        return 'week';
      case 'personnalisé':
        return 'custom';
      default:
        return 'month';
    }
  }

  Future<void> _estimateProductionForAll() async {
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
        result = await _chickenService.estimateEggProductionForAll(requestData);
      } else if (widget.livestockType == 'Poissons') {
        result = await _fishService.estimatePriceForAll();
      } else if (widget.livestockType == 'Porcs') {
        result = await _pigService.estimatePriceForAll();
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EstimationResultScreen(
            livestockType: widget.livestockType,
            result: result,
            isSingleGroup: false,
          ),
        ),
      );
    } catch (e) {
      if (e.toString().contains('Fish group not yet ready for sale') ||
          e.toString().contains('Pig group not yet ready for sale')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Le groupe de ${widget.livestockType} n\'est pas encore prêt à être vendu')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Échec de l\'estimation de la production pour tous les groupes: $e')),
        );
      }
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        'Détails ${widget.livestockType}',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      backgroundColor: Color(0xFF285429),
      centerTitle: true,
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder<List<dynamic>>(
        future: _livestockGroupsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erreur lors de la récupération des données: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'Aucune donnée disponible',
                style: TextStyle(color: Color(0xFF285429)),
              ),
            );
          } else {
            final livestockGroups = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: livestockGroups.length,
                    itemBuilder: (context, index) {
                      var group = livestockGroups[index];
                      String groupName = widget.livestockType == 'Poulets'
                          ? group.title
                          : group.name;
                      return Card(
                        margin: EdgeInsets.all(10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        child: ListTile(
                          title: Text(
                            groupName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF285429),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Nombre total: ${group.totalCount}'),
                              if (widget.livestockType == 'Porcs' || widget.livestockType == 'Poissons')
                                Text('Type: ${group.type}'),
                              Text('Âge: ${calculateAge(group.birthDate)}'),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.edit, color: Color(0xFF285429), size: 20),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/editGroup',
                                arguments: {
                                  'group': group,
                                  'livestockType': widget.livestockType
                                },
                              ).then((result) {
                                if (result == true) {
                                  setState(() {
                                    _livestockGroupsFuture = _fetchData();
                                  });
                                }
                              });
                            },
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/groupDetail',
                              arguments: {
                                'group': group,
                                'livestockType': widget.livestockType
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    ),
    floatingActionButton: Stack(
      children: [
        Positioned(
          bottom: 80,
          right: 16,
          child: FloatingActionButton(
            heroTag: 'estimate',
            onPressed: () {
              if (widget.livestockType == 'Poulets') {
                _showEstimationDialog(context);
              } else {
                _estimateProductionForAll();
              }
            },
            child: Icon(Icons.assessment, color: Color(0xFFFAA625)),
            backgroundColor: Color(0xFF285429),
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            heroTag: 'create',
            onPressed: () async {
              final result = await Navigator.pushNamed(
                context,
                '/createGroup',
                arguments: {'livestockType': widget.livestockType},
              );
              if (result == true) {
                setState(() {
                  _livestockGroupsFuture = _fetchData();
                });
              }
            },
            child: Icon(Icons.add, color: Color(0xFFFAA625)),
            backgroundColor: Color(0xFF285429),
          ),
        ),
      ],
    ),
  );
}
}