import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/core/api/api_client_provider.dart';
import 'package:sanaya/features/onboarding/data/portfolio_repository.dart';

/// Point d'entrée unique pour les routes médias/portfolio (FM-35), même
/// patron que [defaultApiProvider] et les autres providers de dépôt.
final portfolioRepositoryProvider = Provider<PortfolioRepository>(
  (ref) => PortfolioRepository(ref.watch(defaultApiProvider)),
);
