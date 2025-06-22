import 'package:flutter/material.dart';
import 'package:immuno_warriors/shared/ui/app_styles.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';

class DataTableWidget extends StatelessWidget {
  final List<String> headers;
  final List<List<String>> rows;
  final List<double>? columnWidths;
  final EdgeInsets? padding;
  final Color? headerColor;
  final Color? rowColor;
  final Border? border;

  const DataTableWidget({
    super.key,
    required this.headers,
    required this.rows,
    this.columnWidths,
    this.padding,
    this.headerColor,
    this.rowColor,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: rowColor ?? AppColors.secondaryColor,
        borderRadius: BorderRadius.circular(8.0),
        border: border,
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16.0),
        child: Table(
          columnWidths: _getColumnWidths(),
          border: TableBorder.all(color: AppColors.borderColor, width: 1.0),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            _buildHeader(headerColor ?? AppColors.primaryColor),
            ..._buildRows(),
          ],
        ),
      ),
    );
  }

  Map<int, TableColumnWidth> _getColumnWidths() {
    if (columnWidths == null) {
      return const <int, TableColumnWidth>{}; // Utiliser les largeurs par défaut
    }
    return { for (var item in List.generate(columnWidths!.length, (index) => index)) item : FixedColumnWidth(columnWidths![item]) };
  }

  TableRow _buildHeader(Color color) {
    return TableRow(
      decoration: BoxDecoration(
        color: color,
      ),
      children: headers.map((header) => _buildTableCell(header, AppStyles.titleSmall)).toList(),
    );
  }

  List<TableRow> _buildRows() {
    return rows.map((row) => TableRow(
      children: row.map((cell) => _buildTableCell(cell, AppStyles.bodyMedium)).toList(),
    )).toList();
  }

  Widget _buildTableCell(String text, TextStyle style) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Text(text, style: style),
    );
  }
}