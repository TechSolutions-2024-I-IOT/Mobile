import 'package:chapa_tu_bus_app/account_management/presentation/blocs/auth/auth_bloc.dart';
import 'package:chapa_tu_bus_app/account_management/presentation/screens/auth/login_or_register_screen.dart';
import 'package:chapa_tu_bus_app/account_management/presentation/widgets/auth/retry_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthCheckRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          print('Authenticated user: $state');
          context.go('/loading');
        }
      },
      child: Scaffold(
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            print('Auth state: $state');
            if (state is AuthLoading) {
             
              return const Center(child: CircularProgressIndicator());
            } else if (state is UnAuthenticated) {
              
              return const LogInOrRegisterScreen();
            } else if (state is AuthError) {
              
              return RetrySectionWidget(state: state);
            } else {
              
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}

