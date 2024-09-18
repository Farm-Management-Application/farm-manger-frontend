import 'package:flutter/material.dart';
import '../services/statistics_service.dart';
import '../widgets/loading_widget.dart';

class StatisticsScreen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final StatisticsService _statisticsService = StatisticsService();
  bool isLoading = true;
  int totalLivestock = 0;
  double averageSalary = 0.0;
  int numberOfWorkers = 0;
  int illnessImpactAffected = 0;
  int illnessImpactCost = 0;

  @override
  void initState() {
    super.initState();
    _fetchStatistics();
  }

  Future<void> _fetchStatistics() async {
    try {
      final livestockCount = await _statisticsService.getTotalLivestockCount();
      final salaryData = await _statisticsService.getAverageSalary();
      final impact = await _statisticsService.getIllnessImpact();

      setState(() {
        totalLivestock = livestockCount;
        averageSalary = salaryData['avgSalary'] ?? 0.0;
        numberOfWorkers = salaryData['numberOfWorkers'] ?? 0;
        illnessImpactAffected = impact['totalAffected'] ?? 0;
        illnessImpactCost = impact['totalCost'] ?? 0;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching statistics: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Estimation et Analyse',
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
      body: isLoading
          ? LoadingWidget(title: "Récupération de données", subtitle: "S'il vous plaît, attendez...")
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Statistiques Agricoles',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFAA625),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildWorkersCard(),
                  SizedBox(height: 20),
                  _buildIllnessImpactCard(),
                ],
              ),
            ),
    );
  }

  Widget _buildWorkersCard() {
    return Card(
      color: Color(0xFFEAF1EA),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.work, color: Color(0xFFFAA625), size: 30),
              title: Text(
                'Impact des travailleurs',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF285429)),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Salaire moyen : ${averageSalary.toStringAsFixed(2)} FCFA',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF285429)),
            ),
            SizedBox(height: 10),
            Text(
              'Nombre de travailleurs : ${numberOfWorkers.toString()} travailleurs',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF285429)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIllnessImpactCard() {
    return Card(
      color: Color(0xFFEAF1EA),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.healing, color: Color(0xFFFAA625), size: 30),
              title: Text(
                'Impact des maladies',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF285429)),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Nombre total betail touchés: $illnessImpactAffected betails',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF285429)),
            ),
            SizedBox(height: 10),
            Text(
              'Coût total du traitement: $illnessImpactCost FCFA',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF285429)),
            ),
          ],
        ),
      ),
    );
  }
}