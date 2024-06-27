import 'package:chapa_tu_bus_app/account_management/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RetrySectionWidget extends StatelessWidget {
  final AuthState state;
  const RetrySectionWidget({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Error: ${state.toString()}'
          ),
          ButtonBar(
            children: [
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(AuthCheckRequested());
                },
                child: const Text('Retry'),
              ),
            ],
          
          ),
        ]
      ),
    );
  }
}