import 'package:flutter/material.dart';

class NewEventDialog extends StatefulWidget {
  final GlobalKey<FormState> _formKey;
  const NewEventDialog({
    super.key,
    required GlobalKey<FormState> formKey,
  }) : 
    _formKey = formKey;
  ///
  @override
  State<NewEventDialog> createState() => _NewEventDialogState(
    formKey: _formKey,
  );
}

class _NewEventDialogState extends State<NewEventDialog> {
  final GlobalKey<FormState> _formKey;
  ///
  _NewEventDialogState({
    required GlobalKey<FormState> formKey,

  }) :
    _formKey = formKey;
  ///
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Stack(
        clipBehavior: Clip.none, children: <Widget>[
          Positioned(
            right: -40.0,
            top: -40.0,
            child: InkResponse(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const CircleAvatar(
                backgroundColor: Colors.red,
                child: Icon(Icons.close),
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    child: const Text("Submitß"),
                    onPressed: () {
                      final formKeyCurrentState = _formKey.currentState;
                      if (formKeyCurrentState != null) {
                        if (formKeyCurrentState.validate()) {
                          formKeyCurrentState.save();
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}