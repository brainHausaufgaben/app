import 'package:flutter/material.dart';

class ImagePage extends StatelessWidget{
  const ImagePage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    String? data = ModalRoute.of(context)!.settings.arguments as String?;
    return GestureDetector(
      child: Scaffold(
        body: Flex(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child:Image.asset(data!,fit: BoxFit.cover),
            )
          ]
        )
      ),
      onTap: () => Navigator.pop(context),
    );
  }}