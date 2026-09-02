import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tomora/core/ads/ads_cubit.dart';
import 'package:tomora/core/config/di/dependency_injector.dart';
import 'package:tomora/core/config/l10n/locale_cubit.dart';
import 'package:tomora/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:tomora/features/auth/presentation/bloc/referral_cubit.dart';
import 'package:tomora/features/friends/presentation/bloc/friends_cubit.dart';

/// Blocs de ámbito de aplicación, provistos por encima del [Navigator] para que
/// sean alcanzables desde cualquier ruta. Mismo patrón que Planogether.
class TopBlocProviders extends StatelessWidget {
  const TopBlocProviders({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<LocaleCubit>()),
        BlocProvider(create: (_) => getIt<AuthCubit>()),
        BlocProvider(create: (_) => getIt<ReferralCubit>()),
        BlocProvider(create: (_) => getIt<AdsCubit>()),
        BlocProvider(create: (_) => getIt<FriendsCubit>()),
      ],
      child: child,
    );
  }
}
