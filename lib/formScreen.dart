import 'package:flutter/material.dart';
import 'package:account/model/scienceCompetitionItem.dart';
import 'package:provider/provider.dart';
import 'package:account/provider/scienceCompetitionProvider.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _titleController = TextEditingController();
  DateTime? _date;
  TimeOfDay? _time;
  final _scoreController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (selectedDate != null && selectedDate != _date) {
      setState(() {
        _date = selectedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null && selectedTime != _time) {
      setState(() {
        _time = selectedTime;
      });
    }
  }

  void _submitForm() {
    if (_titleController.text.isEmpty || _scoreController.text.isEmpty || _date == null || _time == null) {
      return; // ฟอร์มยังไม่ครบกรอก
    }

    final newCompetition = ScienceCompetitionItem(
      keyID: DateTime.now().millisecondsSinceEpoch,
      title: _titleController.text,
      date: _date,
      time: _time,
      score: int.parse(_scoreController.text),
    );

    Provider.of<ScienceCompetitionProvider>(context, listen: false).addCompetition(newCompetition);

    Navigator.of(context).pop(); // กลับไปหน้าหลัก
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('สร้างการแข่งขัน'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'ชื่อการแข่งขัน'),
            ),
            TextField(
              controller: _scoreController,
              decoration: const InputDecoration(labelText: 'คะแนน'),
              keyboardType: TextInputType.number,
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text(_date == null ? 'เลือกวันที่' : 'วันที่: ${_date!.toLocal()}'),
                ),
                TextButton(
                  onPressed: () => _selectTime(context),
                  child: Text(_time == null ? 'เลือกเวลา' : 'เวลา: ${_time!.format(context)}'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('บันทึกการแข่งขัน'),
            ),
          ],
        ),
      ),
    );
  }
}
