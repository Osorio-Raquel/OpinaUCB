import 'package:flutter/material.dart';
import 'admin_screen.dart';
import 'user_screen.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    setState(() => _isLoading = true);
    
    // Simular proceso de autenticación
    await Future.delayed(const Duration(seconds: 2));
    
    // Verificar si el widget todavía está montado antes de actualizar el estado
    if (!mounted) return;
    
    setState(() => _isLoading = false);
    
    // Navegar a la pantalla correspondiente según el tipo de usuario
    if (_emailController.text.contains('admin')) {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => const AdminScreen())
      );
    } else {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => const UserScreen())
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'LOGIN',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            CustomTextField(
              controller: _emailController,
              labelText: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: _passwordController,
              labelText: 'Password',
              obscureText: true,
            ),
            const SizedBox(height: 30),
            CustomButton(
              text: 'SIGN IN',
              onPressed: _login,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {},
              child: const Text('Forgot password?'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () {},
                  child: const Text('Sign up'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}