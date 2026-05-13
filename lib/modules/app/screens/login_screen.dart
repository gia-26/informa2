import 'package:flutter/material.dart';
import 'package:informa2/helpers/constants/constants.dart';
import 'package:informa2/modules/app/provider/auth_provider.dart';
import 'package:informa2/modules/app/screens/home_screen.dart';
import 'package:provider/provider.dart';

// --- WIDGET REUTILIZABLE PARA INPUTS ESTILIZADOS ---
Widget _buildInputField({
  required TextEditingController controller,
  required String hint,
  required IconData icon,
  bool isPassword = false,
  TextInputType type = TextInputType.text,
}) {
  return Container(
    width: 350,
    margin: const EdgeInsets.symmetric(vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.05),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white.withOpacity(0.1)),
    ),
    child: TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: type,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        border: InputBorder.none,
        prefixIcon: Icon(icon, color: secundaryColor, size: 20),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 15),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
      ),
    ),
  );
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProviderApp>();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: LayoutBuilder( // Clave para centrado perfecto
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Centrado Vertical
                    crossAxisAlignment: CrossAxisAlignment.center, // Centrado Horizontal
                    children: [
                      const Spacer(),
                      
                      // Icono Minimalista
                      Container(
                        height: 80, width: 80,
                        decoration: BoxDecoration(
                          color: secundaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(color: secundaryColor.withOpacity(0.2)),
                        ),
                        child: const Icon(Icons.bubble_chart_rounded, size: 40, color: secundaryColor),
                      ),
                      const SizedBox(height: 24),
                      
                      const Text(
                        'Informa2',
                        style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 1),
                      ),
                      Text(
                        'Informate de tu alrededor',
                        style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 16),
                      ),
                      const SizedBox(height: 50),

                      _buildInputField(
                        controller: _emailController,
                        hint: 'Correo electrónico',
                        icon: Icons.alternate_email_rounded,
                        type: TextInputType.emailAddress,
                      ),
                      _buildInputField(
                        controller: _passwordController,
                        hint: 'Contraseña',
                        icon: Icons.lock_outline_rounded,
                        isPassword: true,
                      ),
                      
                      const SizedBox(height: 30),

                      // BOTÓN PRINCIPAL
                      SizedBox(
                        width: 350,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: authProvider.isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: secundaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          child: authProvider.isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('Entrar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ),

                      const Spacer(), // Empuja el texto inferior al final

                      TextButton(
                        onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RegisterScreen())),
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(color: Colors.white54, fontSize: 14),
                            children: [
                              TextSpan(text: "¿No tienes cuenta? "),
                              TextSpan(
                                text: "Regístrate",
                                style: TextStyle(color: secundaryColor, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _login() async {
    final authProvider = context.read<AuthProviderApp>();
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Por favor, completa todos los campos")));
        return;
      }
      await authProvider.login(email, password);
      
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(authProvider.errorMessage)));
    }
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProviderApp>();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      const Text(
                        'Crear Cuenta',
                        style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Completa tus datos para empezar',
                        style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 16),
                      ),
                      const SizedBox(height: 40),

                      _buildInputField(
                        controller: _nameController,
                        hint: 'Nombre completo',
                        icon: Icons.person_outline_rounded,
                      ),
                      _buildInputField(
                        controller: _emailController,
                        hint: 'Email',
                        icon: Icons.email_outlined,
                        type: TextInputType.emailAddress,
                      ),
                      _buildInputField(
                        controller: _passwordController,
                        hint: 'Contraseña',
                        icon: Icons.lock_open_rounded,
                        isPassword: true,
                      ),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: 350,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: authProvider.isLoading ? null : _registerLogic,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: secundaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          child: authProvider.isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('Registrarme', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen())),
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(color: Colors.white54, fontSize: 14),
                            children: [
                              TextSpan(text: "¿Ya eres miembro? "),
                              TextSpan(
                                text: "Inicia sesión",
                                style: TextStyle(color: secundaryColor, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _registerLogic() async {
    final authProvider = context.read<AuthProviderApp>();
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final name = _nameController.text.trim();

      if (email.isEmpty || password.isEmpty || name.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Por favor, completa todos los campos")));
        return;
      }

      await authProvider.registrarUsuario(email, password, name);
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(authProvider.errorMessage)));
    }
  }
}