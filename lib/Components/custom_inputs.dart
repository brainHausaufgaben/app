import 'dart:math';

import 'package:brain_app/Components/point_element.dart';
import 'package:flutter/material.dart';
import 'package:brain_app/Backend/theming.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';

class CustomTextField extends TextField {
  CustomTextField({
    Key? key,
    required controller,
    required placeHolder,
    autocorrect
  }) : super(
    key: key,
    autocorrect: autocorrect,
    controller: controller,
    style: AppDesign.current.textStyles.input,
    decoration: InputDecoration (
      filled: true,
      fillColor: AppDesign.current.boxStyle.backgroundColor,
      label: Text(placeHolder, style: AppDesign.current.textStyles.input),
    ),
  );
}

class CustomDropdown<ItemType> extends StatelessWidget {
  CustomDropdown({
    Key? key,
    required this.defaultText,
    required this.currentValue,
    required this.items,
    required this.onChanged
  }) : super(key: key);

  Widget defaultText;
  ItemType currentValue;
  List<DropdownMenuItem<ItemType>> items;
  void Function(dynamic)? onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: BoxDecoration(
            borderRadius: AppDesign.current.boxStyle.inputBorderRadius,
            color: AppDesign.current.boxStyle.backgroundColor
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: DropdownButton<dynamic>(
            isDense: true,
            underline: Container(),
            isExpanded: true,
            dropdownColor: AppDesign.current.boxStyle.backgroundColor,
            style: AppDesign.current.textStyles.input,
            value: currentValue,
            hint: defaultText,
            items: items,
            onChanged: onChanged,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
        )
    );
  }
}

class CustomDateButton extends StatelessWidget {
  CustomDateButton({
    Key? key,
    required this.value,
    required this.onDateSelect,
    required this.text
  }) : super(key: key);

  Function(DateTime) onDateSelect;
  DateTime value;
  String text;

  String getDateString(DateTime date){
    List weekDays = ["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag"];
    String day = date.day.toString();
    String month = date.month.toString();
    String year = date.year.toString();
    String weekDay =  weekDays[date.weekday - 1];
    return weekDay + ", " + day + "." + month + "." + year;
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: AppDesign.current.boxStyle.backgroundColor
      ),
      onPressed: () {
        Future<DateTime?> newDateTime = showRoundedDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(DateTime.now().year - 1),
            lastDate: DateTime(DateTime.now().year + 1),
            borderRadius: 16,
            theme: AppDesign.current.themeData,
            height: 300,
            styleDatePicker: MaterialRoundedDatePickerStyle(
              paddingMonthHeader: const EdgeInsets.all(11),
              backgroundPicker: AppDesign.current.boxStyle.backgroundColor,
              textStyleDayOnCalendar: TextStyle(color: AppDesign.current.textStyles.color),
              textStyleMonthYearHeader: TextStyle(color: AppDesign.current.textStyles.color),
              textStyleDayHeader: TextStyle(color: AppDesign.current.textStyles.color),
              colorArrowNext: AppDesign.current.textStyles.color,
              colorArrowPrevious: AppDesign.current.textStyles.color,
            )
        );
        newDateTime.then((value) => onDateSelect(value!));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(value.year == 10 ? text : getDateString(value), style: AppDesign.current.textStyles.input),
            const Icon(Icons.date_range),
          ],
        ),
      ),
    );
  }
}

class CustomColorPicker extends StatelessWidget {
  CustomColorPicker({
    Key? key,
    required this.pickerColor,
    required this.onColorSelect
  }) : super(key: key);

  Color pickerColor;
  Function(Color) onColorSelect;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: AppDesign.current.boxStyle.inputBorderRadius,
            color: AppDesign.current.boxStyle.backgroundColor
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          child: Row(
            children: [
              Container(
                height: 25.0,
                width: 25.0,
                decoration: BoxDecoration(
                  borderRadius: AppDesign.current.boxStyle.inputBorderRadius,
                  color: pickerColor
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text("Farbe", style: AppDesign.current.textStyles.input),
              )
            ],
          ),
        ),
        style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
        ),
        onPressed: () {showDialog(
            context: context,
            builder: (BuildContext _test) {
              return AlertDialog(
                title: const Text("Farbe auswählen"),
                content: MaterialPicker(pickerColor: pickerColor, onColorChanged: onColorSelect),
              );
            }
        );
        }
    );
  }
}