import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram/resources/firestore_methods.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key , required this.onTapFunction, required this.buttonText});
  final Future<void> Function(BuildContext) onTapFunction;
  final String buttonText;
  @override
  Widget build(BuildContext context) {
    return InkWell(
              onTap: () async {
                await onTapFunction(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Text(buttonText),
              ),
            );
  }
}