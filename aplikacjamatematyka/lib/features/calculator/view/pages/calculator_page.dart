import 'package:aplikacjamatematyka/core/theme/app_pallete.dart';
import 'package:aplikacjamatematyka/features/calculator/viewmodel/calculator_page_viewmodel.dart';
import 'package:aplikacjamatematyka/features/home/view/widgets/navbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalculatorPage extends StatelessWidget {
  const CalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalculatorPageViewModel(),
      child: Scaffold(
        body: SafeArea(
          child: Consumer<CalculatorPageViewModel>(
            builder: (context, viewModel, _) => Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    alignment: Alignment.bottomRight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          viewModel.expression,
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w700,
                            color: viewModel.hasError
                                ? Pallete.redColor
                                : Pallete.blackColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          viewModel.result,
                          style: TextStyle(
                            fontSize: 28,
                            color: viewModel.hasError
                                ? Pallete.redColor
                                : Pallete.greyColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: GridView.count(
                      crossAxisCount: 4,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      children: [
                        _buildButton(context, "AC", color: Pallete.errorColor),
                        _buildButton(context, "()", color: Pallete.cyanColor),
                        _buildButton(context, "%", color: Pallete.cyanColor),
                        _buildButton(context, "÷", color: Pallete.cyanColor),

                        _buildButton(
                          context,
                          "7",
                          color: Pallete.lightpurpleColor,
                        ),
                        _buildButton(
                          context,
                          "8",
                          color: Pallete.lightpurpleColor,
                        ),
                        _buildButton(
                          context,
                          "9",
                          color: Pallete.lightpurpleColor,
                        ),
                        _buildButton(context, "×", color: Pallete.cyanColor),

                        _buildButton(
                          context,
                          "4",
                          color: Pallete.lightpurpleColor,
                        ),
                        _buildButton(
                          context,
                          "5",
                          color: Pallete.lightpurpleColor,
                        ),
                        _buildButton(
                          context,
                          "6",
                          color: Pallete.lightpurpleColor,
                        ),
                        _buildButton(context, "-", color: Pallete.cyanColor),

                        _buildButton(
                          context,
                          "1",
                          color: Pallete.lightpurpleColor,
                        ),
                        _buildButton(
                          context,
                          "2",
                          color: Pallete.lightpurpleColor,
                        ),
                        _buildButton(
                          context,
                          "3",
                          color: Pallete.lightpurpleColor,
                        ),
                        _buildButton(context, "+", color: Pallete.cyanColor),

                        _buildButton(
                          context,
                          "0",
                          color: Pallete.lightpurpleColor,
                        ),
                        _buildButton(
                          context,
                          ",",
                          color: Pallete.lightpurpleColor,
                        ),
                        _buildButton(
                          context,
                          "⌫",
                          color: Pallete.lightpurpleColor,
                        ),
                        _buildButton(
                          context,
                          "=",
                          color: Pallete.darkcyanColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const NavBarWidget(),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, {Color? color}) {
    final viewModel = Provider.of<CalculatorPageViewModel>(
      context,
      listen: false,
    );
    return ElevatedButton(
      onPressed: () => viewModel.onButtonPressed(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Colors.grey.shade300,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.all(0),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: Pallete.whiteColor,
        ),
      ),
    );
  }
}
