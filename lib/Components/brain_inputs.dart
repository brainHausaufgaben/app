import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/navigation_helper.dart';
import 'package:brain_app/Components/point_element.dart';
import 'package:flutter/material.dart';
import 'package:brain_app/Backend/design.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_rounded_date_picker/src/dialogs/flutter_rounded_date_picker_dialog.dart';
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:url_launcher/url_launcher.dart';

class BrainTextField extends StatefulWidget {
  BrainTextField({
    Key? key,
    required this.placeholder,
    required this.controller,
    this.minLines,
    this.maxLines,
    this.maxLength,
  }) : super(key: key);

  TextEditingController controller;
  final String placeholder;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;

  @override
  State<StatefulWidget> createState() => _BrainTextField();
}

class _BrainTextField extends State<BrainTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppDesign.current.boxStyle.inputBorderRadius
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          TextField(
            minLines: widget.minLines ?? 1,
            maxLines: widget.maxLines ?? 5,
            autocorrect: true,
            controller: widget.controller,
            style: AppDesign.current.textStyles.input,
            decoration: InputDecoration (
              filled: true,
              enabledBorder: UnderlineInputBorder(
                  borderRadius: AppDesign.current.boxStyle.inputBorderRadius,
                  borderSide: BorderSide(
                      width: 4,
                      color: AppDesign.current.textStyles.color
                  )
              ),
              fillColor: AppDesign.current.boxStyle.backgroundColor,
              label: Text(
                  widget.placeholder,
                  style: AppDesign.current.textStyles.input
              ),
            ),
            inputFormatters: widget.maxLength != null ? [
              LengthLimitingTextInputFormatter(widget.maxLength),
            ] : null,
            onChanged: (_) => setState(() {}),
          ),
          if (widget.maxLength != null) Positioned(
            right: 10,
            top: 9,
            child: Text(
                "${widget.controller.text.length.toString()}/${widget.maxLength}",
                style: TextStyle(
                    color: AppDesign.current.textStyles.color,
                    fontSize: 10
                )
            ),
          )
        ],
      ),
    );
  }
}

class BrainDropdownEntry<ItemType> {
  BrainDropdownEntry({
    required this.value,
    required this.child
  });

  ItemType value;
  Widget child;
}

class BrainDropdown<ItemType> extends StatefulWidget {
  const BrainDropdown({
    Key? key,
    required this.defaultText,
    required this.currentValue,
    required this.items,
    required this.onChanged,
    this.dialogTitle,
    this.additionalAction
  }) : super(key: key);

  final String? dialogTitle;
  final String defaultText;
  final ItemType currentValue;
  final List<BrainDropdownEntry> items;
  final Widget? additionalAction;
  final void Function(dynamic) onChanged;

  static List<BrainDropdownEntry> getSubjectDropdowns(){
    List<BrainDropdownEntry> subjects = [];
    for(Subject subject in TimeTable.subjects){
      subjects.add(
          BrainDropdownEntry(
            value: subject,
            child: PointElement(primaryText: subject.name, color: subject.color)
          )
      );
    }
    return subjects;
  }

  @override
  State<StatefulWidget> createState() => _BrainDropdown();
}

class _BrainDropdown extends State<BrainDropdown> {
  late List<bool> radioValues;
  bool isOpen = false;

  @override
  void initState() {
    radioValues = List.filled(widget.items.length, false);
    super.initState();
  }

  List<Widget> getButtons(BuildContext context) {
    List<Widget> buttons = [];

    for (int i=0; i<widget.items.length; i++) {
      buttons.add(
          Container(
            decoration: BoxDecoration(
              borderRadius: AppDesign.current.boxStyle.inputBorderRadius,
            ),
            clipBehavior: Clip.hardEdge,
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onChanged(widget.items[i].value);
              },
              style: TextButton.styleFrom(
                  backgroundColor: widget.items[i].value == widget.currentValue ? AppDesign.current.themeData.scaffoldBackgroundColor : Colors.transparent
              ),
              child: widget.items[i].child,
            )
          )
      );
    }

    return buttons;
  }

  Widget? getCorrespondingChild() {
    for (BrainDropdownEntry entry in widget.items) {
      if (entry.value == widget.currentValue) return entry.child;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BrainIconButton(
      child: getCorrespondingChild() ?? Text(widget.defaultText, style: AppDesign.current.textStyles.input),
      icon: isOpen ? Icons.arrow_drop_up_outlined : Icons.arrow_drop_down_outlined,
      action: () {
        setState(() => isOpen = true);
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                actions: [
                  Row(
                    mainAxisAlignment: widget.additionalAction != null ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
                    children: [
                      if (widget.additionalAction != null) widget.additionalAction!,
                      TextButton(
                        child: Text("Abbrechen"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  )
                ],
                backgroundColor: AppDesign.current.boxStyle.backgroundColor,
                title: widget.dialogTitle == null ? Text("Wähle ein Fach") : Text(widget.dialogTitle!),
                content: widget.items.length > 6 ? Container(
                  constraints: const BoxConstraints(maxHeight: 400),
                  child: ScrollShadow(
                    color: AppDesign.current.themeData.scaffoldBackgroundColor.withOpacity(0.8),
                    curve: Curves.ease,
                    size: 15,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: getButtons(context),
                      )
                    )
                  )
                ) : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: getButtons(context),
                )
              );
            }
        ).then((value) => setState(() => isOpen = false));
      }
    );
  }
}

class BrainDateButton extends StatelessWidget {
  const BrainDateButton({
    Key? key,
    required this.value,
    required this.onDateSelect,
    required this.text,
    this.selectedSubject,
  }) : super(key: key);

  final Function(DateTime) onDateSelect;
  final Subject? selectedSubject;
  final DateTime value;
  final String text;

  String getDateString(DateTime date){
    List weekDays = ["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag"];
    String day = date.day.toString();
    String month = date.month.toString();
    String year = date.year.toString();
    String weekDay =  weekDays[date.weekday - 1];
    return weekDay + ", " + day + "." + month + "." + year;
  }

  Widget getPicker() {
    return FlutterRoundedDatePickerDialog(
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      borderRadius: 10,
      height: 300,
      era: EraMode.CHRIST_YEAR,
      lastDate: DateTime(DateTime.now().year + 1),
      initialDatePickerMode: DatePickerMode.day,
      styleDatePicker: MaterialRoundedDatePickerStyle(
        backgroundHeader: AppDesign.current.primaryColor,
        paddingMonthHeader: const EdgeInsets.all(11),
        backgroundPicker: AppDesign.current.boxStyle.backgroundColor,
        textStyleDayOnCalendar: TextStyle(color: AppDesign.current.textStyles.color),
        textStyleDayOnCalendarDisabled: TextStyle(color: AppDesign.current.textStyles.color.withOpacity(0.5)),
        textStyleMonthYearHeader: TextStyle(color: AppDesign.current.textStyles.color),
        textStyleDayHeader: TextStyle(color: AppDesign.current.textStyles.color),
        colorArrowNext: AppDesign.current.textStyles.color,
        colorArrowPrevious: AppDesign.current.textStyles.color,
      ),
      builderDay: (DateTime dateTime, bool isCurrentDay, bool isSelected, TextStyle defaultTextStyle) {
        // Default
        if (isSelected) {
          return Container(
              decoration: BoxDecoration(color: AppDesign.current.primaryColor, shape: BoxShape.circle),
              child: Center(
                  child: Text(
                    dateTime.day.toString(),
                    style: defaultTextStyle,
                  )
              )
          );
        }

        if (selectedSubject != null) {
          DateTime now = DateTime.now();

          if (dateTime.day >= now.day || dateTime.month > now.month) {
            if (TimeTable.getSubjectsByDate(dateTime).contains(selectedSubject)) {
              return Container(
                  decoration: BoxDecoration(
                    color: selectedSubject!.color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                      child: Text(dateTime.day.toString(), style: defaultTextStyle)
                  )
              );
            }
          }
        }
        // Default
        return Center(
            child: Text(
              dateTime.day.toString(),
              style: defaultTextStyle,
            )
        );
      }
    );
  }

  Widget builder(BuildContext context) {
    if (MediaQuery.of(context).size.width > AppDesign.breakPointWidth) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 1000, maxHeight: 600),
            child: Theme(
              data: AppDesign.current.themeData,
              child: getPicker()
            )
          )
        ]
      );
    } else {
      return Theme(
        data: AppDesign.current.themeData,
        child: getPicker()
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BrainIconButton(
      child: Text(value.year == 10 ? text : getDateString(value), style: AppDesign.current.textStyles.input),
      icon: Icons.date_range,
      action: () {
        Future<DateTime?> selectedDate = showDialog(
          context: context,
          builder: (context) => builder(context)
        );

        selectedDate.then((selectedDate) => onDateSelect(selectedDate ?? value));
      }
    );
  }
}

class BrainIconButton extends StatelessWidget {
  const BrainIconButton({
    Key? key,
    required this.action,
    required this.icon,
    this.child,
    this.dense = false
  }) : super(key: key);

  final Function() action;
  final Widget? child;
  final IconData icon;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppDesign.current.boxStyle.inputBorderRadius
      ),
      clipBehavior: Clip.antiAlias,
      child: TextButton(
        onPressed: action,
        style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: dense ? 11 : 14, horizontal: 12),
            backgroundColor: AppDesign.current.boxStyle.backgroundColor
        ),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            if (child != null) Expanded(
              child: child!
            ),
            Icon(icon, color: AppDesign.current.textStyles.color, size: dense ? 20 : 24),
          ],
        ),
      ),
    );
  }
}

class BrainColorPicker extends StatelessWidget {
  const BrainColorPicker({
    Key? key,
    required this.pickerColor,
    required this.onColorSelect,
    this.asIconButton = true
  }) : super(key: key);

  final Color pickerColor;
  final bool asIconButton;
  final Function(Color) onColorSelect;

  @override
  Widget build(BuildContext context) {
    return asIconButton ? Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100)
      ),
      clipBehavior: Clip.hardEdge,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: pickerColor,
          padding: EdgeInsets.zero,
        ),
        child: Icon(
            Icons.color_lens_outlined,
            color: pickerColor.computeLuminance() < 0.5 ? Colors.white : Colors.black
        ),
        onPressed: () => showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text("Farbe auswählen", style: TextStyle(color: AppDesign.current.textStyles.color)),
              backgroundColor: AppDesign.current.boxStyle.backgroundColor,
              content: MaterialPicker(
                  pickerColor: pickerColor,
                  onColorChanged: onColorSelect
              ),
            );
          }
        )
      ),
    ) : TextButton(
      style: TextButton.styleFrom(
        primary: AppDesign.current.primaryColor,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: asIconButton ? BorderRadius.circular(100) : AppDesign.current.boxStyle.inputBorderRadius,
          color: AppDesign.current.boxStyle.backgroundColor
        ),
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: asIconButton ? 14 : 12),
        child: asIconButton ? const Icon(Icons.color_lens_outlined) : Row(
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
      onPressed: () => showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("Farbe auswählen", style: TextStyle(color: AppDesign.current.textStyles.color)),
            backgroundColor: AppDesign.current.boxStyle.backgroundColor,
            content: MaterialPicker(
              pickerColor: pickerColor,
              onColorChanged: onColorSelect
            ),
          );
        }
      )
    );
  }
}

class SettingsNavigatorButton extends StatelessWidget {
  const SettingsNavigatorButton({
    Key? key,
    required this.text,
    required this.action
  }) : super(key: key);

  final String text;
  final Function() action;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: action,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: AppDesign.current.textStyles.settingsSubMenu),
          Icon(Icons.arrow_forward_ios_rounded, color: AppDesign.current.textStyles.color, size: 20)
        ],
      ),
    );
  }
}

class SettingsLinkButton extends StatelessWidget {
  const SettingsLinkButton({
    Key? key,
    required this.text,
    required this.link
  }) : super(key: key);

  final String text;
  final String link;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Uri url = Uri.parse(link);
        launchUrl(url, mode: LaunchMode.externalApplication);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: AppDesign.current.textStyles.settingsSubMenu),
          Icon(Icons.open_in_browser, color: AppDesign.current.textStyles.color, size: 20)
        ],
      ),
    );
  }
}

class SettingsSwitchButton extends StatefulWidget {
  const SettingsSwitchButton({
    Key? key,
    required this.text,
    this.description,
    required this.action,
    required this.state
  }) : super(key: key);

  final String text;
  final String? description;
  final Function() action;
  final bool state;

  @override
  State<StatefulWidget> createState() =>  _SettingsSwitchButton();
}

class _SettingsSwitchButton extends State<SettingsSwitchButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        widget.action();
      },
      child: Row(
        crossAxisAlignment: widget.description == null ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.text, style: AppDesign.current.textStyles.settingsSubMenu),
                if (widget.description != null) Text(widget.description!, style: AppDesign.current.textStyles.settingsSubMenuDescription)
              ],
            ),
          ),
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: AppDesign.current.textStyles.color,
                width: 2
              )
            ),
            child: Center(
              child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    color: widget.state ? AppDesign.current.textStyles.color : Colors.transparent,
                    borderRadius: BorderRadius.circular(3)
                  ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SettingsEntry extends StatelessWidget {
  const SettingsEntry({
    Key? key,
    required this.children
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: AppDesign.current.boxStyle.backgroundColor,
        borderRadius: AppDesign.current.boxStyle.borderRadius
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class BrainMenuButton extends StatefulWidget {
  const BrainMenuButton({
    Key? key,
    required this.defaultAction,
    required this.defaultLabel,
    this.withEntries = true,
    this.icon = Icons.add,
  }) : super(key: key);

  final Function() defaultAction;
  final bool withEntries;
  final IconData icon;
  final String defaultLabel;

  SpeedDialChild getHomeworkMenu(BuildContext context) {
    return SpeedDialChild(
        backgroundColor: AppDesign.current.primaryColor,
        foregroundColor: AppDesign.current.textStyles.contrastColor,
        labelBackgroundColor: AppDesign.current.primaryColor,
        labelStyle: TextStyle(color: AppDesign.current.textStyles.contrastColor),
        labelWidget: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
              color: AppDesign.current.primaryColor,
              borderRadius: AppDesign.current.boxStyle.inputBorderRadius
          ),
          child: Text("Neue Hausaufgabe", style: AppDesign.current.textStyles.pointElementSecondary.copyWith(color: AppDesign.current.textStyles.contrastColor)),
        ),
        child: const Icon(Icons.description_rounded),
        onTap: () => NavigationHelper.pushNamed(context, "homework")
    );
  }

  SpeedDialChild getEventMenu(BuildContext context) {
    return SpeedDialChild(
        backgroundColor: AppDesign.current.primaryColor,
        foregroundColor: AppDesign.current.textStyles.contrastColor,
        labelBackgroundColor: AppDesign.current.primaryColor,
        labelStyle: TextStyle(color: AppDesign.current.textStyles.contrastColor),
        labelWidget: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
              color: AppDesign.current.primaryColor,
              borderRadius: AppDesign.current.boxStyle.inputBorderRadius
          ),
          child: Text("Neues Event", style: AppDesign.current.textStyles.pointElementSecondary.copyWith(color: AppDesign.current.textStyles.contrastColor)),
        ),
        child: const Icon(Icons.schedule_rounded),
        onTap: () => NavigationHelper.pushNamed(context, "addEventPage")

    );
  }

  SpeedDialChild getGradesMenu(BuildContext context) {
    return SpeedDialChild(
        backgroundColor: AppDesign.current.primaryColor,
        foregroundColor: AppDesign.current.textStyles.contrastColor,
        labelBackgroundColor: AppDesign.current.primaryColor,
        labelStyle: TextStyle(color: AppDesign.current.textStyles.contrastColor),
        labelWidget: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: AppDesign.current.primaryColor,
            borderRadius: AppDesign.current.boxStyle.inputBorderRadius
          ),
          child: Text("Neue Note", style: AppDesign.current.textStyles.pointElementSecondary.copyWith(color: AppDesign.current.textStyles.contrastColor)),
        ),
        child: const Icon(Icons.grading),
        onTap: () => NavigationHelper.pushNamed(context, "gradesPage")
    );
  }

  @override
  State<StatefulWidget> createState() => _BrainMenuButton();
}

class _BrainMenuButton extends State<BrainMenuButton> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      onOpen: () => controller.forward().then(
              (value) => !widget.withEntries ? controller.reset() : null
      ),
      onPress: () => widget.defaultAction(),
      onClose: () => controller.reverse(),
      child: RotationTransition(
        turns: Tween(begin: 0.0, end: widget.withEntries ? 5 / 8 : 1.0).animate(CurvedAnimation(
            parent: controller,
            curve: Curves.easeInOutBack
        )),
        child: Icon(widget.icon, color: AppDesign.current.textStyles.contrastColor)
      ),
      children: widget.withEntries ? [
        widget.getHomeworkMenu(context),
        widget.getEventMenu(context),
        widget.getGradesMenu(context)
      ] : [],
      overlayColor: Colors.black,
      overlayOpacity: 0.6,
      spacing: 5,
      childrenButtonSize: const Size(50, 50),
      childPadding: const EdgeInsets.only(right: 6),
      animationDuration: const Duration(milliseconds: 200),
      label: MediaQuery.of(context).size.width > AppDesign.breakPointWidth ? Text(widget.defaultLabel, style: const TextStyle(letterSpacing: 0.5)) : null,
    );
  }
}