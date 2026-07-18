import 'package:flutter/material.dart';

class TalkAccordion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // Transcript
        Card(
          clipBehavior: Clip.antiAlias,
          child: ExpansionTile(
            title: Text('Sezione 1: Informazioni Generali'),
            leading: Icon(Icons.info_outline),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Questo è il contenuto del primo pannello. Puoi inserire qualsiasi widget qui dentro, come testi, immagini o bottoni.',
                ),
              ),
            ],
          ),
        ),
        // YouTube stats
        Card(
          clipBehavior: Clip.antiAlias,
          child: ExpansionTile(
            title: Text('Sezione 2: Informazioni Generali'),
            leading: Icon(Icons.info_outline),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Questo è il contenuto del secondo pannello. Puoi inserire qualsiasi widget qui dentro, come testi, immagini o bottoni.',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
