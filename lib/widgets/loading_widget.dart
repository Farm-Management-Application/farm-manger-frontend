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
        crossAxisAlignment: CrossAxisAlignment.center, // Ensure the text is centered
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center, // Center align the title text
          ),
          SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(fontSize: 18, color: Colors.grey),
            textAlign: TextAlign.center, // Center align the subtitle text
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