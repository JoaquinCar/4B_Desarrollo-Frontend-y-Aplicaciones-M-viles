// lib/citas_events_states.dart

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
// --- EVENTOS ---
abstract class CitasEvent {}

class GuardarNuevaCita extends CitasEvent {
  final String paciente;
  final String sintoma;
  final String fecha;

  GuardarNuevaCita({
    required this.paciente,
    required this.sintoma,
    required this.fecha,
  });
}
class CargarCitas extends CitasEvent {} // <- NUEVO EVENTO para leer datos


// --- ESTADOS ---
abstract class CitasState {}

class CitasInitial extends CitasState {}

// Estados para guardar
class CitasGuardadoExito extends CitasState {}
class CitasGuardadoError extends CitasState {
  final String mensajeError;
  CitasGuardadoError(this.mensajeError);
}

// Estados para cargar
class CitasCargando extends CitasState {} // <- NUEVO ESTADO para mostrar "cargando..."

class CitasCargadoExito extends CitasState { // <- NUEVO ESTADO con los datos
  final List<QueryDocumentSnapshot> citas;
  CitasCargadoExito(this.citas);
}

class CitasErrorAlCargar extends CitasState { // <- NUEVO ESTADO de error al leer
  final String mensajeError;
  CitasErrorAlCargar(this.mensajeError);
}