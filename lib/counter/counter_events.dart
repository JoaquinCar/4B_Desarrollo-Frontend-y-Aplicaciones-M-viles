// Esto es como decir: "Aquí defino la categoría 'Ordenes para el Contador'".
// Es 'abstract' porque no puedes pedir una "orden genérica",
// tienes que pedir algo específico del menú.
abstract class CounterEvent {}

// Esta es una orden específica y concreta del menú.
// Es una clase que hereda de CounterEvent, por lo tanto, es una orden válida.
// Su único propósito es existir, ser un mensaje claro: "¡Incrementa el contador!"
class CounterIncrements extends CounterEvent {}
class CounterDecrements extends CounterEvent {}
class CounterMultiplica extends CounterEvent {
  final int factor; // Le añadimos un dato
  CounterMultiplica(this.factor);
}
class CounterReset extends CounterEvent {}
