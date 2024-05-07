import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:playmax_app_1/config/colors.dart';
import 'package:playmax_app_1/config/routes.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key, required this.state});
  final GoRouterState state;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Container(
          width: screenSize.width * 0.8,
          height: screenSize.height * 0.8,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(
                    maxHeight: 350,
                  ),
                  child: Lottie.asset(
                      'assets/lotties/page_not_found_animation.json'),
                ),
              ),
              const Gap(10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '404',
                      style: GoogleFonts.poppins(
                          fontSize: 60, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Página No Encontrada!',
                      style: GoogleFonts.poppins(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const Gap(10),
                    Text(
                      'Lo sentimos, la página que quieres visitar\nno pudo ser hallada. Por favor regresa\na la página de inicio!',
                      style: GoogleFonts.roboto(fontSize: 20),
                    ),
                    const Gap(20),
                    SizedBox(
                      width: 375,
                      child: ElevatedButton(
                        onPressed: () => context.goNamed(Routes.login),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.kStrongPink,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5))),
                        child: const Text(
                          'INICIO',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
