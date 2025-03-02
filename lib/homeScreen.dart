import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:account/model/scienceCompetitionItem.dart';
import 'package:account/provider/scienceCompetitionProvider.dart';
import 'package:account/formScreen.dart';
import 'package:account/editScreen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildCompetitionList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToFormScreen(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  /// ✅ AppBar พร้อมปุ่มเพิ่มข้อมูล
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 253, 229, 75),
      title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  /// ✅ ListView แสดงการแข่งขันทั้งหมด
  Widget _buildCompetitionList() {
    return Consumer<ScienceCompetitionProvider>(
      builder: (context, provider, child) {
        if (provider.competitions.isEmpty) {
          return const Center(
            child: Text(
              'ไม่มีการแข่งขัน',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: provider.competitions.length,
          itemBuilder: (context, index) {
            final item = provider.competitions[index];
            return _buildCompetitionCard(context, provider, item);
          },
        );
      },
    );
  }

  /// ✅ Card สำหรับแต่ละการแข่งขัน
  Widget _buildCompetitionCard(BuildContext context, ScienceCompetitionProvider provider, ScienceCompetitionItem item) {
    return Dismissible(
      key: Key(item.keyID.toString()),
      direction: DismissDirection.horizontal,
      background: _buildDismissBackground(),
      onDismissed: (_) {
        provider.deleteCompetition(item);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ลบ "${item.title}" สำเร็จ')),
        );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(
            'วันที่: ${item.date?.toLocal()} | เวลา: ${item.time?.format(context)}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          leading: CircleAvatar(
            backgroundColor: const Color.fromARGB(255, 223, 244, 38),
            child: Text(item.score.toString(), style: const TextStyle(color: Colors.white)),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _confirmDelete(context, provider, item),
          ),
          onTap: () => _navigateToEditScreen(context, item),
        ),
      ),
    );
  }

  /// ✅ แถบแดงแสดงเมื่อปัดเพื่อลบ
  Widget _buildDismissBackground() {
    return Container(
      color: Colors.red,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }

  /// ✅ แสดง Dialog ยืนยันการลบ
  void _confirmDelete(BuildContext context, ScienceCompetitionProvider provider, ScienceCompetitionItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการลบ'),
          content: Text('คุณต้องการลบ "${item.title}" หรือไม่?'),
          actions: [
            TextButton(child: const Text('ยกเลิก'), onPressed: () => Navigator.of(context).pop()),
            TextButton(
              child: const Text('ลบ', style: TextStyle(color: Colors.red)),
              onPressed: () {
                provider.deleteCompetition(item);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('ลบ "${item.title}" สำเร็จ')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  /// ✅ ไปที่หน้าสร้างการแข่งขันใหม่
  void _navigateToFormScreen(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const FormScreen()));
  }

  /// ✅ ไปที่หน้าแก้ไขการแข่งขัน
  void _navigateToEditScreen(BuildContext context, ScienceCompetitionItem item) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => EditScreen(item: item)));
  }
}
