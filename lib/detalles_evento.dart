import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetallesEvento extends StatelessWidget {
  final String imageUrl;

  const DetallesEvento(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Evento'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(imageUrl),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('eventos')
                  .where('imagenEvento', isEqualTo: imageUrl)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                Map<String, dynamic> eventoData = snapshot.data!.docs.isNotEmpty ? snapshot.data!.docs[0].data() as Map<String, dynamic> : <String, dynamic>{};
                if (eventoData.isEmpty) {
                  return const Text('No se encontraron datos del evento');
                }

                String nombreEvento = eventoData['nombreEvento'];
                String fechaEvento = eventoData['fechaEvento'];
                String horaEvento = eventoData['horaEvento'];
                String ubicacionEvento = eventoData['ubicacionEvento'];

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nombre del Evento: $nombreEvento',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('Fecha del Evento: $fechaEvento'),
                      const SizedBox(height: 8),
                      Text('Hora del Evento: $horaEvento'),
                      const SizedBox(height: 8),
                      Text('Ubicación del Evento: $ubicacionEvento'),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}