import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:subcultures/api/login_api.dart';
import 'package:subcultures/models/login.dart';
import 'package:subcultures/routes/page_controller.dart';
import 'package:subcultures/utils/storage/token_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController(text: 'admin');
  final _passwordController = TextEditingController(text: '123123');

  @override
  void initState() {
    super.initState();
    log('LoginPage --> initState');
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // 返回按钮
            Positioned(
              left: 16,
              top: 16,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            // 登录表单
            _getLoginView(),
          ],
        ),
      ),
    );
  }

  /// 登录按钮
  ElevatedButton _getLoginBtn() {
    return ElevatedButton(
      onPressed: () => login(),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'Login',
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }

  /// 用户登录
  void login() async {
    final user = LoginUser(
      username: _usernameController.text,
      password: _passwordController.text,
    );
    // 进行登录
    final data = await LoginApi.login(user);
    log('login.dart --> 用户登录: data: $data');
    // 登录逻辑在这里实现
    log('login.dart --> 用户登录: username: ${_usernameController.text}');
    // 保存token
    TokenStorage tokenStorage = TokenStorage();
    tokenStorage.setAccessToken(data['accessToken']);
    // 跳转页面
    PPC.toHome();
  }

  /// 密码输入框
  TextField _getPasswordView() {
    return TextField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        prefixIcon: const Icon(Icons.lock_outline),
      ),
    );
  }

  /// 用户名输入框
  TextField _getUsernameView() {
    return TextField(
      controller: _usernameController,
      decoration: InputDecoration(
        hintText: 'Username',
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        prefixIcon: const Icon(Icons.person_outline),
      ),
    );
  }

  /// 获取登录视图
  Padding _getLoginView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Welcome',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          _getUsernameView(),
          const SizedBox(height: 16),
          _getPasswordView(),
          const SizedBox(height: 24),
          _getLoginBtn(),
        ],
      ),
    );
  }
}
