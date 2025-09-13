import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patron_bloc/counter/counter_bloc.dart';
import 'package:patron_bloc/counter/counter_events.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter App con BLoC',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Aquí es donde "provees" tu BLoC al árbol de widgets.
      // CounterPage y cualquier widget hijo podrán acceder a CounterBloc.
      home: BlocProvider(
        create: (context) => CounterBloc(),
        child: const CounterPage(),
      ),
    );
  }
}

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter with BLoC'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: BlocBuilder<CounterBloc, int>(
          builder: (context, count) {
            // Este Text se reconstruirá con cada nuevo estado
            return Text(
              '$count',
              style: Theme.of(context).textTheme.headlineMedium,
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end, // Alinea los botones abajo
        children: [
          // Botón para Incrementar
          FloatingActionButton(
            heroTag: 'btn_add', // heroTag previene errores con múltiples FABs
            child: const Icon(Icons.add),
            onPressed: () => context.read<CounterBloc>().add(CounterIncrements()),
          ),

          const SizedBox(height: 8), // Un pequeño espacio entre botones

          // Botón para Decrementar
          FloatingActionButton(
            heroTag: 'btn_remove',
            child: const Icon(Icons.remove),
            onPressed: () => context.read<CounterBloc>().add(CounterDecrements()),
          ),

          const SizedBox(height: 8),

          // Botón para Multiplicar
          FloatingActionButton(
            heroTag: 'btn_multiply',
            child: const Icon(Icons.close),
            onPressed: () => context.read<CounterBloc>().add(CounterMultiplica(2)),
          ),

          const SizedBox(height: 8),

          // Botón para Reiniciar
          FloatingActionButton(
            heroTag: 'btn_reset',
            child: const Icon(Icons.refresh),
            onPressed: () => context.read<CounterBloc>().add(CounterReset()),
          ),
        ],
      ),
    );
  }
}