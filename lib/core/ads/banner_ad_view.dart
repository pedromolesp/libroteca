import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tomora/core/ads/ad_config.dart';
import 'package:tomora/core/ads/ads_cubit.dart';
import 'package:tomora/core/ads/ads_service.dart';
import 'package:tomora/core/config/di/dependency_injector.dart';

/// Banner adaptativo anclado a lo ancho (altura estándar, ~50-60 px) que se
/// coloca bajo la AppBar. No pinta nada mientras carga, cuando [AdsCubit] tiene
/// los anuncios desactivados, o cuando el consentimiento no los permite.
class BannerAdView extends StatelessWidget {
  const BannerAdView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdsCubit, AdsState>(
      buildWhen: (a, b) => a.adsEnabled != b.adsEnabled,
      builder: (context, state) {
        if (!state.adsEnabled) return const SizedBox.shrink();
        return const _AnchoredBanner();
      },
    );
  }
}

class _AnchoredBanner extends StatefulWidget {
  const _AnchoredBanner();

  @override
  State<_AnchoredBanner> createState() => _AnchoredBannerState();
}

class _AnchoredBannerState extends State<_AnchoredBanner> {
  final _adsService = getIt<AdsService>();
  BannerAd? _ad;
  bool _loaded = false;
  bool _loading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Necesita MediaQuery para el ancho adaptativo, así que no en initState.
    _loadAd();
  }

  Future<void> _loadAd() async {
    if (_loading || _loaded) return;
    _loading = true;

    await _adsService.ready;
    if (!mounted || !_adsService.canRequestAds) {
      _loading = false;
      return;
    }

    final width = MediaQuery.sizeOf(context).width.truncate();
    // ignore: deprecated_member_use
    final size = await AdSize.getAnchoredAdaptiveBannerAdSize(
      Orientation.portrait,
      width,
    );
    if (!mounted || size == null) {
      _loading = false;
      return;
    }

    final ad = BannerAd(
      size: size,
      adUnitId: AdConfig.bannerUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (!mounted) {
            _ad?.dispose();
            return;
          }
          setState(() {
            _loaded = true;
            _loading = false;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _loading = false;
          debugPrint('BannerAdView: no se pudo cargar: $error');
        },
      ),
    );
    _ad = ad;
    await ad.load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _ad;
    if (!_loaded || ad == null) return const SizedBox.shrink();
    return SizedBox(
      width: double.infinity,
      height: ad.size.height.toDouble(),
      child: Center(
        child: SizedBox(
          width: ad.size.width.toDouble(),
          height: ad.size.height.toDouble(),
          child: AdWidget(ad: ad),
        ),
      ),
    );
  }
}
