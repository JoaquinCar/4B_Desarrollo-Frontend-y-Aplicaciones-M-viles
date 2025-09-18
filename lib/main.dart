// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'counter/citas_bloc.dart';
import 'counter/citas_events_states.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

// CLASE MyApp QUE FALTABA
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Citas App con BLoC',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => CitasBloc()..add(CargarCitas()),
        child: const CitasPage(),
      ),
    );
  }
}

class CitasPage extends StatelessWidget {
  const CitasPage({super.key});

  void _mostrarFormulario(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return BlocProvider.value(
          value: BlocProvider.of<CitasBloc>(context),
          child: const _CitaFormulario(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestor de Citas con BLoC'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<CitasBloc>().add(CargarCitas()),
          ),
        ],
      ),
      // AQUÍ RESTAURAMOS EL LISTENER
      body: BlocListener<CitasBloc, CitasState>(
        listener: (context, state) {
          if (state is CitasGuardadoExito) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('¡Cita guardada!'), backgroundColor: Colors.green),
            );
            context.read<CitasBloc>().add(CargarCitas());
          } else if (state is CitasGuardadoError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error al guardar: ${state.mensajeError}'), backgroundColor: Colors.red),
            );
          }
        },
        child: BlocBuilder<CitasBloc, CitasState>(
          builder: (context, state) {
            if (state is CitasCargando || state is CitasInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CitasCargadoExito) {
              if (state.citas.isEmpty) {
                return const Center(child: Text('No hay citas guardadas.'));
              }
              return ListView.builder(
                itemCount: state.citas.length,
                itemBuilder: (context, index) {
                  final cita = state.citas[index].data() as Map<String, dynamic>;
                  final paciente = cita['paciente'] ?? 'N/A';
                  final sintoma = cita['sintoma'] ?? 'N/A';
                  final fecha = cita['fecha'] ?? 'N/A';
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text('Paciente: $paciente'),
                    subtitle: Text('Síntoma: $sintoma - Fecha: $fecha'),
                  );
                },
              );
            } else if (state is CitasErrorAlCargar) {
              return Center(child: Text('Error al cargar datos: ${state.mensajeError}'));
            }
            return const Center(child: Text('Presiona el botón para guardar una cita.'));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Agendar Cita'),
        onPressed: () {
          _mostrarFormulario(context);
        },
      ),
    );
  }
}

// --- WIDGET DEL FORMULARIO ---
class _CitaFormulario extends StatefulWidget {
  const _CitaFormulario();

  @override
  State<_CitaFormulario> createState() => _CitaFormularioState();
}

class _CitaFormularioState extends State<_CitaFormulario> {
  final _formKey = GlobalKey<FormState>();
  final _pacienteController = TextEditingController();
  final _sintomaController = TextEditingController();
  final _fechaController = TextEditingController();

  @override
  void dispose() {
    _pacienteController.dispose();
    _sintomaController.dispose();
    _fechaController.dispose();
    super.dispose();
  }

  void _guardarCita() {
    if (_formKey.currentState!.validate()) {
      context.read<CitasBloc>().add(
        GuardarNuevaCita(
          paciente: _pacienteController.text,
          sintoma: _sintomaController.text,
          fecha: _fechaController.text,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Nueva Cita', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            TextFormField(
              controller: _pacienteController,
              decoration: const InputDecoration(labelText: 'Nombre del Paciente'),
              validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _sintomaController,
              decoration: const InputDecoration(labelText: 'Síntoma'),
              validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _fechaController,
              decoration: const InputDecoration(labelText: 'Fecha (YYYY-MM-DD)'),
              validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              readOnly: true, // Para que el teclado no aparezca
              onTap: () async {
                DateTime? fechaSeleccionada = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (fechaSeleccionada != null) {
                  _fechaController.text = fechaSeleccionada.toLocal().toString().split(' ')[0];
                }
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _guardarCita,
              child: const Text('Guardar Cita'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}