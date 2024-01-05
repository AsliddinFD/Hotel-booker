import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/theme_provider.dart';
import 'package:frontend/utils/functions.dart';

class Switcher extends ConsumerStatefulWidget {
  const Switcher({super.key});

  @override
  ConsumerState<Switcher> createState() => _SwitcherState();
}

class _SwitcherState extends ConsumerState<Switcher> {
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoSwitch(
            value: switchVal,
            onChanged: (newVal) {
              ref.read(themeProvider.notifier).toggleTheme();
              setState(() {
                switchVal = newVal;
              });
            })
        : Switch(
            value: switchVal,
            onChanged: (newVal) {
              ref.read(themeProvider.notifier).toggleTheme();
              setState(() {
                switchVal = newVal;
              });
            },
          );
  }
}
