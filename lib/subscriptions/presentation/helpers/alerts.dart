part of 'helpers.dart';

mostrarLoading( BuildContext context ) {

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: ( _ ) => const AlertDialog(
      title: Text('Wait...'),
      content: LinearProgressIndicator(),
    )
  );

}

mostrarAlerta( BuildContext context, String title, String message ) {

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: ( _ ) => AlertDialog(
      title: Text( title ),
      content: Text( message ),
      actions: [
        MaterialButton(
          child: const Text('Ok'),
          onPressed: () => Navigator.of(context).pop()
        )
      ],
    )
  );

}