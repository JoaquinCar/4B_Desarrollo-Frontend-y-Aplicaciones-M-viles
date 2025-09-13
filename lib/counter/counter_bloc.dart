import 'package:bloc/bloc.dart';
import 'counter_events.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// La clase "hereda" de Bloc y le especificamos dos cosas:
// <CounterEvent, int> significa:
//   - Recibo órdenes de tipo CounterEvent.
//   - Mi comida (el estado) será de tipo int (un número).
class CounterBloc extends Bloc<CounterEvent, int> {
  // 2. EL ESTADO INICIAL
  // Cuando se crea el BLoC, su estado inicial es 0.
  // super(0) significa "inicia el estado con el valor 0".
  // Es el plato que tienes en la mesa antes de ordenar nada.
  CounterBloc() : super(0) {
    // 3. LA RECETA PARA CADA ORDEN
    // on<CounterIncrements>(...) significa:
    // "Cuando reciba una orden del tipo CounterIncrements, haz lo siguiente:"

    // La lógica es: toma el estado actual (state) y súmale 1.
    // 'emit' es la función especial para "servir" el nuevo estado.
    // Así que, emit(state + 1) significa: "sirve un nuevo plato con el número actualizado".
    on<CounterIncrements>((event, emit) => emit(state + 1));

    on<CounterDecrements>((event, emit) => emit(state - 1));

    on<CounterMultiplica>((event, emit) => emit(state * event.factor));

    on<CounterReset>((event, emit) => emit(0));
  }
}