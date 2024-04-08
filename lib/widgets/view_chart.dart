import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/view_info.dart';
import '../widgets/legend_list_widget.dart';

class ViewersChart extends StatefulWidget {
  final Color baseColor;
  final String creatorName;

  ViewersChart({
    Key? key,
    required this.baseColor,
    required this.creatorName,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ViewersChartState();
}

class ViewersChartState extends State<ViewersChart> {
  String get creatorName => widget.creatorName;
  late InfoChart infoChart = InfoChart(widget.creatorName);
  bool _isLoading = true;
  Color get baseColor => widget.baseColor;
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    loadData();
    _isLoading = true;
  }
  void loadData() async {
    await infoChart.loadJsonData(widget.creatorName);
    setState(() {
      _isLoading = false;
    });
  }

  Widget bottomTitles(double value, TitleMeta meta)  {
    final brightness = ThemeData.estimateBrightnessForColor(baseColor);
    final textColor = brightness == Brightness.dark ? Colors.white : Colors.black;
    final style = TextStyle(fontSize: 10, color: textColor);
    List<String> dates = infoChart.getDates();
    String text;
    switch (value.toInt()) {
      case 0:
        text = dates[0];
        break;
      case 1:
        text = dates[1];
        break;
      case 2:
        text = dates[3];
        break;
      case 3:
        text = dates[4];
        break;
      case 4:
        text = dates[5];
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(style: style, text),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    final brightness = ThemeData.estimateBrightnessForColor(baseColor);
    final textColor = brightness == Brightness.dark ? Colors.white : Colors.black;
    final style = TextStyle(fontSize: 10, color: textColor);
    if (value == meta.max) {
      return Container();
    }
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
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children :[
          Text(
              "Stats",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 16,
                fontWeight: FontWeight.bold,)
          ),
          const SizedBox(
            height: 8,
          ),
          LegendsListWidget(
              legends: [
                Legend("Comments", Theme.of(context).colorScheme.primary),
                Legend("Like", Theme.of(context).colorScheme.primary.withOpacity(0.5)),
                Legend("Views", Theme.of(context).colorScheme.primary.withOpacity(0.7)),
              ]
          ),
          AspectRatio(
            aspectRatio: 1.66,
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final barsCount = 5;
                  final screenWidth = 300; //ajuster en fonction de la taille réel du container
                  final barsWidth = screenWidth / (2 * barsCount);
                  final barsSpace = barsWidth;
                  List<double> touchedValues = [];
                  return BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.center,
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          tooltipMargin: 8,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            String title;
                            switch (rodIndex) {
                              case 0:
                                title = 'Comments';
                                break;
                              case 1:
                                title = 'Likes';
                                break;
                              case 2:
                                title = 'Views';
                                break;
                              default:
                                title = '';
                                break;
                            }
                            return BarTooltipItem(
                              '$title : ${rod.toY.round()}',
                              TextStyle(color: Colors.white),
                            );
                          },
                        ),
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
                        checkToShowHorizontalLine: (value) => value % 5 == 0,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: Theme.of(context).colorScheme.background,
                          strokeWidth: 1,
                        ),
                        drawVerticalLine: false,
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      groupsSpace: barsSpace,
                      barGroups: getData(context, barsCount, barsWidth, barsSpace),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  List<BarChartGroupData> getData(BuildContext context, barsCount, double barsWidth, double barsSpace) {
    if (_isLoading){
      const CircularProgressIndicator();
    }
    return List.generate(barsCount, (index) {
      final videoIndex = index + 1;
      List<int> likes = infoChart.getLikes();
      List<int> views = infoChart.getViews();
      List<int> comments = infoChart.getComments();
      final isTouched = touchedIndex == index;
      return BarChartGroupData(
        x: index - 1,
        barsSpace: barsSpace,
        showingTooltipIndicators: isTouched ? [0] : [],
        barRods: [
          BarChartRodData(
            toY:  views[index] as double,
            color: Theme.of(context).colorScheme.background,
            rodStackItems: [
              BarChartRodStackItem(0, comments[index] as double, Theme.of(context).colorScheme.primary,
                BorderSide(
                  color: Colors.white,
                  width: isTouched ? 2 : 0,
                ),),
              BarChartRodStackItem(comments[index] as double , likes[index] as double , Theme.of(context).colorScheme.primary.withOpacity(0.5),
                BorderSide(
                  color: Colors.white,
                  width: isTouched ? 2 : 0,
                ),),
              BarChartRodStackItem(likes[index] as double , views[index] as double , Theme.of(context).colorScheme.primary.withOpacity(0.8),
                BorderSide(
                  color: Colors.white,
                  width: isTouched ? 2 : 0,
                ),),

            ],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10)
            ),
            width: barsWidth,
          ),
        ],
      );
    });
  }
}
