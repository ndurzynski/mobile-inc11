import 'package:flutter/material.dart';

import 'success_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _dateController = TextEditingController();
  DateTime? _birthDate;
  String? _selectedCreatureType;
  bool _obscurePassword = true;
  bool _submitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting || !_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final creatureType = _selectedCreatureType!;
    FocusScope.of(context).unfocus();
    setState(() => _submitting = true);

    await Future<void>.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            SuccessScreen(userName: name, creatureType: creatureType),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Haunted Creature Registry'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Join the registry',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Complete this demo form to enter the creature registry.',
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final email = value?.trim() ?? '';

                        if (email.isEmpty) {
                          return 'Please enter your email';
                        }

                        if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                            .hasMatch(email)) {
                          return 'Please enter a valid email';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _dateController,
                      readOnly: true, // taps open the picker, not the keyboard
                      decoration: const InputDecoration(
                        labelText: 'Birth Date',
                        prefixIcon: Icon(Icons.cake),
                        border: OutlineInputBorder(),
                      ),
                      validator: (_) =>
                          _birthDate == null ? 'Pick your birth date' : null,
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2008),
                          firstDate: DateTime(1920),
                          lastDate: DateTime.now(), // no future birthdays!
                        );
                        if (!mounted) return;
                        if (picked != null) {
                          setState(() {
                            _birthDate = picked;
                            _dateController.text =
                                '${picked.month}/${picked.day}/${picked.year}';
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      autocorrect: false,
                      enableSuggestions: false,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }

                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedCreatureType,
                      decoration: const InputDecoration(
                        labelText: 'Creature Type',
                        border: OutlineInputBorder(),
                      ),
                      hint: const Text('Choose your creature'),
                      items: const [
                        DropdownMenuItem(value: 'Ghost', child: Text('Ghost')),
                        DropdownMenuItem(value: 'Bat', child: Text('Bat')),
                        DropdownMenuItem(
                          value: 'Black Cat',
                          child: Text('Black Cat'),
                        ),
                        DropdownMenuItem(
                          value: 'Pumpkin Spirit',
                          child: Text('Pumpkin Spirit'),
                        ),
                        DropdownMenuItem(value: 'Witch', child: Text('Witch')),
                      ],
                      onChanged: _submitting
                          ? null
                          : (value) {
                              setState(() => _selectedCreatureType = value);
                            },
                      validator: (value) => value == null
                          ? 'Please choose a creature type'
                          : null,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _submitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: _submitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Register Creature',
                              style: TextStyle(fontSize: 18),
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const SignupTipCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class SignupTipCard extends StatefulWidget {
  const SignupTipCard({super.key});

  @override
  State<SignupTipCard> createState() => _SignupTipCardState();
}

class _SignupTipCardState extends State<SignupTipCard> {
  static const _category = 'password_help';

  static const _tips = <String, List<String>>{
    'password_help': [
      'Choose a long password that you do not use for another account.',
      'A password manager can help you create and remember unique passwords.',
      'Avoid using your name, birthday, or other easy-to-guess information.',
    ],
  };

  bool _loading = false;
  bool _failNext = false;
  int _nextTip = 0;
  String? _tip;
  String? _error;

  Future<void> _getTip() async {
    if (_loading) return;

    final shouldFail = _failNext;

    setState(() {
      _loading = true;
      _failNext = false;
      _tip = null;
      _error = null;
    });

    await Future<void>.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    final choices = _tips[_category];

    setState(() {
      _loading = false;

      if (shouldFail) {
        _error = 'Simulated local error. Tap Retry to get a tip.';
      } else if (choices == null || choices.isEmpty) {
        _error = 'No preset tips available. Tap Retry to try again.';
      } else {
        _tip = choices[_nextTip % choices.length];
        _nextTip++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Signup Coach',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text('Preset demo tip—not live AI.'),
            const SizedBox(height: 8),
            const Text('General tips only. Your form is checked separately.'),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Simulate next tip error'),
              value: _failNext,
              onChanged: _loading
                  ? null
                  : (value) {
                      setState(() => _failNext = value ?? false);
                    },
            ),
            ElevatedButton(
              onPressed: _loading ? null : _getTip,
              child: Text(_error == null ? 'Get a signup tip' : 'Retry'),
            ),
            if (_loading) ...[
              const SizedBox(height: 12),
              const LinearProgressIndicator(),
              const Text('Loading preset tip...'),
            ],
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            if (_tip != null) ...[const SizedBox(height: 12), Text(_tip!)],
          ],
        ),
      ),
    );
  }
}
