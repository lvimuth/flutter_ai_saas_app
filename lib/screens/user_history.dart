import 'package:flutter/material.dart';
import 'package:flutter_ai_saas_app/provider/premium_provider.dart';
import 'package:flutter_ai_saas_app/widgets/show_premium.dart';
import 'package:flutter_ai_saas_app/widgets/user_history.dart';
import 'package:provider/provider.dart';

class HistoryConversions extends StatelessWidget {
  const HistoryConversions({super.key});

  @override
  Widget build(BuildContext context) {
    final isPremiumProvider = Provider.of<PremiumProvider>(context);

    // Check if the premium status is not loaded yet
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isPremiumProvider.checkPremiumStatus();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('History Conversions',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            )),
      ),
      body: isPremiumProvider.isPremium
          ? const UserHistoryWidget()
          : ShowPremiumPannel(),
    );
  }
}
