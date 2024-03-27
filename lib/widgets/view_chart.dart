import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:my_front/main.dart';




class ViewersChart extends StatefulWidget {
  final Color baseColor;

  ViewersChart({
    required this.baseColor,
    super.key
  });

  @override
  State<StatefulWidget> createState() => ViewersChartState();
}

class ViewersChartState extends State<ViewersChart> {
  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Video 1';
        break;
      case 1:
        text = 'Video 2';
        break;
      case 2:
        text = 'Video 3';
        break;
      case 3:
        text = 'Video 4';
        break;
      case 4:
        text = 'Video 5';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    if (value == meta.max) {
      return Container();
    }
    const style = TextStyle(
      fontSize: 10,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        meta.formattedValue,
        style: style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return AspectRatio(
      aspectRatio: 2,
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final barsSpace = 4.0 * constraints.maxWidth / 400;
            final screenWidth = MediaQuery.of(context).size.width;
            final barsWidth = 8.0 * screenWidth / 400;
            return BarChart(
              BarChartData(
                alignment: BarChartAlignment.center,
                barTouchData: BarTouchData(
                  enabled: false,
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: bottomTitles,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: leftTitles,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  checkToShowHorizontalLine: (value) => value % 10 == 0,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColors.borderColor.withOpacity(0.1),
                    strokeWidth: 1,
                  ),
                  drawVerticalLine: false,
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                groupsSpace: barsSpace,
                barGroups: getData(barsWidth, barsSpace),
              ),
            );
          },
        ),
      ),
    );
  }

  List<BarChartGroupData> getData(double barsWidth, double barsSpace) {
    return [
      BarChartGroupData(
        x: 0,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 17000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 2000000000, Theme.of(context).colorScheme.surfaceTint),
              BarChartRodStackItem(2000000000, 12000000000, Theme.of(context).colorScheme.onSurfaceVariant),
              BarChartRodStackItem(12000000000, 17000000000, Theme.of(context).colorScheme.surfaceVariant),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 31000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 11000000000, Theme.of(context).colorScheme.surfaceTint),
              BarChartRodStackItem(11000000000, 18000000000, Theme.of(context).colorScheme.onSurfaceVariant),
              BarChartRodStackItem(18000000000, 31000000000, Theme.of(context).colorScheme.surfaceVariant),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 34000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 6000000000, Theme.of(context).colorScheme.surfaceTint),
              BarChartRodStackItem(6000000000, 23000000000, Theme.of(context).colorScheme.onSurfaceVariant),
              BarChartRodStackItem(23000000000, 34000000000, Theme.of(context).colorScheme.surfaceVariant),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),

        ],
      ),
      BarChartGroupData(
        x: 3,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 14000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 1000000000.5, Theme.of(context).colorScheme.surfaceTint),
              BarChartRodStackItem(1000000000.5, 12000000000, Theme.of(context).colorScheme.onSurfaceVariant),
              BarChartRodStackItem(12000000000, 14000000000, Theme.of(context).colorScheme.surfaceVariant),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 4,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 14000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 1000000000.5, Theme.of(context).colorScheme.surfaceTint),
              BarChartRodStackItem(1000000000.5, 12000000000, Theme.of(context).colorScheme.onSurfaceVariant),
              BarChartRodStackItem(12000000000, 14000000000, Theme.of(context).colorScheme.surfaceVariant),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
    ];
  }
}



class AppDimens {
  static const double menuMaxNeededWidth = 304;
  static const double menuRowHeight = 74;
  static const double menuIconSize = 32;
  static const double menuDocumentationIconSize = 44;
  static const double menuTextSize = 20;

  static const double chartBoxMinWidth = 350;

  static const double defaultRadius = 8;
  static const double chartSamplesSpace = 32.0;
  static const double chartSamplesMinWidth = 350;
}


class AppColors {
  static const Color primary = contentColorCyan;
  static const Color menuBackground = Color(0xFF090912);
  static const Color itemsBackground = Color(0xFF1B2339);
  static const Color pageBackground = Color(0xFF282E45);
  static const Color mainTextColor1 = Colors.white;
  static const Color mainTextColor2 = Colors.white70;
  static const Color mainTextColor3 = Colors.white38;
  static const Color mainGridLineColor = Colors.white10;
  static const Color borderColor = Colors.white54;
  static const Color gridLinesColor = Color(0x11FFFFFF);

  static const Color contentColorBlack = Colors.black;
  static const Color contentColorWhite = Colors.white;
  static const Color contentColorBlue = Color(0xFF2196F3);
  static const Color contentColorYellow = Color(0xFFFFC300);
  static const Color contentColorOrange = Color(0xFFFF683B);
  static const Color contentColorGreen = Color(0xFF3BFF49);
  static const Color contentColorPurple = Color(0xFF6E1BFF);
  static const Color contentColorPink = Color(0xFFFF3AF2);
  static const Color contentColorRed = Color(0xFFE80054);
  static const Color contentColorCyan = Color(0xFF50E4FF);
}