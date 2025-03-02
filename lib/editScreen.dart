import 'package:flutter/material.dart';
import 'package:account/model/scienceCompetitionItem.dart';
import 'package:provider/provider.dart';
import 'package:account/provider/scienceCompetitionProvider.dart';

class EditScreen extends StatefulWidget {
  final ScienceCompetitionItem item;

  EditScreen({super.key, required this.item});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final scoreController = TextEditingController();
  TimeOfDay? selectedTime;  // ตัวแปรเก็บเวลาที่เลือก
  DateTime? selectedDate;  // ตัวแปรเก็บวันที่ที่เลือก

  @override
  void initState() {
    super.initState();
    titleController.text = widget.item.title;
    scoreController.text = widget.item.score.toString();
    selectedTime = widget.item.time ?? TimeOfDay.now();  // ใช้เวลาปัจจุบันหากไม่มีเวลา
    selectedDate = widget.item.date ?? DateTime.now();   // ใช้วันที่ปัจจุบันหากไม่มีวัน
  }

  // ฟังก์ชันเพื่อเปิด time picker
  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  // ฟังก์ชันเพื่อเปิด date picker
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('แก้ไขข้อมูลการแข่งขัน'),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'ชื่อการแข่งขัน'),
                autofocus: true,
                controller: titleController,
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return "กรุณาป้อนชื่อการแข่งขัน";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'คะแนน'),
                keyboardType: TextInputType.number,
                controller: scoreController,
                validator: (String? value) {
                  try {
                    int score = int.parse(value!);
                    if (score <= 0) {
                      return "กรุณาป้อนคะแนนที่มากกว่า 0";
                    }
                  } catch (e) {
                    return "กรุณาป้อนเป็นตัวเลขเท่านั้น";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ปุ่มเลือกวันที่
              Row(
                children: [
                  Text(
                    'วันที่: ${selectedDate != null ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}" : 'ไม่ระบุวันที่'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),

              // ปุ่มเลือกเวลา
              Row(
                children: [
                  Text(
                    'เวลา: ${selectedTime != null ? selectedTime!.format(context) : 'ไม่ระบุเวลา'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: () => _selectTime(context),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ปุ่มบันทึก
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // ใช้ addPostFrameCallback เพื่อทำการอัปเดตข้อมูลหลังจากการสร้าง widget เสร็จ
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        var provider = Provider.of<ScienceCompetitionProvider>(context, listen: false);
                        ScienceCompetitionItem updatedItem = ScienceCompetitionItem(
                          keyID: widget.item.keyID,
                          title: titleController.text,
                          date: selectedDate, // อัปเดตวันที่ใหม่
                          time: selectedTime, // อัปเดตเวลาใหม่
                          score: int.parse(scoreController.text),
                        );
                        provider.updateCompetition(updatedItem);
                        Navigator.pop(context);
                      });
                    }
                  },
                  child: const Text('ยืนยัน'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
