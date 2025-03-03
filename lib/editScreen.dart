import 'package:flutter/material.dart';
import 'package:account/model/scienceCompetitionItem.dart';
import 'package:provider/provider.dart';
import 'package:account/provider/scienceCompetitionProvider.dart';

class EditScreen extends StatefulWidget {
  final ScienceCompetitionItem item;

  const EditScreen({super.key, required this.item});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final scoreController = TextEditingController();
  final descriptionController = TextEditingController();
  TimeOfDay? selectedTime;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.item.title;
    scoreController.text = widget.item.score.toString();
    descriptionController.text = widget.item.description ?? '';
    selectedTime = widget.item.time ?? TimeOfDay.now();
    selectedDate = widget.item.date ?? DateTime.now();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.deepPurple,
            colorScheme: const ColorScheme.light(primary: Colors.deepPurple),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.deepPurple,
            colorScheme: const ColorScheme.light(primary: Colors.deepPurple),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _submitForm() {
    if (formKey.currentState!.validate()) {
      var provider = Provider.of<ScienceCompetitionProvider>(context, listen: false);
      ScienceCompetitionItem updatedItem = ScienceCompetitionItem(
        keyID: widget.item.keyID,
        title: titleController.text,
        date: selectedDate,
        time: selectedTime,
        score: int.parse(scoreController.text),
        description: descriptionController.text,
      );
      provider.updateCompetition(updatedItem);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('อัปเดตการแข่งขันเรียบร้อย!', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แก้ไขข้อมูลการแข่งขัน'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 5,
            shadowColor: Colors.black26,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'ชื่อการแข่งขัน',
                        prefixIcon: const Icon(Icons.emoji_events, color: Colors.deepPurple),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (value) => value!.isEmpty ? "กรุณาป้อนชื่อการแข่งขัน" : null,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: scoreController,
                      decoration: InputDecoration(
                        labelText: 'คะแนน',
                        prefixIcon: const Icon(Icons.star, color: Colors.amber),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) return "กรุณาป้อนคะแนน";
                        if (int.tryParse(value) == null || int.parse(value) <= 0) {
                          return "กรุณาป้อนคะแนนที่มากกว่า 0";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: 'รายละเอียดการแข่งขัน',
                        prefixIcon: const Icon(Icons.description, color: Colors.blueGrey),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _selectDate(context),
                          icon: const Icon(Icons.calendar_today),
                          label: Text(
                            selectedDate == null
                                ? 'เลือกวันที่'
                                : 'วันที่: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _selectTime(context),
                          icon: const Icon(Icons.access_time),
                          label: Text(
                            selectedTime == null ? 'เลือกเวลา' : 'เวลา: ${selectedTime!.format(context)}',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: _submitForm,
                        icon: const Icon(Icons.save),
                        label: const Text('บันทึกการแก้ไข', style: TextStyle(fontSize: 16)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
