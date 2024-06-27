import 'package:chapa_tu_bus_app/shared/widgets/navbar/animated_bar.dart';
import 'package:chapa_tu_bus_app/shared/widgets/navbar/bottom_nav_items.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rive/rive.dart';

const Color bottonNavBgColor = Color(0xFF556BDA);

class BottomNavWithAnimatedIcons extends StatefulWidget {
  final int currentIndex;
  const BottomNavWithAnimatedIcons({
    super.key, 
    required this.currentIndex
  });

  @override
  State<BottomNavWithAnimatedIcons> createState() =>
      _BottomNavWithAnimatedIconsState();
}

class _BottomNavWithAnimatedIconsState
    extends State<BottomNavWithAnimatedIcons> {
  List<SMIBool> riveIconInputs = [];
  List<StateMachineController?> controllers = [];


  void onItemTapped(BuildContext context, int index) {
    // Deja que GoRouter maneje la navegación
    context.go('/home/$index'); 
  }

  void animateTheIcon(int index) {
    riveIconInputs[index].change(true);
    Future.delayed(
      const Duration(seconds: 1),
      () {
        riveIconInputs[index].change(false);
      },
    );
  }

  void riveOnInIt(Artboard artboard, {required String stateMachineName}) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, stateMachineName);

    artboard.addController(controller!);
    controllers.add(controller);

    riveIconInputs.add(controller.findInput<bool>('active') as SMIBool);
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: bottonNavBgColor.withOpacity(0.8),
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: bottonNavBgColor.withOpacity(0.3),
              offset: const Offset(0, 20),
              blurRadius: 20,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(bottomNavItems.length, (index) {
            final riveIcon = bottomNavItems[index];
            return GestureDetector(
              onTap: () {
                animateTheIcon(index);
                // Actualiza el currentIndex en GoRouter
                onItemTapped(context, index);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBar(
                    
                    isActive: widget.currentIndex == index,
                  ),
                  SizedBox(
                    height: 25,
                    width: 25,
                    child: Opacity(
                      
                      opacity: widget.currentIndex == index ? 1 : 0.5,
                      child: RiveAnimation.asset(
                        riveIcon.src,
                        artboard: riveIcon.artboard,
                        onInit: (artboard) {
                          riveOnInIt(artboard,
                              stateMachineName: riveIcon.stateMachineName);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}