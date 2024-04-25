import 'package:flutter/material.dart';

// home page button widgets
class ButtonEntry extends StatelessWidget {
  final String giris;
  const ButtonEntry({required this.giris});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        giris,
        style: TextStyle(
          color: Colors.brown,
          fontSize: 20,
          fontFamily: 'MadimiOne',

          // decoration: TextDecoration.underline,
        ),
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.brown,
            width: 2,
          ),
        ),
      ),
    );
  }
}

//home page card widgets
class CardEntry extends StatelessWidget {
  final IconData icon;
  final String text;

  const CardEntry({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 45,
      ),
      color: Colors.brown[500],
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.white70,
        ),
        title: Text(
          text,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 20,
            fontFamily: 'MadimiOne',
          ),
        ),
      ),
    );
  }
}

//Sol üst tarafta duran geri gitme ikonu
class IconBack extends StatelessWidget {
  const IconBack({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      left: 20,
      child: IconButton(
        icon: Icon(Icons.arrow_back),
        iconSize: 32,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

//Yanar dönerli arka plan rengi
BoxDecoration WidgetBackcolor(Color color1, Color color2) {
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        color1,
        color2,
      ],
    ),
  );
}

//InputDecorationların ortak görünümü (payment_page, resevation_page)
InputDecoration buildInputDecoration(
  String label,
  String hint,
) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    hintStyle: TextStyle(
      color: Colors.white,
    ),
    labelStyle: TextStyle(color: Colors.white), // Metin rengi
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.white), // Çerçeve rengi
    ),
  );
}
