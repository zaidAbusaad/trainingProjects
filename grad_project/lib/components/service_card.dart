import 'package:flutter/material.dart';
import 'package:grad_project/models/service_card_model.dart';
import 'package:grad_project/screensWorkers/requests_screen_worker.dart';


import '../screensCutomers/request_screen.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({super.key, required this.field, required this.isWorker});
  final bool isWorker;

  final ServiceCardModel field;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {

        if(isWorker){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RequestsScreenWorker(field: field,)),
          );
        }else{
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RequestScreen(field: field,)),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: screenHeight * 0.23,
          width: screenWidth * 0.46,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(2, 2),
                  blurRadius: 7,
                )
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon(field.fieldIcon,color: Colors.blue,),
              field.fieldIcon,
              Text(field.fieldName),
            ],
          ),
        ),
      ),
    );
  }
}
