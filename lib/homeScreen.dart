import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:account/model/scienceCompetitionItem.dart';
import 'package:account/provider/scienceCompetitionProvider.dart';
import 'package:account/formScreen.dart';
import 'package:account/editScreen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // ✅ เพิ่ม FontAwesomeIcons

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
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.blueGrey.shade900,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.science, color: Colors.white, size: 26),
          const SizedBox(width: 8),
          Text(
            widget.title,
            style: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
      centerTitle: true,
      elevation: 8,
      shadowColor: Colors.black54,
      actions: [
        IconButton(
          icon: const Icon(Icons.add_circle, size: 32, color: Colors.white),
          onPressed: () => _navigateToFormScreen(context),
        ),
      ],
    );
  }

  Widget _buildCompetitionList() {
    return Consumer<ScienceCompetitionProvider>(
      builder: (context, provider, child) {
        if (provider.competitions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.science_outlined, size: 80, color: Colors.blueGrey),
                const SizedBox(height: 10),
                Text(
                  'ไม่มีการแข่งขันในขณะนี้',
                  style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: provider.competitions.length,
          itemBuilder: (context, index) {
            final item = provider.competitions[index];
            return _buildCompetitionCard(context, provider, item);
          },
        );
      },
    );
  }

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
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          title: Row(
            children: [
            Text(
                item.title,
                style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple.shade700),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📅 วันที่: ${item.date?.toLocal() ?? 'ไม่ระบุ'}',
                style: GoogleFonts.roboto(fontSize: 14, color: Colors.grey.shade700),
              ),
              Text(
                '⏰ เวลา: ${item.time?.format(context) ?? 'ไม่ระบุ'}',
                style: GoogleFonts.roboto(fontSize: 14, color: Colors.grey.shade700),
              ),
              if (item.description != null && item.description!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    '📌 ${item.description!}',
                    style: GoogleFonts.roboto(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ),
            ],
          ),
          leading: CircleAvatar(
            backgroundColor: Colors.amber,
            radius: 25,
            child: Text(
              item.score.toString(),
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () => _confirmDelete(context, provider, item),
          ),
          onTap: () => _navigateToEditScreen(context, item),
        ),
      ),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(15),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Icon(Icons.delete, color: Colors.white, size: 30),
    );
  }

  void _confirmDelete(BuildContext context, ScienceCompetitionProvider provider, ScienceCompetitionItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการลบ'),
          content: Text('คุณต้องการลบ "${item.title}" หรือไม่?'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          actions: [
            TextButton(
              child: const Text('ยกเลิก', style: TextStyle(fontSize: 16)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('ลบ', style: TextStyle(color: Colors.redAccent, fontSize: 16)),
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

  void _navigateToFormScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FormScreen(),
      ),
    );
  }

  void _navigateToEditScreen(BuildContext context, ScienceCompetitionItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditScreen(item: item),
      ),
    );
  }
}
