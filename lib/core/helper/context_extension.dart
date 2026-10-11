import 'package:flutter/material.dart';

extension Navigation on BuildContext {
  // Push
  Future<T?> push<T>(Widget page, {bool rootNavigator = false}) {
    return Navigator.of(
      this,
      rootNavigator: rootNavigator,
    ).push<T>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  // Push Replacement
  Future<T?> pushReplacement<T, TO>(
    Widget page, {
    TO? result,
    bool rootNavigator = false,
  }) {
    return Navigator.of(
      this,
      rootNavigator: rootNavigator,
    ).pushReplacement<T, TO>(
      MaterialPageRoute(builder: (_) => page),
      result: result,
    );
  }

  // Push And Remove Until
  Future<T?> pushAndRemoveUntil<T>(
    Widget page, {
    required RoutePredicate predicate,
    bool rootNavigator = false,
  }) {
    return Navigator.of(
      this,
      rootNavigator: rootNavigator,
    ).pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: (_) => page),
      predicate,
    );
  }

  // Push Named
  Future<T?> pushNamed<T>(
    String routeName, {
    Object? arguments,
    bool rootNavigator = false,
  }) {
    return Navigator.of(
      this,
      rootNavigator: rootNavigator,
    ).pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  // Push Replacement Named
  Future<T?> pushReplacementNamed<T, TO>(
    String routeName, {
    Object? arguments,
    TO? result,
    bool rootNavigator = false,
  }) {
    return Navigator.of(
      this,
      rootNavigator: rootNavigator,
    ).pushReplacementNamed<T, TO>(
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  // Push Named And Remove Until
  Future<T?> pushNamedAndRemoveUntil<T>(
    String routeName, {
    Object? arguments,
    required RoutePredicate predicate,
    bool rootNavigator = false,
  }) {
    return Navigator.of(
      this,
      rootNavigator: rootNavigator,
    ).pushNamedAndRemoveUntil<T>(
      routeName,
      predicate,
      arguments: arguments,
    );
  }

  // Pop
  void pop({bool rootNavigator = false}) {
    Navigator.of(
      this,
      rootNavigator: rootNavigator,
    ).pop();
  }

  // Can Pop
  bool canPop({bool rootNavigator = false}) {
    return Navigator.of(
      this,
      rootNavigator: rootNavigator,
    ).canPop();
  }
}

extension StringExtension on String? {
  bool isNullOrEmpty() => this == null || this == "";
}

extension ListExtension<T> on List<T>? {
  bool isNullOrEmpty() => this == null || this!.isEmpty;
}