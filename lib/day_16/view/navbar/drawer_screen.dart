import 'package:flutter/material.dart';

class DrawerScreen extends StatelessWidget {

  final bool isDarkMode;
  final String? selectedKelas;
  final bool isChecked;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;

  final List<String> kelasList;

  final Function(bool) onDarkModeChanged;
  final Function(String?) onKelasChanged;
  final Function(bool?) onCheckedChanged;
  final VoidCallback onPickDate;
  final VoidCallback onPickTime;

  const DrawerScreen({
    super.key,
    required this.isDarkMode,
    required this.selectedKelas,
    required this.isChecked,
    required this.selectedDate,
    required this.selectedTime,
    required this.kelasList,
    required this.onDarkModeChanged,
    required this.onKelasChanged,
    required this.onCheckedChanged,
    required this.onPickDate,
    required this.onPickTime,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [

          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0F9D58), Color(0xFF0C7C45)],
              ),
            ),
            child: Text(
              "Pengaturan & Filter",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: "Poppins",
              ),
            ),
          ),

          SwitchListTile(
            title: Text(
              "Mode Gelap",
              style: TextStyle(
                fontFamily: "Poppins",
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            value: isDarkMode,
            onChanged: onDarkModeChanged,
          ),

          const Divider(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButton<String>(
              value: selectedKelas,
              dropdownColor: isDarkMode ? Colors.grey[850] : Colors.white,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Text(
                "Pilih Kelas",
                style: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.grey,
                ),
              ),
              items: kelasList.map((kelas) {
                return DropdownMenuItem<String>(
                  value: kelas,
                  child: Text(
                    kelas,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onKelasChanged,
            ),
          ),

          const Divider(),

          CheckboxListTile(
            title: Text(
              "Saya hadir",
              style: TextStyle(
                fontFamily: "Poppins",
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            value: isChecked,
            onChanged: onCheckedChanged,
          ),

          const Divider(),

          ListTile(
            title: Text(
              selectedDate == null
                  ? "Pilih Tanggal"
                  : "Tanggal: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            onTap: onPickDate,
          ),

          ListTile(
            title: Text(
              selectedTime == null
                  ? "Pilih Jam"
                  : "Jam: ${selectedTime!.format(context)}",
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            onTap: onPickTime,
          ),
        ],
      ),
    );
  }
}