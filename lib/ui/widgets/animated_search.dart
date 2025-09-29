import 'package:flutter/material.dart';

class AnimatedSearch extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final VoidCallback onClear;
  final String hintText;
  final Duration animationDuration;

  const AnimatedSearch({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
    this.hintText = 'Search listings...',
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedSearch> createState() => _AnimatedSearchState();
}

class _AnimatedSearchState extends State<AnimatedSearch>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  bool _isFocused = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();

    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _focusNode.addListener(_handleFocusChange);
    widget.controller.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    widget.controller.removeListener(_handleTextChange);
    _animationController.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });

    if (_isFocused) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _handleTextChange() {
    widget.onChanged(widget.controller.text);
  }

  void _handleClear() {
    widget.controller.clear();
    widget.onClear();
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  if (_isFocused)
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: widget.controller,
                focusNode: _focusNode,
                onSubmitted: widget.onSubmitted,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                  prefixIcon: AnimatedContainer(
                    duration: widget.animationDuration,
                    child: Icon(
                      Icons.search,
                      color: _isFocused
                          ? colorScheme.primary
                          : colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  suffixIcon: widget.controller.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                          onPressed: _handleClear,
                        )
                      : null,
                  filled: true,
                  fillColor: colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
                style: TextStyle(color: colorScheme.onSurface, fontSize: 16),
              ),
            ),
          ),
        );
      },
    );
  }
}

// import 'package:flutter/material.dart';
//
// class AnimatedSearch extends StatefulWidget {
//   final TextEditingController controller;
//   final ValueChanged<String>? onChanged;
//   final ValueChanged<String>? onSubmitted;
//   final VoidCallback? onClear;
//   final String hintText;
//   final bool autofocus;
//
//   const AnimatedSearch({
//     super.key,
//     required this.controller,
//     this.onChanged,
//     this.onSubmitted,
//     this.onClear,
//     this.hintText = 'Search listings, professionals, services...',
//     this.autofocus = false,
//   });
//
//   @override
//   State<AnimatedSearch> createState() => _AnimatedSearchState();
// }
//
// class _AnimatedSearchState extends State<AnimatedSearch>
//     with TickerProviderStateMixin {
//   late AnimationController _animationController;
//   late AnimationController _focusAnimationController;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _focusAnimation;
//   late Animation<Color?> _colorAnimation;
//
//   final FocusNode _focusNode = FocusNode();
//   bool _isFocused = false;
//   bool _hasText = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//
//     _focusAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 200),
//       vsync: this,
//     );
//
//     _scaleAnimation = Tween<double>(
//       begin: 1.0,
//       end: 1.02,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     ));
//
//     _focusAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _focusAnimationController,
//       curve: Curves.easeInOut,
//     ));
//
//     _colorAnimation = ColorTween(
//       begin: Colors.grey[300],
//       end: Theme.of(context).primaryColor,
//     ).animate(CurvedAnimation(
//       parent: _focusAnimationController,
//       curve: Curves.easeInOut,
//     ));
//
//     _focusNode.addListener(_onFocusChange);
//     widget.controller.addListener(_onTextChange);
//
//     _animationController.forward();
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     _focusAnimationController.dispose();
//     _focusNode.dispose();
//     super.dispose();
//   }
//
//   void _onFocusChange() {
//     setState(() {
//       _isFocused = _focusNode.hasFocus;
//     });
//
//     if (_isFocused) {
//       _focusAnimationController.forward();
//     } else {
//       _focusAnimationController.reverse();
//     }
//   }
//
//   void _onTextChange() {
//     final hasText = widget.controller.text.isNotEmpty;
//     if (hasText != _hasText) {
//       setState(() {
//         _hasText = hasText;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: Listenable.merge([_scaleAnimation, _focusAnimation]),
//       builder: (context, child) {
//         return Transform.scale(
//           scale: _scaleAnimation.value,
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 8,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: TextField(
//               controller: widget.controller,
//               focusNode: _focusNode,
//               autofocus: widget.autofocus,
//               onChanged: widget.onChanged,
//               onSubmitted: widget.onSubmitted,
//               decoration: InputDecoration(
//                 hintText: widget.hintText,
//                 hintStyle: TextStyle(
//                   color: Colors.grey[500],
//                   fontSize: 16,
//                 ),
//                 prefixIcon: AnimatedContainer(
//                   duration: const Duration(milliseconds: 200),
//                   child: Icon(
//                     Icons.search,
//                     color: _isFocused
//                         ? Theme.of(context).primaryColor
//                         : Colors.grey[500],
//                   ),
//                 ),
//                 suffixIcon: _hasText
//                     ? AnimatedScale(
//                         scale: _hasText ? 1.0 : 0.0,
//                         duration: const Duration(milliseconds: 200),
//                         child: IconButton(
//                           icon: Icon(
//                             Icons.clear,
//                             color: Colors.grey[500],
//                           ),
//                           onPressed: () {
//                             widget.controller.clear();
//                             widget.onClear?.call();
//                           },
//                         ),
//                       )
//                     : null,
//                 filled: true,
//                 fillColor: Colors.white,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(16),
//                   borderSide: BorderSide.none,
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(16),
//                   borderSide: BorderSide(
//                     color: Colors.grey[300]!,
//                     width: 1,
//                   ),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(16),
//                   borderSide: BorderSide(
//                     color: _colorAnimation.value ?? Theme.of(context).primaryColor,
//                     width: 2,
//                   ),
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(
//                   horizontal: 20,
//                   vertical: 16,
//                 ),
//               ),
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
