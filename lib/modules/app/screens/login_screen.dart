import 'package:flutter/material.dart';
import 'package:informa2/modules/app/provider/auth_provider.dart';
import 'package:informa2/modules/app/screens/home_screen.dart';
import 'package:provider/provider.dart';

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
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.secondary,
      fontWeight: FontWeight.bold,
      fontFamily: 'Roboto',
    );
    final authProvider = context.watch<AuthProviderApp>();

    return Scaffold(
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(45),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Text('Iniciar sesión', style: style),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: SizedBox(
                    width: 350,
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: SizedBox(
                    width: 350,
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: authProvider.isLoading 
                    ? null 
                    : () async {
                        try {
                          final email = _emailController.text.trim();
                          final password = _passwordController.text.trim();
        
                          await authProvider.login(email, password);
        
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Inicio de sesión exitoso"))
                          );
        
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                        } catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(authProvider.errorMessage))
                          );
                        }
                      },
                  child: authProvider.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Iniciar sesión'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    '¿No estás registrado? Crea una cuenta',
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.secondary,
      fontWeight: FontWeight.bold,
      fontFamily: 'Roboto',
    );
    final authProvider = context.watch<AuthProviderApp>();

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(45),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Text('Regístrate', style: style),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: SizedBox(
                  width: 350,
                  child: TextField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nombre completo',
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: SizedBox(
                  width: 350,
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: SizedBox(
                  width: 350,
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Contraseña',
                    ),
                  ),
                ),
              ),

              ElevatedButton(
                onPressed: authProvider.isLoading ? null : () async {
                  try {
                    final name = _nameController.text.trim();
                    final email = _emailController.text.trim();
                    final password = _passwordController.text.trim();

                    await authProvider.registrarUsuario(email, password, name);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Bienvenido $name"))
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(authProvider.errorMessage))
                    );
                  }
                }, 
                child: authProvider.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Crear cuenta'),
              ),

              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text(
                  '¿Ya tienes cuenta? Inicia sesión',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
