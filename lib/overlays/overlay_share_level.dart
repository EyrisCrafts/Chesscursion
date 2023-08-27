import 'package:chesscursion_creator/config/constants.dart';
import 'package:flutter/material.dart';

class OverlayShareLevel extends StatefulWidget {
  const OverlayShareLevel({super.key});

  @override
  State<OverlayShareLevel> createState() => _OverlayShareLevelState();
}

class _OverlayShareLevelState extends State<OverlayShareLevel> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.7),
          child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Confirm", style: TextStyle(fontFamily: "Marko One", fontSize: 16, color: Constants.cellColorDark)),
                  const Text("Are you ready to share the level with the community?", style: TextStyle(fontFamily: "Marko One", fontSize: 13, color: Constants.cellColorDark)),
                  const SizedBox(
                    height: 20,
                  ),
                  // Input field for title
                  TextFormField(
                    maxLength: 40,
                    controller: _titleController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      if (value.length < 3) {
                        return 'Please enter a longer title';
                      }
                      
                      if (value.length > 40) {
                        return 'Max 40 characters';
                      }

                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Write a fun name for the level",
                      labelStyle: TextStyle(fontFamily: "Marko One", fontSize: 13, color: Constants.cellColorDark),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Constants.cellColorLight, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Constants.cellColorLight, width: 1.0),
                      ),
                      isDense: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Constants.cellColorDark, width: 1.0),
                      ),
                    ),
                    style: const TextStyle(fontFamily: "Marko One", fontSize: 13, color: Constants.cellColorDark),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            color: Constants.cellColorDark,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text("Cancel", style: TextStyle(fontFamily: "Marko One", fontSize: 13, color: Colors.white)),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.of(context).pop(_titleController.text);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            color: Constants.colorSecondary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text("Share", style: TextStyle(fontFamily: "Marko One", fontSize: 13, color: Colors.white)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
