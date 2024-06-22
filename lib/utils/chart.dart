import 'package:budget_buddy/utils/colors.dart';
import 'package:budget_buddy/utils/common.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

List<Color> gradientColors = [primary];

LineChartData mainData(List<FlSpot> spots) {
  return LineChartData(
    gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 0.1,
          );
        }),
    titlesData: FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          //  getTextStyles: (value) =>
          //   const TextStyle(color: Color(0xff68737d), fontSize: 12),
          getTitlesWidget: (value, meta) {
            return Text(
              getOrdinal(value),
              style: secondaryTextStyle(color: Color(0xff68737d), fontSize: 8),
            );
          },
          //  margin: 8,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            return Text(
              NumberFormat.compact().format(value),
              style: secondaryTextStyle(color: Color(0xff68737d), fontSize: 8),
            );
          },
          reservedSize: 28,
        ),
        //  margin: 12,
      ),
    ),
    borderData: FlBorderData(
      show: false,
    ),
    minX: 1,
    minY: 0,
    lineBarsData: [
      LineChartBarData(
        spots: spots,
        isCurved: true,
        color: secondaryColor,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
      ),
    ],
  );
}
