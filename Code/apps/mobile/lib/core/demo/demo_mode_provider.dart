import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _demoModeKey = 'sanaya.demo_mode';
const _demoRoleKey = 'sanaya.demo_role';

/// Rôle simulé en mode démo.
enum DemoRole { guest, client, provider }

/// Lit l'état initial du mode démo depuis SharedPreferences.
Future<bool> readInitialDemoMode() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(_demoModeKey) ?? false;
}

/// Persiste l'activation ou désactivation du mode démo.
Future<void> persistDemoMode({required bool enabled}) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_demoModeKey, enabled);
}

/// Lit le rôle démo initial depuis SharedPreferences.
Future<DemoRole> readInitialDemoRole() async {
  final prefs = await SharedPreferences.getInstance();
  final val = prefs.getString(_demoRoleKey);
  if (val == DemoRole.provider.name) return DemoRole.provider;
  if (val == DemoRole.guest.name) return DemoRole.guest;
  return DemoRole.client;
}

/// Persiste le choix de rôle démo.
Future<void> persistDemoRole(DemoRole role) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_demoRoleKey, role.name);
}

/// Gère l'activation globale du Mode Démo.
class DemoModeNotifier extends StateNotifier<bool> {
  DemoModeNotifier({bool initial = false}) : super(initial);

  Future<void> toggle() async {
    final next = !state;
    state = next;
    await persistDemoMode(enabled: next);
  }

  Future<void> setEnabled({required bool enabled}) async {
    if (state == enabled) return;
    state = enabled;
    await persistDemoMode(enabled: enabled);
  }
}

/// Gère le rôle actif en Mode Démo (Client vs Artisan Pro).
class DemoRoleNotifier extends StateNotifier<DemoRole> {
  DemoRoleNotifier([super.initial = DemoRole.client]);

  Future<void> setRole(DemoRole role) async {
    if (state == role) return;
    state = role;
    await persistDemoRole(role);
  }

  Future<void> toggleRole() async {
    final next = switch (state) {
      DemoRole.guest => DemoRole.client,
      DemoRole.client => DemoRole.provider,
      DemoRole.provider => DemoRole.guest,
    };
    state = next;
    await persistDemoRole(next);
  }
}

/// Provider d'état du Mode Démo.
final demoModeProvider = StateNotifierProvider<DemoModeNotifier, bool>((ref) {
  return DemoModeNotifier();
});

/// Provider du rôle simulé en Mode Démo.
final demoRoleProvider = StateNotifierProvider<DemoRoleNotifier, DemoRole>((
  ref,
) {
  return DemoRoleNotifier();
});
