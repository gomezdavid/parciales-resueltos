class Persona {
  var suenios
  var edad
  var plataQueQuiereGanar
  var cantidadHijos
  var nivelFelicidad
  var carrerasQueQuiereEstudiar
  var carrerasCompletadas
  var lugaresVisitados
  var trabajos
  var tipoPersona
  
  method cumplirSuenioElegido() {
    const suenioElegido = tipoPersona.elegirSuenio(self.sueniosPendientes())
    self.cumplirSuenio(suenioElegido)
  }
  
  method cumplirSuenio(suenio) {
    if (!self.sueniosPendientes().contains(suenio)) {
      throw new NoSePuedeCumplirElSuenioException(
        message = "El suenio no se puede cumplir porque no esta pendiente"
      )
    }
    suenio.cumplir(self)
  }
  
  method sueniosPendientes() = suenios.filter({ x => x.estaPendiente() })
  
  method sumarFelicidonios(felicidonios) {
    nivelFelicidad += felicidonios
  }
  
  method tieneHijos() = cantidadHijos > 0
  
  method agregarHijos() {
    cantidadHijos += 1
  }
  
  method quiereEstudiar(carrera) = carrerasQueQuiereEstudiar.contains(carrera)
  
  method yaCompletoCarrera(carrera) = carrerasCompletadas.contains(carrera)
  
  method completarCarrera(carrera) {
    carrerasCompletadas.add(carrera)
  }
  
  method viajarA(destino) {
    lugaresVisitados.add(destino)
  }
  
  method agregarTrabajo(puesto) {
    trabajos.add(puesto)
  }
  
  method esFeliz() {
    nivelFelicidad > self.sueniosPendientes().sum({ x => x.felicidonios() })
  }
  
  method esAmbiciosa() = self.sueniosAmbiciosos().size() > 3
  
  method sueniosAmbiciosos() = suenios.filter(
    { suenio => suenio.esAmbicioso() }
  )
}

class Suenio {
  var cumplido
  
  method cumplir(persona) {
    self.validar(persona)
    self.realizar(persona)
    self.cumplir()
    persona.sumarFelicidonios(self.felicidonios())
  }
  
  method cumplir() {
    cumplido = true
  }
  
  method estaPendiente() = !cumplido
  
  method esAmbicioso() = self.felicidonios() > 100
  
  //son abstractos porque cada suenio valida cosas diferentes
  method validar(persona)
  
  method realizar(persona)
  
  method felicidonios()
}

class SuenioSimple inherits Suenio {
  var felicidonios
  
  override method felicidonios() = felicidonios
}

class AdoptarHijo inherits SuenioSimple {
  const cantidadDeHijos
  
  override method validar(persona) {
    if (persona.tieneHijos()) {
      throw new NoSePuedeCumplirElSuenioException(
        message = "La persona ya tiene hijos"
      )
    }
  }
  
  override method realizar(persona) {
    persona.agregarHijos(cantidadDeHijos)
  }
}

class Recibirse inherits SuenioSimple {
  var carrera
  
  override method validar(persona) {
    if (!persona.quiereEstudiar(carrera)) {
      throw new NoSePuedeCumplirElSuenioException(
        message = "La persona no quiere estudiar la carrera: " + carrera
      )
    }
    
    if (persona.yaCompletoCarrera(carrera)) {
      throw new NoSePuedeCumplirElSuenioException(
        message = "La persona ya completo la carrera: " + carrera
      )
    }
  }
  
  override method realizar(persona) {
    persona.completarCarrera(carrera)
  }
}

class Viajar inherits SuenioSimple {
  var destino
  
  override method validar(persona) {
    
  }
  
  override method realizar(persona) {
    persona.viajarA(destino)
  }
}

class ConseguirTrabajo inherits SuenioSimple {
  var puesto
  
  override method validar(persona) {
    if (!persona.validarTrabajo()) {
      throw new NoSePuedeCumplirElSuenioException(
        message = "El sueldo no alcanza"
      )
    }
  }
  
  override method realizar(persona) {
    persona.agregarTrabajo(puesto)
  }
}

class SuenioMultiple inherits Suenio {
  var suenios
  
  override method validar(persona) {
    suenios.forEach({ x => x.validar(persona) })
  }
  
  override method realizar(persona) {
    suenios.forEach({ x => x.realizar(persona) })
  }
  
  override method felicidonios() = suenios.sum({ x => x.felicidonios() })
}

object realista {
  method elegirSuenio(sueniosPendientes) = sueniosPendientes.max(
    { x => x.felicidonios() }
  )
}

object alocado {
  method elegirSuenio(sueniosPendientes) = sueniosPendientes.anyOne()
}

object obsesivo {
  method elegirSuenio(sueniosPendientes) = sueniosPendientes.first()
}

class NoSePuedeCumplirElSuenioException inherits DomainException {
  
}