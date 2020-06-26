import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:smart_moskea/pages/manual_silent.dart';


//import 'languages_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool autoSilent = false;
  bool autoRedirectMessage = false;
  bool noti = false;


  @override
Widget build(BuildContext context) {
    return Scaffold(
      body: SettingsList(
        sections: [
          SettingsSection(
            title: 'Common',
            tiles: [
              SettingsTile(
                title: 'Language',
                subtitle: 'English',
                leading: Icon(Icons.language),
                onTap: () {
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (BuildContext context) => LanguagesScreen()));
                },
              ),
              
            ],
          ),        
            SettingsSection(
            title: 'Mobile Modes',
            tiles: [
               SettingsTile(
                title: 'Manual Silent Mode',
                leading: Icon(Icons.vibration),
                onTap: () {
                   Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) =>ManualSilent()));
                },

              ),
              
              SettingsTile.switchTile(
                title: 'Auto Silent Mode',
                leading: Icon(Icons.signal_cellular_no_sim),
                switchValue: autoSilent,
                onToggle: (bool value) {
                  setState(() {
                    autoSilent = value;
                  });
                
                },
              ),
              
              SettingsTile.switchTile(
                title: 'Auto Redirect Message',
                leading: Icon(Icons.message),
                switchValue: autoRedirectMessage,
                onToggle: (bool value) {
                  setState(() {
                    autoRedirectMessage = value;
                  });
                  
                },
              ),

              
              SettingsTile.switchTile(
                title: 'Notifications',
                leading: Icon(Icons.notifications_active),
                switchValue: noti
                ,
                onToggle: (bool value) {
                  setState(() {
                    noti = value;
                  });
                  
                },
              ),

            ],
          ),

            SettingsSection(
            title: 'Account',
            tiles: [
              SettingsTile(title: 'Email', leading: Icon(Icons.email)),
              SettingsTile(title: 'Sign out', leading: Icon(Icons.exit_to_app)),
            ],
          ),
          
          SettingsSection(
            title: 'Misc',
            tiles: [
              SettingsTile(
                  title: 'Terms of Service', leading: Icon(Icons.description)),
            ],
          
          )
        ],
      ),
    );
  }

  
}