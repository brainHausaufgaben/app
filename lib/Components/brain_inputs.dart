import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/subject.dart';
import 'package:brain_app/Backend/time_table.dart';
import 'package:brain_app/Components/navigation_helper.dart';
import 'package:brain_app/Components/point_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_rounded_date_picker/src/dialogs/flutter_rounded_date_picker_dialog.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:url_launcher/url_launcher.dart';

class BrainTextField extends StatefulWidget {
  BrainTextField({
    Key? key,
    required this.placeholder,
    required this.controller,
    this.minLines,
    this.maxLines,
    this.maxLength,
    this.autofocus = false
  }) : super(key: key);

  TextEditingController controller;
  final String placeholder;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final bool autofocus;

  @override
  State<StatefulWidget> createState() => _BrainTextField();
}

class _BrainTextField extends State<BrainTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppDesign.boxStyle.inputBorderRadius
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          TextField(
            autofocus: widget.autofocus,
            minLines: widget.minLines ?? 1,
            maxLines: widget.maxLines ?? 5,
            textCapitalization: TextCapitalization.sentences,
            autocorrect: true,
            controller: widget.controller,
            style: AppDesign.textStyles.input.copyWith(height: 0.9),
            decoration: InputDecoration (
              filled: true,
              enabledBorder: UnderlineInputBorder(
                  borderRadius: AppDesign.boxStyle.inputBorderRadius,
                  borderSide: BorderSide(
                      width: 4,
                      color: AppDesign.colors.text
                  )
              ),
              fillColor: AppDesign.colors.secondaryBackground,
              label: Text(
                  widget.placeholder,
                  style: AppDesign.textStyles.input
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
                    color: AppDesign.colors.text,
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
   BrainDropdown.fromMap({
     Key? key,
     required Map<ItemType, Widget> entries,
     required this.defaultText,
     required this.currentValue,
     required this.onChanged,
     required this.dialogTitle,
     this.additionalAction
  }) : super(key: key) {
    items = [];
    entries.forEach((key, value) {
      items.add(BrainDropdownEntry(
        value: key,
        child: value
      ));
    });
  }

  BrainDropdown({
    Key? key,
    required this.defaultText,
    required this.currentValue,
    required this.items,
    required this.onChanged,
    required this.dialogTitle,
    this.additionalAction
  }) : super(key: key);

  final String dialogTitle;
  final String defaultText;
  final ItemType currentValue;
  late List<BrainDropdownEntry> items;
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
              borderRadius: AppDesign.boxStyle.inputBorderRadius,
            ),
            clipBehavior: Clip.hardEdge,
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onChanged(widget.items[i].value);
              },
              style: TextButton.styleFrom(
                  backgroundColor: widget.items[i].value == widget.currentValue ? AppDesign.colors.background : Colors.transparent
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
      child: getCorrespondingChild() ?? Text(widget.defaultText, style: AppDesign.textStyles.input),
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
                        child: Text("Abbrechen", style: TextStyle(color: AppDesign.colors.primary)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  )
                ],
                backgroundColor: AppDesign.colors.secondaryBackground,
                title: Text(widget.dialogTitle, style: AppDesign.textStyles.alertDialogHeader),
                content: Container(
                  constraints: const BoxConstraints(maxHeight: 400),
                  child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: getButtons(context),
                      )
                  )
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
    this.todayAsDefault = false
  }) : super(key: key);

  final Function(DateTime) onDateSelect;
  final Subject? selectedSubject;
  final DateTime value;
  final bool todayAsDefault;
  final String text;

  String getDateString(DateTime date){
    List weekDays = ["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag"];
    String day = date.day.toString();
    String month = date.month.toString();
    String year = date.year.toString();
    String weekDay =  weekDays[date.weekday - 1];
    return "$weekDay, $day.$month.$year";
  }

  Widget getPicker() {
    return FlutterRoundedDatePickerDialog(
      initialDate: todayAsDefault ? DateTime.now() : value,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      borderRadius: 10,
      height: 300,
      era: EraMode.CHRIST_YEAR,
      lastDate: DateTime.now().add(const Duration(days: 120)),
      initialDatePickerMode: DatePickerMode.day,
      styleDatePicker: MaterialRoundedDatePickerStyle(
        backgroundHeader: AppDesign.colors.primary,
        paddingMonthHeader: const EdgeInsets.all(11),
        backgroundPicker: AppDesign.colors.secondaryBackground,
        textStyleDayOnCalendar: TextStyle(color: AppDesign.colors.text),
        textStyleDayOnCalendarDisabled: TextStyle(color: AppDesign.colors.text05),
        textStyleMonthYearHeader: TextStyle(color: AppDesign.colors.text),
        textStyleDayHeader: TextStyle(color: AppDesign.colors.text),
        colorArrowNext: AppDesign.colors.text,
        colorArrowPrevious: AppDesign.colors.text,
      ),
      styleYearPicker: MaterialRoundedYearPickerStyle(
        backgroundPicker: AppDesign.colors.secondaryBackground,
        textStyleYear: TextStyle(
          color: AppDesign.colors.text,
          fontSize: 18
        ),
        textStyleYearSelected: TextStyle(
          color: AppDesign.colors.text,
          fontWeight: FontWeight.w600,
          fontSize: 22
        )
      ),
      builderDay: (DateTime dateTime, bool isCurrentDay, bool isSelected, TextStyle defaultTextStyle) {
        // Default
        if (isSelected) {
          return Container(
              decoration: BoxDecoration(color: AppDesign.colors.primary, shape: BoxShape.circle),
              child: Center(
                  child: Text(
                    dateTime.day.toString(),
                    style: defaultTextStyle,
                  )
              )
          );
        } else if (isCurrentDay) {
          return Container(
              decoration: BoxDecoration(color: AppDesign.colors.background, shape: BoxShape.circle),
              child: Center(
                  child: Text(
                    dateTime.day.toString(),
                  )
              )
          );
        } else if (selectedSubject != null) {
          DateTime now = DateTime.now();

          if (dateTime.day >= now.day || dateTime.month > now.month) {
            if (TimeTable.getSubjectsByDate(dateTime).contains(selectedSubject)) {
              return Container(
                  decoration: BoxDecoration(
                    color: selectedSubject!.color.withOpacity(0.4),
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
              data: AppDesign.themeData,
              child: getPicker()
            )
          )
        ]
      );
    } else {
      return Theme(
        data: AppDesign.themeData,
        child: getPicker()
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BrainIconButton(
      child: Text(value.year == 10 ? text : getDateString(value), style: AppDesign.textStyles.input),
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
    required this.child,
    this.dense = false
  }) : super(key: key);

  final Function() action;
  final Widget child;
  final IconData icon;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: AppDesign.boxStyle.inputBorderRadius
      ),
      clipBehavior: Clip.antiAlias,
      child: TextButton(
        onPressed: action,
        style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: dense ? 11 : 15, horizontal: 12),
            backgroundColor: AppDesign.colors.secondaryBackground,
            minimumSize: Size.zero
        ),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              child: child
            ),
            Icon(icon, color: AppDesign.colors.text, size: dense ? 20 : 24)
          ]
        )
      )
    );
  }
}

class BrainColorPicker extends StatelessWidget {
  const BrainColorPicker({
    Key? key,
    required this.pickerColor,
    required this.onColorSelect,
  }) : super(key: key);

  final Color pickerColor;
  final Function(Color) onColorSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100)
      ),
      clipBehavior: Clip.antiAlias,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: pickerColor,
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
              title: Text("Farbe auswählen", style: TextStyle(color: AppDesign.colors.text)),
              backgroundColor: AppDesign.colors.secondaryBackground,
              content: MaterialPicker(
                  pickerColor: pickerColor,
                  onColorChanged: onColorSelect
              )
            );
          }
        )
      )
    );
  }
}

class SettingsColorPicker extends StatelessWidget {
  const SettingsColorPicker({
    Key? key,
    required this.pickerColor,
    required this.onColorSelect,
  }) : super(key: key);

  final Color pickerColor;
  final Function(Color) onColorSelect;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: AppDesign.colors.secondaryBackground
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Akzent Farbe", style: AppDesign.textStyles.settingsSubMenu),
          Container(
            height: 24.0,
            width: 24.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: pickerColor
            )
          )
        ]
      ),
      onPressed: () => showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text("Farbe auswählen", style: AppDesign.textStyles.alertDialogHeader),
              backgroundColor: AppDesign.colors.secondaryBackground,
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
    this.description,
    required this.action,
    this.activated = true
  }) : super(key: key);

  final String text;
  final String? description;
  final bool activated;
  final Function() action;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: activated ? action : null,
      child: Flex(
        direction: Axis.horizontal,
        crossAxisAlignment: description == null ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: activated ? AppDesign.textStyles.settingsSubMenu
                      : AppDesign.textStyles.settingsSubMenu.copyWith(color: AppDesign.colors.text05)
                ),
                if (description != null) Text(
                  description!,
                  style: activated ? AppDesign.textStyles.settingsSubMenuDescription
                      : AppDesign.textStyles.settingsSubMenuDescription.copyWith(color: AppDesign.colors.text05)
                )
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: activated ? AppDesign.colors.text
                             : AppDesign.colors.text05,
            size: 20
          )
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
          Text(text, style: AppDesign.textStyles.settingsSubMenu),
          Icon(Icons.open_in_browser, color: AppDesign.colors.text, size: 20)
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
    return Semantics(
      container: true,
      label: widget.text,
      hint: widget.description,
      excludeSemantics: true,
      checked: widget.state,
      child: TextButton(
        onPressed: () {
          widget.action();
        },
        child: Flex(
          direction: Axis.horizontal,
          crossAxisAlignment: widget.description == null ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.text, style: AppDesign.textStyles.settingsSubMenu),
                  if (widget.description != null) Text(widget.description!, style: AppDesign.textStyles.settingsSubMenuDescription)
                ],
              ),
            ),
            Spacer(),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                      color: AppDesign.colors.text,
                      width: 2
                  )
              ),
              child: Center(
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                      color: widget.state ? AppDesign.colors.text : Colors.transparent,
                      borderRadius: BorderRadius.circular(3)
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SettingsTimePicker extends StatelessWidget {
  const SettingsTimePicker({
    Key? key,
    required this.text,
    required this.onSelect,
    required this.currentTime
  }) : super(key: key);

  final String text;
  final Function(TimeOfDay) onSelect;
  final TimeOfDay currentTime;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return TimePickerDialog(
                initialTime: currentTime
            );
          }
        ).then((value) {
          if (value != null) onSelect(value);
        });
      },
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: AppDesign.textStyles.settingsSubMenu),
          const Spacer(),
          Container(
            padding: const EdgeInsets.only(left: 6),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                    color: AppDesign.colors.text08,
                    width: 1.5
                )
              )
            ),
            child: Text("${currentTime.format(context)} Uhr", style: AppDesign.textStyles.settingsSubMenuDescription),
          )
        ],
      ),
    );
  }
}

class SettingsNumberPicker extends StatelessWidget {
  SettingsNumberPicker({
    Key? key,
    required this.text,
    required this.currentValue,
    required this.action,
    required this.dialogTitle,
    required this.maxValue,
    required this.minValue,
    this.appendToNumber = ""
  }) : super(key: key);

  final String text;
  final int minValue;
  final int maxValue;
  final String dialogTitle;
  final String appendToNumber;
  int currentValue;
  final Function(int) action;

  void numberPickerDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: AppDesign.colors.secondaryBackground,
            title: Text(
              dialogTitle,
              style: AppDesign.textStyles.alertDialogHeader,
            ),
            content: StatefulBuilder(
                builder: (context, setBuilderState) {
                  return NumberPicker(
                      selectedTextStyle: TextStyle(
                          color: AppDesign.colors.primary,
                          fontWeight: FontWeight.w700
                      ),
                      value: currentValue,
                      minValue: minValue,
                      maxValue: maxValue,
                      onChanged: (value) {
                        setBuilderState(() => currentValue = value);
                      }
                  );
                }
            ),

            actions: [
              TextButton(
                child: Text("Ok", style: TextStyle(color: AppDesign.colors.primary)),
                onPressed: () {
                  action(currentValue);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => numberPickerDialog(context),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: AppDesign.textStyles.settingsSubMenu),
          const Spacer(),
          Container(
            padding: const EdgeInsets.only(left: 6),
            decoration: BoxDecoration(
                border: Border(
                    left: BorderSide(
                        color: AppDesign.colors.text08,
                        width: 1.5
                    )
                )
            ),
            child: Text("${currentValue.toString()} $appendToNumber", style: AppDesign.textStyles.settingsSubMenuDescription),
          )
        ],
      ),
    );
  }
}

class SettingsTextField extends StatelessWidget {
  SettingsTextField({
    Key? key,
    this.text,
    this.submitAction
  }) : super(key: key);

  final String? text;
  final Function(String text)? submitAction;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (text != null) Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(text!, style: AppDesign.textStyles.settingsSubMenu),
          ),
          Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: TextField(
                    controller: controller,
                    style: AppDesign.textStyles.input,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(14),
                        isCollapsed: true,
                        border: InputBorder.none,
                        filled: true,
                        fillColor: AppDesign.colors.background
                    ),
                  ),
                ),
              ),
              if (submitAction != null) Padding(
                padding: const EdgeInsets.only(left: 10),
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: AppDesign.colors.contrast,
                    backgroundColor: AppDesign.colors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13)
                  ),
                  onPressed: () {
                    submitAction!(controller.text);
                  },
                  child: Text("Ausführen")
                ),
              )
            ],
          )
        ]
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
        color: AppDesign.colors.secondaryBackground,
        borderRadius: AppDesign.boxStyle.borderRadius
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
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        labelWidget: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppDesign.boxStyle.inputBorderRadius
          ),
          child: const Text(
            "Neue Hausaufgabe",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500
            )
          )
        ),
        child: const Icon(Icons.description_rounded),
        onTap: () => NavigationHelper.pushNamed(context, "homework")
    );
  }

  SpeedDialChild getEventMenu(BuildContext context) {
    return SpeedDialChild(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        labelWidget: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppDesign.boxStyle.inputBorderRadius
            ),
            child: const Text(
                "Neues Event",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500
                )
            )
        ),
        child: const Icon(Icons.schedule_rounded),
        onTap: () => NavigationHelper.pushNamed(context, "addEventPage")

    );
  }

  SpeedDialChild getGradesMenu(BuildContext context) {
    return SpeedDialChild(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        labelWidget: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppDesign.boxStyle.inputBorderRadius
            ),
            child: const Text(
                "Neue Note",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500
                )
            )
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
    return Semantics(
      container: true,
      excludeSemantics: true,
      label: "Hinzufügen Menü",
      hint: "Tippe einmal, oder halte um alle Optionen zu sehen",
      button: true,
      child: SpeedDial(
        elevation: 6.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        onOpen: () => controller.forward().then(
                (value) => !widget.withEntries ? controller.reset() : null
        ),
        onPress: () => widget.defaultAction(),
        onClose: () => controller.reverse(),
        children: widget.withEntries ? [
          widget.getHomeworkMenu(context),
          widget.getEventMenu(context),
          widget.getGradesMenu(context)
        ] : [],
        overlayOpacity: 0.6,
        overlayColor: Colors.black,
        backgroundColor: AppDesign.colors.primary,
        spacing: 5,
        childrenButtonSize: const Size(50, 50),
        childPadding: const EdgeInsets.only(right: 6),
        animationDuration: const Duration(milliseconds: 300),
        label: MediaQuery.of(context).size.width > AppDesign.breakPointWidth ? Text(widget.defaultLabel, style: TextStyle(letterSpacing: 0.5, color: AppDesign.colors.contrast)) : null,
        child: RotationTransition(
            turns: Tween(begin: 0.0, end: widget.withEntries ? 5 / 8 : 1.0).animate(CurvedAnimation(
                parent: controller,
                curve: Curves.easeInOutBack
            )),
            child: Icon(widget.icon, color: AppDesign.colors.contrast)
        )
      )
    );
  }
}