import 'package:chapa_tu_bus_app/account_management/presentation/blocs/auth/auth_bloc.dart';
import 'package:chapa_tu_bus_app/account_management/presentation/widgets/auth/my_button.dart';
import 'package:chapa_tu_bus_app/account_management/presentation/widgets/auth/my_text_field.dart';
import 'package:chapa_tu_bus_app/account_management/presentation/widgets/auth/square_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.onTap});
  final Function()? onTap;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _signUpWithEmailAndPassword() {
    if (_formKey.currentState!.validate()) {
      if (passwordController.text == confirmPasswordController.text) {
        context.read<AuthBloc>().add(RegisterBackendRequested(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          role: 'ROLE_USER', 
          firstName: firstNameController.text.trim(), 
          lastName: lastNameController.text.trim(),
        ));
      } else {
        _showErrorMessage('Las contraseñas no coinciden');
      }
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          _showErrorMessage(state.message);
        } else if (state is AuthSuccess) {
          
          Navigator.pushReplacementNamed(context, '/loading');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 5),

                    // Logo
                    Stack(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const ShapeDecoration(
                            color: Color(0xFF556BDA),
                            shape: OvalBorder(),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.directions_bus,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // Let's create an account text
                    const Text(
                      'Let\'s create an account!',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Name textfield
                    MyTextField(
                      controller: firstNameController,
                      hintText: 'Name',
                      obscureText: false,
                    ),

                    const SizedBox(height: 10),

                    // Last name textfield
                    MyTextField(
                      controller: lastNameController,
                      hintText: 'Last name',
                      obscureText: false,
                    ),

                    const SizedBox(height: 10),

                    // Email textfield
                    MyTextField(
                      controller: emailController,
                      hintText: 'Email',
                      obscureText: false,
                    ),

                    const SizedBox(height: 10),

                    // Password textfield
                    MyTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true,
                    ),

                    const SizedBox(height: 10),

                    // Confirm password textfield
                    MyTextField(
                      controller: confirmPasswordController,
                      hintText: 'Confirm password',
                      obscureText: true,
                    ),

                    const SizedBox(height: 25),

                    // Register button
                    MyButton(
                      text: 'Register',
                      onTap: _signUpWithEmailAndPassword,
                    ),

                    const SizedBox(height: 25),

                    // Or continue with
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey[400],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'Or continue with',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Google sign in button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SquareTile(
                          onTap: () {
                            context.read<AuthBloc>().add(SignInWithGoogleRequested());
                          },
                          imagePath: 'assets/images/google.png',
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // Already have an account? Log in now
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account?',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            'Log in',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}