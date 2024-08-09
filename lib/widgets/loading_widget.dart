import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final String title;
  final String subtitle;

  LoadingWidget({this.title = "Please Wait", this.subtitle = "Loading..."});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 24),
          CircularProgressIndicator(
            strokeWidth: 6.0,  // Makes the animation larger
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}