class Persona {
  var suenios = []
  var edad
  var carrerasQueQuiereEstudiar = []
  var plataQueQuiereGanar
  var lugaresAViajar = []
  var tieneHijos
  var sueniosCumplidos = []
  var tipoPersona
  var felicidad
  
  method cumplirSuenioSegunTipoPersona() {
    tipoPersona.cumplirSuenio(self, suenios)
  }
  
  method cumplirSuenio(suenio) {
    suenio.serCumplidoPor(self)
    self.completarSuenio(suenio)
    self.sumarFelicidad(suenio.felicidonios())
  }
  
  method sumarFelicidad(felicidonios) {
    felicidad += felicidonios
  }
  
  method completarSuenio(suenio) {
    self.agregarSuenioCumplido(suenio)
    self.quitarSuenioDeLista(suenio)
  }
  
  method agregarSuenioCumplido(suenio) {
    sueniosCumplidos.add(suenio)
  }
  
  method quitarSuenioDeLista(suenio) {
    suenios.delete(suenio)
  }
  
  method validarCarrera(carrera) = carrerasQueQuiereEstudiar.contains(
    carrera
  ) || sueniosCumplidos.contains(carrera)
  
  method validarTrabajo(sueldo) = sueldo >= plataQueQuiereGanar
  
  method validarAdopcion() = tieneHijos
  
  method cambiarTipoPersona(nuevoTipo) {
    tipoPersona = nuevoTipo
  }
  
  method esFeliz() {
    felicidad > self.felicidadSueniosPendientes()
  }
  
  method felicidadSueniosPendientes() = suenios.sum({ x => x.felicidonios() })
  
  method esAmbiciosa() {
    (suenios.count(
      { x => x.felicidonios() > 100 }
    ) > 3) || sueniosCumplidos.count({ x => x.felicidonios() > 100 })
  }
}

class Carrera {
  var nombre
  const felicidonios
  
  method serCumplidoPor(persona) {
    if (!persona.validarCarrera(nombre)) {
      throw new NoSePuedeCumplirElSuenioException(
        message = "La persona no quiere estudiar esa carrera o ya se recibio de la misma"
      )
    }
  }
  
  method felicidonios() = felicidonios
}

class ConseguirUnLaburoDondeSeGaneXCantidadDePlata {
  var sueldo
  const felicidonios
  
  method serCumplidoPor(persona) {
    if (!persona.validarTrabajo(sueldo)) {
      throw new NoSePuedeCumplirElSuenioException(
        message = "El sueldo pretendido por la persona es mayor al del trabajo"
      )
    }
  }
  
  method felicidonios() = felicidonios
}

class AdoptarHijos {
  var cantidad
  const felicidonios
  
  method serCumplidoPor(persona) {
    if (!persona.validarAdopcion()) {
      throw new NoSePuedeCumplirElSuenioException(
        message = "La no puede adoptar porque ya tiene hijos"
      )
    }
  }
  
  method felicidonios() = felicidonios
}

class TenerHijos {
  var cantidad
  const felicidonios
  
  method serCumplidoPor(persona) {
    
  }
  
  method felicidonios() = felicidonios
}

class ViajarA {
  var destino
  const felicidonios
  
  method serCumplidoPor(persona) {
    
  }
  
  method felicidonios() = felicidonios
}

class SuenioMultiple {
  var listaDeSuenios = []
  
  method serCumplidoPor(persona) {
    listaDeSuenios.forEach({ x => x.serCumplidoPor(persona) })
  }
}

object realista {
  method cumplirSuenioSegunTipoPersona(persona, suenios) {
    const suenioMasImportante = suenios.max({ x => x.felicidonios() })
    persona.cumplirSuenio(suenioMasImportante)
    //¿aca estoy rompiendo el encapsulamiento??
  }
}

object alocado {
  method cumplirSuenioSegunTipoPersona(persona, suenios) {
    const suenioRandom = suenios.anyOne()
    persona.cumplirSuenio(suenioRandom)
  }
}

object obsesivo {
  method cumplirSuenioSegunTipoPersona(persona, suenios) {
    const primerSuenio = suenios.first()
    persona.cumplirSuenio(primerSuenio)
  }
}

class NoSePuedeCumplirElSuenioException inherits DomainException {
  
}