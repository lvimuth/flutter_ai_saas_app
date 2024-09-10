import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ai_saas_app/constants/colors.dart';
import 'package:flutter_ai_saas_app/models/conversion_model.dart';
import 'package:flutter_ai_saas_app/services/store_conversion_firestore.dart';

class UserHistory extends StatelessWidget {
  const UserHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ConversionModel>>(
      stream: StoreConversionFirestore().getUsersConversions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text("Error:$snapshot.error"),
          );
        }

        final List<ConversionModel>? userConversion = snapshot.data;

        if (userConversion == null || userConversion.isEmpty) {
          return const Center(
            child: Text("No conversions found"),
          );
        }
        return ListView.builder(
          itemCount: userConversion.length,
          itemBuilder: (context, index) {
            final ConversionModel conversion = userConversion[index];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        conversion.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.broken_image,
                            size: 100,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            conversion.conversionData.length > 200
                                ? "${conversion.conversionData.substring(0, 200)}..."
                                : conversion.conversionData,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.copy,
                            color: mainColor,
                          ),
                          onPressed: () {
                            Clipboard.setData(
                                ClipboardData(text: conversion.conversionData));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Text copied to clipboard!'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Converted on: ${conversion.conversionDate.toLocal().toString().split('.')[0]}', //'Converted on: ${conversion.conversionDate.toLocal().toString().split(' ')[0]}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
