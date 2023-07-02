import 'package:aro_monitoring/presentation/data/widgets/table_headers.dart';
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
    const padding = 8.0;
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
                  padding: const EdgeInsets.symmetric(horizontal: padding),
                  child: TextFormField(
                    decoration: InputDecoration(
                      // icon: const Icon(Icons.person),
                      hintText: 'The number',
                      labelText: tableHeaders[0].text,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: padding),
                  child: TextFormField(
                    decoration: InputDecoration(
                      // icon: const Icon(Icons.person),
                      hintText: 'The number',
                      labelText: tableHeaders[1].text,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: padding),
                  child: TextFormField(
                    decoration: InputDecoration(
                      // icon: const Icon(Icons.person),
                      hintText: 'The number',
                      labelText: tableHeaders[2].text,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: padding),
                  child: TextFormField(
                    decoration: InputDecoration(
                      // icon: const Icon(Icons.person),
                      hintText: 'The number',
                      labelText: tableHeaders[3].text,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: padding),
                  child: TextFormField(
                    decoration: InputDecoration(
                      // icon: const Icon(Icons.person),
                      hintText: 'The number',
                      labelText: tableHeaders[4].text,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: padding),
                  child: TextFormField(
                    decoration: InputDecoration(
                      // icon: const Icon(Icons.person),
                      hintText: 'The number',
                      labelText: tableHeaders[5].text,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: padding),
                  child: TextFormField(
                    decoration: InputDecoration(
                      // icon: const Icon(Icons.person),
                      hintText: 'The number',
                      labelText: tableHeaders[6].text,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: padding),
                  child: TextFormField(
                    decoration: InputDecoration(
                      // icon: const Icon(Icons.person),
                      hintText: 'The number',
                      labelText: tableHeaders[7].text,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: padding, vertical: padding),
                  child: TextButton(
                    child: const Text("Submitß"),
                    onPressed: () {
                      final formKeyCurrentState = _formKey.currentState;
                      if (formKeyCurrentState != null) {
                        if (formKeyCurrentState.validate()) {
                          formKeyCurrentState.save();
                        }
                      }
                      Navigator.of(context).pop();
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