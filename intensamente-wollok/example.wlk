class Persona {
  var nivelFelicidad
  var emocionDominante
  var recuerdosDelDia
  var recuerdosCentrales = #{}
  var recuerdosNegados
  var memoriaLargoPlazo
  var procesosMentales
  var edad
  var pensamientoActual
  
  method limpiarRecuerdosDelDia() {
    recuerdosDelDia.clear()
  }
  
  method dormir() {
    procesosMentales.forEach({ x => x.ejecutar(self) })
  }
  
  method rememorar() {
    const fechaActual = new Date()
    const recuerdoAleatorio = memoriaLargoPlazo.filter(
      { x => (fechaActual.year() - x.fecha().year()) > (edad / 2) }
    ).anyOne()
    pensamientoActual.add(recuerdoAleatorio)
  }
  
  method vivirUnEvento(recuerdo) {
    recuerdosDelDia.add(recuerdo)
  }
  
  method asentarRecuerdo(recuerdo) {
    recuerdo.asentarse(self)
  }
  
  method agregarPensamientoCentral(recuerdo) {
    recuerdosCentrales.add(recuerdo)
  }
  
  method verificarDisminuicion(porcentaje) {
    const nuevaFelicidad = nivelFelicidad - (nivelFelicidad * porcentaje)
    if (nuevaFelicidad < 1) {
      throw new DomainException(message = "Felicidad no puede ser menor a 1")
    }
  }
  
  method disminuirFelicidad(porcentaje) {
    self.verificarDisminuicion(porcentaje)
    nivelFelicidad -= nivelFelicidad * porcentaje
  }
  
  method recuerdosRecientes() = recuerdosDelDia.takeRight(5)
  
  method recuerdosCentrales() = recuerdosCentrales
  
  method pensamientosCentralesDificilesDeExplicar() {
    recuerdosCentrales.filter({ x => x.descripcionLarga() })
  }
  
  method negarRecuerdo(recuerdo) {
    emocionDominante.negar(recuerdo)
  }
  
  method esPensamientoCentral(recuerdo) = recuerdosCentrales.contains(recuerdo)
  
  method enviarALargoPlazo(recuerdo) {
    memoriaLargoPlazo.add(recuerdo)
  }
  
  method estaEnLargoPlazo(recuerdo) {
    memoriaLargoPlazo.contains(recuerdo)
  }
  
  method perderTresPensamientosMasAntiguos() {
    const pensamientosOrdenados = recuerdosCentrales.asList().sortedBy(
      { p1, p2 => p1.fecha() < p2.fecha() }
    )
    
    pensamientosOrdenados.take(3).forEach(
      { pensamiento => recuerdosCentrales.remove(pensamiento) }
    )
  }
  
  method restaurarFelicidad() {
    nivelFelicidad = (nivelFelicidad + 100).min(1000)
    //va a elegir siempre el minimo numero entre el que le pase y 1000
  }
  
  method repeticionesDeUnRecuerdoEnLargoPlazo(
    recuerdo
  ) = memoriaLargoPlazo.count({ x => x == recuerdo })
  
  method dejaVu(recuerdo) = self.repeticionesDeUnRecuerdoEnLargoPlazo(
    recuerdo
  ) > 1
  
  method nivelFelicidad() = nivelFelicidad
  
  method recuerdosDelDia() = recuerdosDelDia
  
  method memoriaLargoPlazo() = memoriaLargoPlazo
}

class Recuerdo {
  var descripcion
  var fecha
  var emocionDominante
  
  method asentarse(persona) {
    emocionDominante.asentar(persona, self)
  }
  
  method descripcionLarga() = descripcion.words().size() > 10
  
  method esAlegre() = emocionDominante.esAlegre()
  
  method contiene(palabra) = descripcion.contains(palabra)
}

class Emocion {
  method asentar(persona, recuerdo)
  
  method esAlegre()
  
  method negar(recuerdo)
}

object alegre inherits Emocion {
  override method asentar(persona, recuerdo) {
    self.validar(persona)
    persona.agregarPensamientoCentral(recuerdo)
  }
  
  method validar(persona) {
    if (persona.nivelFelicidad() < 500) {
      throw new NoSePuedeAsentarRecuerdoException(
        message = "No se puede asentar recuerdo, el nivel de felicidad es menor a 500"
      )
    }
  }
  
  override method esAlegre() = true
  
  override method negar(recuerdo) = !recuerdo.esAlegre()
}

object triste inherits Emocion {
  override method asentar(persona, recuerdo) {
    persona.agregarPensamientoCentral(recuerdo)
    persona.disminuirFelicidad(0.1)
  }
  
  override method esAlegre() = false
  
  override method negar(recuerdo) = recuerdo.esAlegre()
}

class ProcesoMental {
  method ejecutar(persona)
}

object asentamiento inherits ProcesoMental {
  override method ejecutar(persona) {
    const recuerdosDelDia = persona.recuerdosDelDia()
    recuerdosDelDia.forEach({ x => x.asentarse(persona) })
  }
}

class AsentamientoColectivo inherits ProcesoMental {
  const palabraClave
  
  override method ejecutar(persona) {
    persona.recuerdosDelDia().filter({ r => r.contiene(palabraClave) }).forEach(
      { r => persona.asentarRecuerdo(r) }
    )
  }
}

object profundizacion inherits ProcesoMental {
  override method ejecutar(persona) {
    persona.recuerdosDelDia().filter(
      { r => !persona.esPensamientoCentral(r) }
    ).filter({ r => !persona.negarRecuerdo(r) }).forEach(
      { r => persona.enviarALargoPlazo(r) }
    )
  }
}

object controlHormonal inherits ProcesoMental {
  override method ejecutar(persona) {
    if (self.hayDesequilibrio(persona)) self.aplicarDesequilibrio(persona)
  }
  
  method hayPensamientoCentralEnMemoria(
    persona
  ) = persona.recuerdosCentrales().any(
    { pensamiento => persona.memoriaLargoPlazo().contains(pensamiento) }
  )
  
  method recuerdosDelDiaConMismaEmocionDominante(persona) {
    //se puede agregar validacion para lista vacia
    const emocion = persona.recuerdosDelDia().first().emocionDominante()
    return persona.recuerdosDelDia().all(
      { x => x.emocionDominante() == emocion }
    )
  }
  
  method hayDesequilibrio(persona) = self.hayPensamientoCentralEnMemoria(
    persona
  ) || self.recuerdosDelDiaConMismaEmocionDominante(persona)
  
  method aplicarDesequilibrio(persona) {
    persona.disminuirFelicidad(0.15)
    persona.perderTresPensamientosMasAntiguos()
  }
}

object restauracionCognitiva inherits ProcesoMental {
  override method ejecutar(persona) {
    persona.restaurarFelicidad()
  }
}

object liberacionDeRecuerdosDelDia inherits ProcesoMental {
  override method ejecutar(persona) {
    persona.limpiarRecuerdosDelDia()
  }
}

class EmocionCompuesta inherits Emocion {
  const emociones
  
  override method asentar(persona, recuerdo) {
    emociones.forEach({ x => x.asentar(persona, recuerdo) })
  }
  
  override method negar(recuerdo) = emociones.all(
    { emocion => emocion.negar(recuerdo) }
  )
  
  override method esAlegre() {
    emociones.any({ x => x.esAlegre() })
  }
}

class NoSePuedeAsentarRecuerdoException inherits DomainException {
  
}