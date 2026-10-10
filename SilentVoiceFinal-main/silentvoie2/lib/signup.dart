// ignore_for_file: deprecated_member_use, unused_local_variable
import '/homepage.dart';
import 'login.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Map<String, String?> fieldErrors = {
    'username': null,
    'email': null,
    'mobile': null,
    'password': null,
  };
  Timer? _debounce;
  bool _isLoading = false;
  final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  double _initialScrollOffset = 0.0;
  bool _keyboardVisible = false;

  Future<bool> checkEmailExists(String email) async {
    final supabase = Supabase.instance.client;
    try {
      final response = await supabase
          .from('User_data')
          .select('email')
          .eq('email', email)
          .timeout(const Duration(seconds: 5));
      return response.isNotEmpty;
    } catch (e) {
      print("Error checking email: $e");
      return false;
    }
  }

  Future<void> addUser({
    required String email,
    required String mobileNo,
    required String password,
    required String username,
  }) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final supabase = Supabase.instance.client;

    try {
      bool emailExists = await checkEmailExists(email);
      if (emailExists) {
        setState(() {
          fieldErrors['email'] = 'Email is already registered, use another one';
        });
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('username', username);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home_screen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error creating account: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkLoginStatus();

    emailController.addListener(() => _debouncedCheck('email'));
    usernameController.addListener(() => _debouncedCheck('username'));
    mobileController.addListener(() => _debouncedCheck('mobile'));
    passwordController.addListener(() => _debouncedCheck('password'));

    // Listen to keyboard visibility
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialScrollOffset = _scrollController.initialScrollOffset;
    });

    // Monitor keyboard visibility
    KeyboardVisibilityController().onChange.listen((bool visible) {
      setState(() {
        _keyboardVisible = visible;
        if (!visible && mounted) {
          // Reset scroll position when keyboard hides
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted) {
              _scrollController.animateTo(
                _initialScrollOffset,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          });
        }
      });
    });
  }

  void _debouncedCheck(String field) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _validateField(field);
          if (field == 'email' &&
              emailController.text.isNotEmpty &&
              _emailRegex.hasMatch(emailController.text)) {
            _checkEmailAvailability();
          }
        });
      }
    });
  }

  void _validateField(String field) {
    String? value;
    switch (field) {
      case 'username':
        value = usernameController.text;
        fieldErrors['username'] =
            value.isEmpty
                ? 'Please enter a username'
                : value.length < 3
                ? 'Username must be at least 3 characters'
                : null;
        break;
      case 'email':
        value = emailController.text;
        fieldErrors['email'] =
            value.isEmpty
                ? 'Please enter an email'
                : !_emailRegex.hasMatch(value)
                ? 'Please enter a valid email'
                : null;
        break;
      case 'mobile':
        value = mobileController.text;
        fieldErrors['mobile'] =
            value.isEmpty
                ? 'Please enter a mobile number'
                : value.length < 10
                ? 'Please enter a valid mobile number'
                : null;
        break;
      case 'password':
        value = passwordController.text;
        fieldErrors['password'] =
            value.isEmpty
                ? 'Please enter a password'
                : value.length < 6
                ? 'Password must be at least 6 characters'
                : null;
        break;
    }
  }

  Future<void> _checkEmailAvailability() async {
    if (fieldErrors['email'] == null) {
      bool exists = await checkEmailExists(emailController.text);
      if (mounted) {
        setState(() {
          fieldErrors['email'] =
              exists ? 'Email is already registered, use another one' : null;
        });
      }
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    emailController.dispose();
    usernameController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home_screen()),
      );
    }
  }

  Widget _buildTextField(
    IconData icon,
    String hintText,
    TextEditingController controller,
    String fieldKey, {
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey),
            hintText: hintText,
            filled: true,
            fillColor: Colors.white.withOpacity(0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
          onTap: () {
            Future.delayed(const Duration(milliseconds: 100), () {
              if (mounted) {
                final position = _scrollController.position;
                final offset = position.pixels + 100;
                if (offset > position.maxScrollExtent) {
                  _scrollController.animateTo(
                    position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  _scrollController.animateTo(
                    offset,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              }
            });
          },
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child:
              fieldErrors[fieldKey] != null
                  ? Padding(
                    key: ValueKey(fieldErrors[fieldKey]),
                    padding: const EdgeInsets.only(top: 4.0, left: 12.0),
                    child: Text(
                      fieldErrors[fieldKey]!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  )
                  : const SizedBox.shrink(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF45B2E0), Color(0xFF97D8C4)],
                ),
              ),
            ),
          ),
          Positioned(
            top: -screenHeight * 0.1,
            left: -screenWidth * 0.1,
            child: Transform.rotate(
              angle: pi / 6,
              child: Container(
                width: screenWidth * 0.6,
                height: screenWidth * 0.6,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(screenWidth * 0.3),
                ),
              ),
            ),
          ),
          SafeArea(
            child: SizedBox(
              height: screenHeight,
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                ).copyWith(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight:
                          screenHeight - MediaQuery.of(context).padding.top,
                    ),
                    child: IntrinsicHeight(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Join Us,",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Create a new account",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 30),
                            _buildTextField(
                              Icons.person,
                              "Username",
                              usernameController,
                              'username',
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              Icons.email,
                              "Email",
                              emailController,
                              'email',
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              Icons.phone,
                              "Mobile Number",
                              mobileController,
                              'mobile',
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              Icons.lock,
                              "Password",
                              passwordController,
                              'password',
                              obscureText: true,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed:
                                  (_isLoading ||
                                          fieldErrors.values.any(
                                            (e) => e != null,
                                          ))
                                      ? null
                                      : () async {
                                        await addUser(
                                          email: emailController.text,
                                          mobileNo: mobileController.text,
                                          password: passwordController.text,
                                          username: usernameController.text,
                                        );
                                      },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2E86C1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 80,
                                  vertical: 15,
                                ),
                              ),
                              child:
                                  _isLoading
                                      ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                      : const Text(
                                        "Sign Up",
                                        style: TextStyle(color: Colors.white),
                                      ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Already have an account?",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const Login(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (_keyboardVisible)
                              SizedBox(
                                height:
                                    MediaQuery.of(context).viewInsets.bottom,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Add this helper class to monitor keyboard visibility
class KeyboardVisibilityController {
  Stream<bool> get onChange => Stream.fromFuture(_isKeyboardVisible());

  Future<bool> _isKeyboardVisible() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return WidgetsBinding.instance.window.viewInsets.bottom > 0;
  }
}
