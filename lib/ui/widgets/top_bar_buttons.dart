import 'package:flutter/material.dart';
import '../../models/listing.dart';

class TopBarButtons extends StatefulWidget {
  final Function(ListingCategory) onCategorySelected;
  final ListingCategory? selectedCategory;

  const TopBarButtons({
    super.key,
    required this.onCategorySelected,
    this.selectedCategory,
  });

  @override
  State<TopBarButtons> createState() => _TopBarButtonsState();
}

class _TopBarButtonsState extends State<TopBarButtons>
    with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _rotationAnimations;
  late List<Animation<Offset>> _slideAnimations;

  final List<CategoryButtonData> _categories = [
    CategoryButtonData(
      category: ListingCategory.realEstate,
      icon: Icons.home_work,
      label: 'Real Estate',
      color: Colors.blue,
      gradient: [Colors.blue.shade400, Colors.blue.shade600],
    ),
    CategoryButtonData(
      category: ListingCategory.professionals,
      icon: Icons.work_outline,
      label: 'Professionals',
      color: Colors.green,
      gradient: [Colors.green.shade400, Colors.green.shade600],
    ),
    CategoryButtonData(
      category: ListingCategory.services,
      icon: Icons.build_outlined,
      label: 'Services',
      color: Colors.orange,
      gradient: [Colors.orange.shade400, Colors.orange.shade600],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startStaggeredAnimation();
  }

  void _initializeAnimations() {
    _animationControllers = List.generate(
      _categories.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      ),
    );

    _scaleAnimations = _animationControllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      ));
    }).toList();

    _rotationAnimations = _animationControllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ));
    }).toList();

    _slideAnimations = _animationControllers.map((controller) {
      return Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutCubic,
      ));
    }).toList();
  }

  void _startStaggeredAnimation() {
    for (int i = 0; i < _animationControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted) {
          _animationControllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: Row(
        children: List.generate(_categories.length, (index) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: index == 1 ? 8 : 4,
              ),
              child: _buildCategoryButton(index),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCategoryButton(int index) {
    final category = _categories[index];
    final isSelected = widget.selectedCategory == category.category;

    return AnimatedBuilder(
      animation: Listenable.merge([
        _scaleAnimations[index],
        _rotationAnimations[index],
        _slideAnimations[index],
      ]),
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimations[index],
          child: Transform.scale(
            scale: _scaleAnimations[index].value,
            child: GestureDetector(
              onTap: () => _handleCategoryTap(category.category, index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isSelected
                        ? category.gradient
                        : [
                            Colors.white,
                            Colors.grey.shade50,
                          ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected
                          ? category.color.withOpacity(0.3)
                          : Colors.black.withOpacity(0.1),
                      blurRadius: isSelected ? 12 : 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: isSelected
                        ? category.color.withOpacity(0.3)
                        : Colors.grey.shade200,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.rotate(
                      angle: _rotationAnimations[index].value * 0.1,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withOpacity(0.2)
                              : category.color.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          category.icon,
                          size: 28,
                          color: isSelected ? Colors.white : category.color,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : category.color,
                      ),
                      child: Text(
                        category.label,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleCategoryTap(ListingCategory category, int index) {
    // Add a subtle bounce animation
    _animationControllers[index].reverse().then((_) {
      _animationControllers[index].forward();
    });

    // Haptic feedback
    // HapticFeedback.lightImpact();

    widget.onCategorySelected(category);
  }
}

class CategoryButtonData {
  final ListingCategory category;
  final IconData icon;
  final String label;
  final Color color;
  final List<Color> gradient;

  CategoryButtonData({
    required this.category,
    required this.icon,
    required this.label,
    required this.color,
    required this.gradient,
  });
}