import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/controllers/taskController.dart';
import 'package:todo_app/screens/themes.dart';
import 'package:todo_app/widgets/button.dart';
import 'package:todo_app/widgets/inputField.dart';
import 'package:todo_app/models/task.dart';

class EditTaskPage extends StatefulWidget {
  final Task task;
  const EditTaskPage({super.key, required this.task});

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final TaskController _taskController = Get.put(TaskController());

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late DateTime _selectedDate;
  late String _startTime;
  late String _endTime;
  late int _id;

  List<Color> colors = [primaryColor, yellowColor, pinkColor];

  late int _selectedColor;

  @override
  void initState() {
    super.initState();
    _id = widget.task.id!;
    _selectedDate =
        DateFormat.yMd().parse(widget.task.date!); // Convert back to DateTime;
    _startTime = widget.task.startTime!;
    _endTime = widget.task.endTime!;
    _selectedColor = widget.task.color!;
    _titleController.text = widget.task.title!;
    _descriptionController.text = widget.task.description!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      backgroundColor: context.theme.colorScheme.background,
      body: Center(
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InputField(
                  text: "Task",
                  hint: "Enter Task Name",
                  controller: _titleController,
                ),
                InputField(
                  text: "Description",
                  hint: "Enter Task Description",
                  controller: _descriptionController,
                ),
                InputField(
                  text: "Date",
                  hint: DateFormat.yMd().format(_selectedDate),
                  widget: IconButton(
                    onPressed: () {
                      _showCalendar(context);
                    },
                    icon: const Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: InputField(
                        text: "Start Time",
                        hint: _startTime,
                        widget: IconButton(
                          onPressed: () {
                            _getTime(isStartTime: true);
                          },
                          icon: const Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: InputField(
                        text: "End Time",
                        hint: _endTime,
                        widget: IconButton(
                          onPressed: () {
                            _getTime(isStartTime: false);
                          },
                          icon: const Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _colorPalette(),
                      Container(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                MyButton(
                  height: 55,
                  width: double.maxFinite,
                  label: "Update Task",
                  onTap: () {
                    _validateForm();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _validateForm() async {
    if (_titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty) {
      await _save();
      Get.back();
    } else if (_titleController.text.isEmpty) {
      Get.snackbar(
        "Required",
        "Title is required",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Get.isDarkMode ? Colors.black : Colors.grey[700],
        icon: const Icon(Icons.warning_amber_rounded),
      );
    } else if (_descriptionController.text.isEmpty) {
      Get.snackbar(
        "Required",
        "Description is required",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        icon: const Icon(Icons.warning_amber_rounded),
      );
    }
  }

  _colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: titleStyle,
        ),
        Wrap(
          children: List<Widget>.generate(3, (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 5),
                child: CircleAvatar(
                  backgroundColor: colors[index],
                  radius: 14,
                  child: _selectedColor == index
                      ? const Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 20,
                        )
                      : Container(),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  _appBar(BuildContext context) {
    return AppBar(
      title: Text(
        "Edit Task",
        style: headingStyle,
      ),
      elevation: 0,
      backgroundColor: context.theme.colorScheme.background,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: Get.isDarkMode ? Colors.white : Colors.black,
          size: 20,
        ),
      ),
      actions: const [
        CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage('images/profile.png'),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }

  _showCalendar(BuildContext context) async {
    DateTime? datePicker = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2030),
    );
    if (datePicker != null) {
      setState(() {
        _selectedDate = datePicker;
      });
    }
  }

  _getTime({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker(isStartTime: isStartTime);
    if (pickedTime == null) {
      print("time cancelled");
    } else {
      String formattedTime = pickedTime.format(context);
      setState(() {
        if (isStartTime) {
          _startTime = formattedTime;
        } else {
          _endTime = formattedTime;
        }
      });
    }
  }

  _showTimePicker({required bool isStartTime}) {
    final time = isStartTime ? _startTime : _endTime;
    final timeOfDay = TimeOfDay(
      hour: int.parse(time.split(":")[0]),
      minute: int.parse(time.split(":")[1].split(" ")[0]),
    );

    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: timeOfDay,
    );
  }

  _save() async {
    await _taskController.updateTask(
      task: Task(
        id: _id,
        title: _titleController.text,
        description: _descriptionController.text,
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        color: _selectedColor,
        isCompleted: 0,
      ),
    );
  }
}
