// ignore_for_file: unused_import

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:apkteam_totoro/manga_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MangaProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyApp(),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF6200EA),
        centerTitle: true,
        title: Text(
          'Home',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      endDrawer: _buildDrawer(context),
      body: _buildBody(context),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/background.jpeg'), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
            child: UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.transparent),
              accountName: const Text('Team Totoro',
                  style: TextStyle(color: Colors.white)),
              accountEmail: const Text('teamUtsandroidSiA@gmail.com',
                  style: TextStyle(color: Colors.white)),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: Image.asset(
                    'assets/logo2.jpeg',
                    width: 90,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          // Drawer items
          _buildDrawerItem(Icons.home, 'Home', () => Navigator.pop(context)),
          _buildDrawerItem(Icons.book, 'Manga List', () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MangaListScreen()));
          }),
          _buildDrawerItem(FontAwesomeIcons.facebook, 'Facebook', () {
            _launchURL(
                'https://www.facebook.com/profile.php?id=61554926296659');
          }),
          _buildDrawerItem(FontAwesomeIcons.instagram, 'Instagram', () {
            _launchURL('https://www.instagram.com/team.tototro');
          }),
          _buildDrawerItem(FontAwesomeIcons.user, 'Profil', () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()));
          }),
          const Divider(
              thickness: 1, color: Colors.grey), // Divider above Logout
          // ignore: deprecated_member_use
          _buildDrawerItem(FontAwesomeIcons.signOutAlt, 'Logout', () {
            Provider.of<AuthProvider>(context, listen: false).logout();
          }),
        ],
      ),
    );
  }

  ListTile _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF6200EA)),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                  image: AssetImage('assets/logo2.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Team Totoro',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            const Text('Mobile Application Engineer',
                style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey)),
            const SizedBox(height: 20),
            const Text('Selamat Datang di Aplikasi Kami!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(
                    'Aplikasi ini dibuat untuk Menyelesaikan tugas yang di berikan oleh Pak kami',
                    speed: const Duration(milliseconds: 60),
                  ),
                ],
                totalRepeatCount: 1,
                displayFullTextOnTap: true,
              ),
            ),
            const SizedBox(height: 20),
            Consumer<MangaProvider>(
              builder: (context, mangaProvider, child) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: mangaProvider.mangaList.length,
                  itemBuilder: (context, index) {
                    return _buildMangaCard(
                        mangaProvider.mangaList[index], index, context);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMangaCard(Manga manga, int index, BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              manga.imageUrl,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                return const Center(
                    child: Text('Gambar tidak dapat ditampilkan'));
              },
            ),
          ),
          const SizedBox(height: 10),
          Text(manga.title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(manga.description,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey)),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  // Action when favorite button is pressed
                },
                icon: const Icon(FontAwesomeIcons.heart),
                label: const Text('Favorite'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF6200EA),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  Provider.of<MangaProvider>(context, listen: false)
                      .removeManga(index);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil',
            style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF6200EA),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Anggota Tim',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildMemberCard(
                'assets/member1.jpeg',
                'Alilik Zais Shandi Asis (220102140)',
                'saya hobi main game dan olahraga'),
            const SizedBox(height: 10),
            _buildMemberCard(
                'assets/member2.jpeg',
                'Gustaf Reimond Dahoklory (220102003)',
                'saya suka bermain bola dan bekerja keras'),
            const SizedBox(height: 10),
            _buildMemberCard(
                'assets/member3.jpeg',
                'Afifah Iftahul Nisa (220102023)',
                'saya ingin menjadi wanita karir'),
            const SizedBox(height: 10),
            _buildMemberCard(
                'assets/member4.jpeg',
                'Ranti La Lonto (220102033)',
                'saya suka membaca dan nonton anime'),
            const SizedBox(height: 10),
            _buildMemberCard(
                'assets/member5.jpeg',
                'Nadhifa Tulhikmah (220102019)',
                'saya ingin menjadi wanita karir'),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberCard(String imageUrl, String name, String description) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(imageUrl,
                  width: 80, height: 80, fit: BoxFit.cover),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 5),
                  Text(description, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MangaListScreen extends StatelessWidget {
  const MangaListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manga List',
            style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF6200EA),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => _showAddMangaDialog(context),
          ),
        ],
      ),
      body: Consumer<MangaProvider>(
        builder: (context, mangaProvider, child) {
          return mangaProvider.mangaList.isEmpty
              ? Center(
                  child: Text('No Manga Added Yet!',
                      style: GoogleFonts.poppins(
                          fontSize: 20, color: Colors.grey)))
              : GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: mangaProvider.mangaList.length,
                  itemBuilder: (context, index) {
                    return _buildMangaCard(
                        mangaProvider.mangaList[index], index, context);
                  },
                );
        },
      ),
    );
  }

  Widget _buildMangaCard(Manga manga, int index, BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              manga.imageUrl,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                return const Center(
                    child: Text('Gambar tidak dapat ditampilkan'));
              },
            ),
          ),
          const SizedBox(height: 10),
          Text(manga.title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(manga.description,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey)),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  // Action when favorite button is pressed
                },
                icon: const Icon(FontAwesomeIcons.heart),
                label: const Text('Favorite'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF6200EA),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  Provider.of<MangaProvider>(context, listen: false)
                      .removeManga(index);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddMangaDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController imageUrlController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Manga'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: titleController,
                  decoration:
                      const InputDecoration(hintText: 'Masukkan judul manga')),
              TextField(
                  controller: imageUrlController,
                  decoration:
                      const InputDecoration(hintText: 'Masukkan URL gambar')),
              TextField(
                  controller: descriptionController,
                  decoration:
                      const InputDecoration(hintText: 'Masukkan deskripsi')),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Batal')),
            TextButton(
              onPressed: () {
                String mangaTitle = titleController.text;
                String mangaImageUrl = imageUrlController.text;
                String mangaDescription = descriptionController.text;

                if (mangaTitle.isNotEmpty &&
                    mangaImageUrl.isNotEmpty &&
                    mangaDescription.isNotEmpty) {
                  Provider.of<MangaProvider>(context, listen: false)
                      .addManga(mangaTitle, mangaImageUrl, mangaDescription);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('All fields are required!')));
                }
              },
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    );
  }
}

class MangaProvider extends ChangeNotifier {
  List<Manga> mangaList = [];

  void addManga(String title, String imageUrl, String description) {
    mangaList
        .add(Manga(title: title, imageUrl: imageUrl, description: description));
    notifyListeners();
  }

  void removeManga(int index) {
    mangaList.removeAt(index);
    notifyListeners();
  }
}

class Manga {
  final String title;
  final String imageUrl;
  final String description;

  Manga(
      {required this.title, required this.imageUrl, required this.description});
}
