import 'package:cloudnottapp2/src/config/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddingFile extends StatefulWidget {
  const AddingFile({
    super.key,
    required this.titleAction,
    required this.acceptables,
    required this.iconAction,
    required this.onTapAction,
  });

  final String titleAction;
  final String acceptables;
  final Icon iconAction;
  final Function() onTapAction;

  @override
  State<AddingFile> createState() => _AddingFileState();
}

class _AddingFileState extends State<AddingFile> {
  bool _isHovered = false;
  bool _isTapped = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isTapped = true),
        onTapUp: (_) => setState(() => _isTapped = false),
        onTapCancel: () => setState(() => _isTapped = false),
        onTap: widget.onTapAction,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          margin: EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: _isTapped || _isHovered ? redShades[1] : whiteShades[1],
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: MediaQuery.of(context).size.width * 0.05,
            children: [
              widget.iconAction,
              // const SizedBox(width: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4.0,
                children: [
                  Text(
                    widget.titleAction,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    widget.acceptables,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.5),
                        ),
                  ),
                ],
              ),
              // const SizedBox(width: 8.0),
            ],
          ),
        ),
      ),
    );
  }
}
