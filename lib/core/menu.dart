import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../l10n/app_localizations.dart';
import '../user/auth.dart';
import '../user/login_register_page.dart';

class MenuPanel {
  static void open(BuildContext context) {
    // 🔴 KRİTİK NOKTA: Future SADECE BİR KEZ OLUŞTURULUYOR
    final Future<String?> userInfoFuture = Auth().getUserInfo();

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

                  StreamBuilder<User?>(
                    stream: Auth().authStateChanges,
                    builder: (context, authSnapshot) {
                      final user = authSnapshot.data;

                      if (user == null) {
                        return const _UserHeader(displayName: "GUEST");
                      }

                      return FutureBuilder<String?>(
                        future: userInfoFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const _UserHeader(
                                displayName: "YÜKLENİYOR...");
                          }

                          if (snapshot.hasData &&
                              snapshot.data != null &&
                              snapshot.data!.isNotEmpty) {
                            return _UserHeader(
                              displayName: snapshot.data!,
                            );
                          }

                          // 🔹 Firestore gecikirse fallback
                          final fallback =
                              user.displayName ??
                                  user.email?.split('@').first ??
                                  "GUEST";

                          return _UserHeader(
                            displayName: fallback.toUpperCase(),
                          );
                        },
                      );
                    },
                  ),

                  // ================= ACCOUNT =================
                  ListTile(
                    leading: Icon(
                      Icons.person,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.account,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color:
                        Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    onTap: () {},
                  ),

                  // ================= NOTIFICATIONS =================
                  ListTile(
                    leading: Icon(
                      Icons.notifications,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.notifications,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color:
                        Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    onTap: () {},
                  ),

                  const Spacer(),

                  // ================= LOGIN / LOGOUT =================
                  StreamBuilder<User?>(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, snapshot) {
                      final user = snapshot.data;

                      return ListTile(
                        leading: Icon(
                          user == null
                              ? Icons.login
                              : Icons.logout,
                          color:
                          Theme.of(context).colorScheme.primary,
                        ),
                        title: Text(
                          user == null ? AppLocalizations.of(context)!.login : AppLocalizations.of(context)!.logout,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface,
                          ),
                        ),
                        onTap: () async {
                          Navigator.of(context).pop();

                          if (user == null) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                const LoginRegisterPage(),
                              ),
                            );
                          } else {
                            await Auth().signOut();
                          }
                        },
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
      transitionBuilder:
          (context, animation1, animation2, child) {
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

// ================= USER HEADER =================
class _UserHeader extends StatelessWidget {
  final String displayName;

  const _UserHeader({required this.displayName});

  @override
  Widget build(BuildContext context) {
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
  }
}
