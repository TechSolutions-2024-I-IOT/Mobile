import 'dart:io';


import 'package:chapa_tu_bus_app/account_management/domain/entities/user.dart';
import 'package:chapa_tu_bus_app/account_management/presentation/blocs/settings/settings_bloc.dart';
import 'package:chapa_tu_bus_app/account_management/presentation/widgets/auth/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class SettingsView extends StatefulWidget {
  static const name = 'ProfileConfiguration';
  static String getViewName() => name;
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  String? _selectedImagePath;

  @override
  void initState() {
    super.initState();
    context.read<SettingsBloc>().add(SettingsLoadRequested());
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _updateProfile(User user) {
    if (_formKey.currentState!.validate()) {
      context.read<SettingsBloc>().add(SettingsUpdateRequested(
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            photoURL: _selectedImagePath,
          ));
    }
  }

  Future<void> _getImage() async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      final imageBytes = await image.readAsBytes();
      final tempFile = File.fromRawPath(imageBytes);
      context.read<SettingsBloc>().add(SettingsImagePicked(imagePath: tempFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state is SettingsUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Perfil actualizado con éxito')),
          );
        } else if (state is SettingsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is SettingsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SettingsLoaded) {
          final user = state.user;
          final isNotFirebase = user.role == 'ROLE_USER';

          print('User: $user');
          print('User role: ${user.role}');
          print('$isNotFirebase');

          _firstNameController.text = user.firstName ?? '';
          _lastNameController.text = user.lastName ?? '';
          _emailController.text = user.email;
          _nameController.text = user.name ?? '';
          _selectedImagePath = user.photoURL;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.grey),
                onPressed: () {
                  context.go('/home/3');
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: _selectedImagePath != null
                                  ? FileImage(File(_selectedImagePath!)) as ImageProvider
                                  : const NetworkImage(
                                      'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgQrn0h8YlouX1uYeAHOjVV_1zOiEzM0Q_Ftq_kDVXy8XUJVc2bLiMCHa6-hYHGBKHswAnzu6McRzACcS7kAwtq0Q8f-2vzFpOtBmnMGs9M7a5avCRCGuyMzRRUOGHLTNxlzQ1WcwgmM6xhJ-_3GycyKrQstuDFIVisogfV9FaYpaJzfciWLj8B1VOxlfA/s1600/Ellipse%2049.png'),
                            ),
                            IconButton(
                              onPressed: _getImage,
                              icon: const Icon(Icons.edit, size: 20),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (isNotFirebase)...[
                        TextFormField(
                          initialValue: user.firstName,
                          decoration: const InputDecoration(labelText: 'Name'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 16),
                        TextFormField(
                          initialValue: user.lastName,
                          decoration: const InputDecoration(labelText: 'Last Name'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your last name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          initialValue: user.email,
                          decoration: const InputDecoration(labelText: 'Email'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
                        MyButton(
                          text: 'Save Changes',
                          onTap: () => _updateProfile(user),
                        ),
                      
                      ],
                      if (!isNotFirebase)...[
                        TextFormField(
                          initialValue: user.name,
                          decoration: const InputDecoration(labelText: 'Name'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          initialValue: user.email,
                          decoration: const InputDecoration(labelText: 'Email'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
                        MyButton(
                          text: 'Save Changes',
                          onTap: () => _updateProfile(user),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        } else if (state is SettingsError) {
          return Center(child: Text(state.message));
        } else {
          return const SizedBox();
        }
      },
    );
  }
}