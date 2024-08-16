import 'package:flutter/material.dart';
import '../services/chicken_service.dart';
import '../services/fish_service.dart';
import '../services/pig_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/loading_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ChickenService _chickenService = ChickenService();
  final FishService _fishService = FishService();
  final PigService _pigService = PigService();

  int totalChickens = 0;
  int totalFish = 0;
  int totalPigs = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      int chickens = await _chickenService.getTotalChickenCount();
      int fish = await _fishService.getTotalFishCount();
      int pigs = await _pigService.getTotalPigCount();

      setState(() {
        totalChickens = chickens;
        totalFish = fish;
        totalPigs = pigs;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
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
          'Gestion de la Ferme',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF285429),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF285429),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.group),
              title: Text('Workers'),
              onTap: () {
                Navigator.pushNamed(context, '/workerList');
              },
            ),
            ListTile(
              leading: Icon(Icons.healing),
              title: Text('Illnesses'),
              onTap: () {
                Navigator.pushNamed(context, '/illnesses');
              },
            ),
            ListTile(
              leading: Icon(Icons.analytics),
              title: Text('Estimation & Analytics'),
              onTap: () {
                Navigator.pushNamed(context, '/estimations');
              },
            ),
          ],
        ),
      ),
      body: isLoading
          ? LoadingWidget(
              title: "Récupération des données",
              subtitle: "Veuillez patienter !",
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total du Bétail',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFAA625),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildStatisticCard('Poulets', totalChickens, '/detail', 'Poulets', Icons.egg),
                  SizedBox(height: 20),
                  _buildStatisticCard('Poissons', totalFish, '/detail', 'Poissons', FontAwesomeIcons.fish),
                  SizedBox(height: 20),
                  _buildStatisticCard('Porcs', totalPigs, '/detail', 'Porcs', FontAwesomeIcons.piggyBank),
                ],
              ),
            ),
    );
  }

  Widget _buildStatisticCard(String title, int count, String route, String livestockType, IconData icon) {
    return Card(
      color: Color(0xFFEAF1EA),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: ListTile(
          leading: Icon(icon, color: Color(0xFFFAA625), size: 40),
          title: Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF285429)),
          ),
          trailing: Text(
            count.toString(),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF285429)),
          ),
          onTap: () {
            Navigator.pushNamed(context, route, arguments: {'livestockType': livestockType});
          },
        ),
      ),
    );
  }
}
