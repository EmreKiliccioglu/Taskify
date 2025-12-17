import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../user/auth.dart';
import '../user/login_register_page.dart';

class MenuPanel {
  static void open(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Panel',
      barrierColor: Colors.black38,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Material(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: SizedBox(
              width: 280,
              height: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 60),

                  // Kullanıcı adı ve ikon
                  FutureBuilder<String?>(
                    future: Auth().getUserInfo(), // Auth sınıfından çağırıyoruz
                    builder: (context, snapshot) {
                      String displayName;

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        displayName = "Yükleniyor...";
                      } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                        displayName = snapshot.data!;
                      } else {
                        displayName = "Guest";
                      }

                      return Column(
                        children: [
                          ClipOval(
                            child: Image.asset(
                              "assets/taskifyIcon.png",
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            displayName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      );
                    },
                  ),

                  // Hesabım butonu
                  ListTile(
                    leading: Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
                    title: Text(
                      "Hesabım",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    onTap: () {
                      // Hesabım sayfasına yönlendirme
                    },
                  ),

                  // Bildirimler butonu
                  ListTile(
                    leading: Icon(Icons.notifications, color: Theme.of(context).colorScheme.primary),
                    title: Text(
                      "Bildirimler",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    onTap: () {
                      // Bildirimler sayfasına yönlendirme
                    },
                  ),

                  const Spacer(), // en alta buton için boşluk

                  // Giriş Yap / Çıkış Yap
                  StreamBuilder<User?>(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, snapshot) {
                      final user = snapshot.data;
                      return ListTile(
                        leading: Icon(
                          user == null ? Icons.login : Icons.logout,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        title: Text(
                          user == null ? "Giriş Yap" : "Çıkış Yap",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                          onTap: () async {
                            Navigator.of(context).pop(); // Paneli kapat
                            if (user == null) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const LoginRegisterPage(),
                                ),
                              );
                            } else {
                              await Auth().signOut(); // Giriş yapmışsa çıkış yap
                            }
                          }

                      );
                    },
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation1, animation2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset.zero,
          ).animate(animation1),
          child: child,
        );
      },
    );
  }
}
