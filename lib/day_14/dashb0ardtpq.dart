import 'package:belajar_flutter_rezy/day_14/l0gintpq.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Dashb0ardtpq extends StatefulWidget {
  const Dashb0ardtpq({super.key});

  @override
  State<Dashb0ardtpq> createState() => _Dashb0ardtpqState();
}

class _Dashb0ardtpqState extends State<Dashb0ardtpq> {

  // Tugas 7  fitur switch part 1 ganti mode gelap dan terang
  bool isDarkMode = false;

  // Tugas 7 fitur dropdown part 1 
  String? selectedKelas;

  // tugas 7 fitur checkbox part 1
  bool isChecked = false;

  // tugas 7 fitur date picker part 1
  DateTime? selectedDate;

  // tugas 7 fitur date time picker part 1
  TimeOfDay? selectedTime;

  //tugas 7 date picker part 2
  Future<void> pickDate() async{
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  //tugas 7 fitur time picker part 2
  Future<void> pickTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  // tugas 7 fitur dropdown part 2
  final List<String> kelasList = [
    "Jilid 1",
    "Jilid 2",
    "Tahfidz",
    "Remedial"
  ];

  Widget menuCard(String title, String subtitle, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF0F9D58).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF0F9D58)),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // tugas 7 fitur switch part 2 mode terang gelap
      backgroundColor: isDarkMode ? Colors.black : const Color(0xFFF5F7F9),

      appBar: AppBar(
        elevation: 0,
        backgroundColor:isDarkMode ? Colors.black : const Color(0xFFF5F7F9),
        centerTitle: true,
        title:  Text(
          "Dashboard Pengajar",
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w700,
            color: isDarkMode ? Colors.white : Colors.black),
        ),
      ),

      //  DRAWERRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR
      drawer: Drawer(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [

            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0F9D58), Color(0xFF0C7C45)],
                ),
              ),
              child: const Text(
                "Pengaturan & Filter",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Poppins",
                ),
              ),
            ),

            //tugas 7 fitur switch part 5 gelap terang 
            SwitchListTile(
              title: Text(
                "Mode Gelap",
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              value: isDarkMode,
              onChanged: (value){
                setState(() {
                  isDarkMode = value;
                });
              },
            ),

            const Divider(),

            // tugas 7 fitur dropdown part 3
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
                items: kelasList.map((kelas){
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
                onChanged: (value){
                  setState((){
                    selectedKelas = value;
                  });
                },
              ),
            ),

            const Divider(),

            //tugas 7 fitur checkbox part 2 
            CheckboxListTile(
              title: Text(
                "Saya hadir",
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              value: isChecked,
              onChanged: (value){
                setState(() {
                  isChecked = value!;
                });
              },
            ),

            const Divider(),

            //tugas 7 fitur date picker part 3
            ListTile(
              title: Text(
                selectedDate == null
                  ? "Pilih Tanggal"
                  : "Tanggal: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              onTap: pickDate,
            ),

            //tugas 7 date timer part 3
            ListTile(
              title: Text(
                selectedTime == null
                  ? "Pilih Jam"
                  : "Jam: ${selectedTime!.format(context)}",
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              onTap: pickTime,
            ),
          ],
        ),
      ),
      // END DRAWERRRRRRRRRRRRRRRRRRRRRRR

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F9D58), Color(0xFF0C7C45)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Assalamu’alaikum",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Poppins",
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Selamat datang di Al-Hafizh App dari TPQ Al-Mu'minin",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.white70,),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              menuCard("Data Santri", "Kelola data santri", Icons.people),
              menuCard("Absensi Santri", "Monitoring kehadiran", Icons.check_circle),
              menuCard("Absensi Pengajar", "Monitoring kehadiran", Icons.check_circle),
              menuCard("Perkembangan", "Tracking progress", Icons.show_chart),

              const SizedBox(height: 25),  

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const L0gintpq(),
                      ),
                    );
                  },
                  child: const Text("Logout",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}