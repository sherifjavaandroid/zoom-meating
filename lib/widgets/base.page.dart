import 'package:flutter/material.dart';

import 'package:line_icons/line_icons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class BasePage extends StatefulWidget {
  final bool showAppBar;
  final bool showLeadingAction;
  final String title;
  final Widget body;
  const BasePage({
    this.showAppBar = false,
    this.showLeadingAction = false,
    this.title = "",
    required this.body,
    Key? key,
  }) : super(key: key);

  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: translator.isDirectionRTL(context)
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: widget.showAppBar
            ? AppBar(
                automaticallyImplyLeading: widget.showLeadingAction,
                leading: widget.showLeadingAction
                    ? IconButton(
                        icon: const Icon(
                          LineIcons.arrowLeft,
                        ),
                        onPressed: () => Navigator.pop(context),
                      )
                    : null,
                title: Text(
                  widget.title,
                ),
              )
            : null,
        body: widget.body,
      ),
    );
  }
}
