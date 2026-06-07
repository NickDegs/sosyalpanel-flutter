import 'package:flutter/material.dart';

// ─── iOS 26 animasyon sabitleri ───────────────────────────────────────────────

class AppDurations {
  static const micro  = Duration(milliseconds: 150);
  static const fast   = Duration(milliseconds: 240);
  static const normal = Duration(milliseconds: 360);
  static const slow   = Duration(milliseconds: 500);
  static const enter  = Duration(milliseconds: 420);
}

class AppCurves {
  /// iOS 26 standart giriş — yavaşlayan, doğal hissettiren
  static const enter  = Cubic(0.2, 0.0, 0.0, 1.0);
  /// Micro-interaction spring — hafif zıplama
  static const spring = Cubic(0.34, 1.56, 0.64, 1.0);
  /// Çıkış — hızlanan
  static const exit   = Cubic(0.4, 0.0, 1.0, 1.0);
  static const ease   = Curves.easeOutCubic;
}

// ─── FadeSlideIn ─────────────────────────────────────────────────────────────
/// Widget mount edildiğinde fade + yukarı kayarak giriş yapar.
class FadeSlideIn extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset beginOffset;

  const FadeSlideIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = AppDurations.normal,
    this.beginOffset = const Offset(0, 0.06),
  });

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _opacity = CurvedAnimation(parent: _ctrl, curve: AppCurves.enter);
    _slide   = Tween(begin: widget.beginOffset, end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: AppCurves.enter));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (MediaQuery.disableAnimationsOf(context)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _ctrl.value = 1.0;
      });
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _ctrl.forward();
      });
    }
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: _opacity,
        child: SlideTransition(position: _slide, child: widget.child),
      );
}

// ─── StaggeredItem ────────────────────────────────────────────────────────────
/// Liste/grid içindeki eleman için kademeli (staggered) giriş.
class StaggeredItem extends StatelessWidget {
  final int index;
  final Widget child;
  final Duration baseDelay;
  final Duration stepDelay;

  const StaggeredItem({
    super.key,
    required this.index,
    required this.child,
    this.baseDelay = const Duration(milliseconds: 60),
    this.stepDelay = const Duration(milliseconds: 55),
  });

  @override
  Widget build(BuildContext context) => FadeSlideIn(
        delay: baseDelay + stepDelay * index,
        duration: AppDurations.normal,
        child: child,
      );
}

// ─── PressScale ───────────────────────────────────────────────────────────────
/// Dokunulduğunda hafifçe küçülen iOS tarzı basma efekti.
class PressScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scale;

  const PressScale({
    super.key,
    required this.child,
    this.onTap,
    this.scale = 0.95,
  });

  @override
  State<PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<PressScale>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: AppDurations.micro,
      reverseDuration: const Duration(milliseconds: 200),
    );
    _scale = Tween(begin: 1.0, end: widget.scale).animate(
      CurvedAnimation(parent: _ctrl, curve: AppCurves.ease),
    );
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: (_)  => _ctrl.forward(),
        onTapUp:   (_)  { _ctrl.reverse(); widget.onTap?.call(); },
        onTapCancel: () => _ctrl.reverse(),
        child: ScaleTransition(scale: _scale, child: widget.child),
      );
}

// ─── TabFadeIn ────────────────────────────────────────────────────────────────
/// Sekme aktif olduğunda içeriği fade+slide ile gösterir; state korunur.
class TabFadeIn extends StatefulWidget {
  final bool isActive;
  final Widget child;

  const TabFadeIn({super.key, required this.isActive, required this.child});

  @override
  State<TabFadeIn> createState() => _TabFadeInState();
}

class _TabFadeInState extends State<TabFadeIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double>  _opacity;
  late final Animation<Offset>  _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: AppDurations.fast);
    _opacity = CurvedAnimation(parent: _ctrl, curve: AppCurves.enter);
    _slide   = Tween(begin: const Offset(0, 0.04), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: AppCurves.enter));
    if (widget.isActive) _ctrl.value = 1.0;
  }

  @override
  void didUpdateWidget(TabFadeIn old) {
    super.didUpdateWidget(old);
    if (widget.isActive && !old.isActive) {
      _ctrl.forward(from: 0);
    }
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: _opacity,
        child: SlideTransition(position: _slide, child: widget.child),
      );
}

// ─── FloatLoop ────────────────────────────────────────────────────────────────
/// Sürekli hafifçe yukarı-aşağı yüzen animasyon (empty state için).
class FloatLoop extends StatefulWidget {
  final Widget child;
  const FloatLoop({super.key, required this.child});

  @override
  State<FloatLoop> createState() => _FloatLoopState();
}

class _FloatLoopState extends State<FloatLoop>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<Offset> _slide;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
    _slide = Tween(begin: const Offset(0, -0.025), end: const Offset(0, 0.025))
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    if (!_started && !MediaQuery.disableAnimationsOf(context)) {
      _started = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _ctrl.repeat(reverse: true);
      });
    }
    return SlideTransition(position: _slide, child: widget.child);
  }
}

// ─── PulseGlow ────────────────────────────────────────────────────────────────
/// Aktif butonda sürekli soluk-parlak pulse efekti.
class PulseGlow extends StatefulWidget {
  final Widget child;
  final bool active;
  const PulseGlow({super.key, required this.child, this.active = true});

  @override
  State<PulseGlow> createState() => _PulseGlowState();
}

class _PulseGlowState extends State<PulseGlow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  bool _repeatStarted = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _scale = Tween(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    // repeat() deferred to build() to check disableAnimations
  }

  @override
  void didUpdateWidget(PulseGlow old) {
    super.didUpdateWidget(old);
    if (!widget.active && old.active) {
      _ctrl.stop(); _ctrl.value = 0;
      _repeatStarted = false;
    }
    // active=true case handled in build()
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    if (widget.active && !_repeatStarted && !MediaQuery.disableAnimationsOf(context)) {
      _repeatStarted = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && widget.active) _ctrl.repeat(reverse: true);
      });
    }
    return ScaleTransition(scale: _scale, child: widget.child);
  }
}
