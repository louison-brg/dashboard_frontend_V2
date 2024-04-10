import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../animation/slide_in_animation.dart';
import '../models/view_info.dart';
import '../widgets/legend_list_widget.dart';

class ViewersChart1 extends StatefulWidget {
  final Color baseColor;
  final String creatorName;

  ViewersChart1({
    Key? key,
    required this.baseColor,
    required this.creatorName, required List views, required List dates,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ViewersChartState();
}

class ViewersChartState extends State<ViewersChart1> {
  String get creatorName => widget.creatorName;
  late InfoChart infoChart = InfoChart(widget.creatorName);
  bool _isLoading = true;
  Color get baseColor => widget.baseColor;
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    setState(() {
      _isLoading = true; // Mettre _isLoading à true avant de charger les données
    });

    await infoChart.loadJsonData(widget.creatorName);

    setState(() {
      _isLoading = false; // Mettre _isLoading à false une fois les données chargées
    });
  }

  Widget bottomTitles(double value, TitleMeta meta)  {
    final brightness = ThemeData.estimateBrightnessForColor(baseColor);
    final textColor = brightness == Brightness.dark ? Colors.white : Colors.black;
    final style = TextStyle(fontSize: 10, color: textColor);
    List<String> dates = infoChart.getDates();
    String text;
    switch (value.toInt()) {
      case 1:
        text = dates[3];
        break;
      case 2:
        text = dates[2];
        break;
      case 3:
        text = dates[1];
        break;
      case 4:
        text = dates[0];
        break;
      default:
        text = dates[4];
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
    return SlideInAnimation(
      direction: SlideDirection.fromBottom,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nombre de vues",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            LegendsListWidget(
              legends: [
                Legend("Views", Theme.of(context).colorScheme.primary),
              ],
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
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> getData(BuildContext context, barsCount, double barsWidth, double barsSpace) {
    if (_isLoading){
      const CircularProgressIndicator();
    }
    return List.generate(barsCount, (index) {
      final videoIndex = index + 1;
      List<int> views = infoChart.getViews();
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
              BarChartRodStackItem(0, views[index] as double, Theme.of(context).colorScheme.primary,
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

class ViewersChart2 extends StatefulWidget {
  final Color baseColor;
  final String creatorName;

  ViewersChart2({
    Key? key,
    required this.baseColor,
    required this.creatorName, required List likes, required List comments,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ViewersChartState2();
}

class ViewersChartState2 extends State<ViewersChart2> {
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
      case 1:
        text = dates[3];
        break;
      case 2:
        text = dates[2];
        break;
      case 3:
        text = dates[1];
        break;
      case 4:
        text = dates[0];
        break;
      default:
        text = dates[4];
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
    return SlideInAnimation(
      direction: SlideDirection.fromBottom,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Like et Commentaires",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            LegendsListWidget(
              legends: [
                Legend("Comments", Theme.of(context).colorScheme.secondary),
                Legend("Like", Theme.of(context).colorScheme.secondary.withOpacity(0.5)),
              ],
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
                                case 1:
                                  title = 'Comments';
                                  break;
                                case 0:
                                  title = 'Likes';
                                  break;
                                default:
                                  title = '';
                                  break;
                              }
                              return BarTooltipItem(
                                '$title : ${infoChart.getLikes()[groupIndex]}\nComments : ${infoChart.getComments()[groupIndex]}',
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
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> getData(BuildContext context, barsCount, double barsWidth, double barsSpace) {
    if (_isLoading) {
      const CircularProgressIndicator();
    }
    return List.generate(barsCount, (index) {
      final videoIndex = index + 1;
      List<int> likes = infoChart.getLikes();
      List<int> comments = infoChart.getComments();
      final isTouched = touchedIndex == index;
      return BarChartGroupData(
        x: index - 1,
        barsSpace: barsSpace,
        showingTooltipIndicators: isTouched ? [0] : [],
        barRods: [
          BarChartRodData(
            toY: likes[index] + comments[index] as double,
            color: Theme.of(context).colorScheme.background,
            rodStackItems: [
              BarChartRodStackItem(
                0,
                comments[index] as double,
                Theme.of(context).colorScheme.secondary,
                BorderSide(
                  color: Colors.white,
                  width: isTouched ? 2 : 0,
                ),
              ),
              BarChartRodStackItem(
                comments[index] as double,
                likes[index] as double,
                Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                BorderSide(
                  color: Colors.white,
                  width: isTouched ? 2 : 0,
                ),
              ),
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            width: barsWidth,
          ),
        ],
      );
    });
  }
}

class ViewersChart3 extends StatefulWidget {
  final Color baseColor;
  final String creatorName;

  ViewersChart3({
    Key? key,
    required this.baseColor,
    required this.creatorName, required List likes, required List views, required List comments,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ViewersChartState3();
}

class ViewersChartState3 extends State<ViewersChart3> {
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
      case 1:
        text = dates[3];
        break;
      case 2:
        text = dates[2];
        break;
      case 3:
        text = dates[1];
        break;
      case 4:
        text = dates[0];
        break;
      default:
        text = dates[4];
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
    return SlideInAnimation(
      direction: SlideDirection.fromBottom,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ratio Like/Vues",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            LegendsListWidget(
              legends: [
                Legend("Ratio Likes/Views", Theme.of(context).colorScheme.tertiary),
              ],
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
                                  title = 'Ratio like/views';
                                  break;
                                default:
                                  title = '';
                                  break;
                              }
                              return BarTooltipItem(
                                '$title : ${rod.toY.round()}%',
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
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> getData(BuildContext context, barsCount, double barsWidth, double barsSpace) {
    return List.generate(barsCount, (index) {
      final videoIndex = index + 1;
      List<int> likes = infoChart.getLikes();
      List<int> views = infoChart.getViews();
      List<int> comments = infoChart.getComments();
      List<double> ratio = [];
      for (int i = 0; i < videoIndex; i++) {
        // Calculer le ratio like/vue
        double likeCount = likes[i].toDouble();
        double viewCount = views[i].toDouble();
        double ratioValue = viewCount != 0 ? (likeCount / viewCount) * 100 : 0;
        ratio.add(ratioValue);
      }
      final isTouched = touchedIndex == index;
      return BarChartGroupData(
        x: index - 1,
        barsSpace: barsSpace,
        showingTooltipIndicators: isTouched ? [0] : [],
        barRods: [
          BarChartRodData(
            toY: ratio[index],
            color: Theme.of(context).colorScheme.background,
            rodStackItems: [
              BarChartRodStackItem(
                0,
                ratio[index],
                Theme.of(context).colorScheme.tertiary,
                BorderSide(
                  color: Colors.white,
                  width: isTouched ? 2 : 0,
                ),
              ),
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            width: barsWidth,
          ),
        ],
      );
    });
  }
}