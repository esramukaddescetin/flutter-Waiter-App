import 'package:flutter/material.dart';
import 'package:waiter_app/my_widgets.dart';

class TableNumberPage extends StatefulWidget {
  @override
  _TableNumberPageState createState() => _TableNumberPageState();
}

class _TableNumberPageState extends State<TableNumberPage> {
  TextEditingController _tableNumberController = TextEditingController();
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(
          'Masa Numarası',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: WidgetBackcolor(
          Colors.brown,
          Colors.white60,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:
                CrossAxisAlignment.start, // Sola yaslanması için
            children: [
              Text(
                'Masa numaranızı giriniz',
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),

                textAlign: TextAlign.left, // Sola yaslanması için
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _tableNumberController,
                keyboardType: TextInputType.number,
                maxLength: 2,
                style: TextStyle(
                  color: Colors.white,
                ), // Metin rengini beyaz yap
                decoration: InputDecoration(
                  labelText: 'Masa Numarası (0-20)',
                  labelStyle:
                      TextStyle(color: Colors.white), // Metin rengini beyaz yap
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.white), // Çizgi rengini beyaz yap
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .white), // Aktif olmayan çizgi rengini beyaz yap
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .white), // Odaklanılan çizgi rengini beyaz yap
                  ),
                  counterStyle: TextStyle(
                      color: Colors
                          .brown[300]), // Sayma metninin rengini beyaz yap
                  errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
                  errorStyle: TextStyle(
                      color:
                          Colors.red[900]), // Hata metninin rengini beyaz yap
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Masa numarası bilgisini al
                  int tableNumber =
                      int.tryParse(_tableNumberController.text) ?? 0;

                  // Girilen numara 20'den büyükse hata mesajı göster
                  if (tableNumber > 20) {
                    setState(() {
                      _errorMessage = 'Masa numarası 20\'den büyük olamaz';
                    });
                  } else {
                    // Alınan masa numarasını kullanarak ilgili işlemi gerçekleştir
                    // Örneğin, bir sonraki ekrana geçiş yapabilir veya veritabanına kaydedebilirsiniz
                    setState(() {
                      _errorMessage = '';
                      //masa müsaitse yönlendir!!
                      Navigator.pushNamed(context, '/quickrequestsPage');
                    });
                  }
                },
                child: Text(
                  'Giriş Yap',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 45.0), // Buton boyutunu ayarla
                  backgroundColor: Colors.brown, // Buton rengini belirle
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Belleği temizle
    _tableNumberController.dispose();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    home: TableNumberPage(),
  ));
}
