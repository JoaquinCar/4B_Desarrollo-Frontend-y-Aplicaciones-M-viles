// lib/citas_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'citas_events_states.dart';

class CitasBloc extends Bloc<CitasEvent, CitasState> {
  CitasBloc() : super(CitasInitial()) {

    // Cambiamos el manejador de GuardarCitaPrueba a GuardarNuevaCita
    on<GuardarNuevaCita>((event, emit) async {
      try {
        // Usamos los datos que vienen DENTRO del evento
        await FirebaseFirestore.instance.collection('citas_prueba').add({
          'paciente': event.paciente,
          'sintoma': event.sintoma,
          'fecha': event.fecha,
        });
        emit(CitasGuardadoExito());
      } catch (e) {
        emit(CitasGuardadoError(e.toString()));
      }
    });
    // --- NUEVA LÓGICA para CARGAR DATOS ---
    on<CargarCitas>((event, emit) async {
      emit(CitasCargando()); // 1. Emitir estado de carga
      try {
        // 2. Consultar los datos en Firestore
        final snapshot = await FirebaseFirestore.instance.collection('citas_prueba').get();
        // 3. Si la consulta es exitosa, emitir el estado con los datos
        emit(CitasCargadoExito(snapshot.docs));
      } catch (e) {
        // 4. Si hay un error, emitir el estado de error
        emit(CitasErrorAlCargar(e.toString()));
      }
    });
  }
}