class Persona {
  var posicion
  var elementosCerca
  var criterio
  var comidas
  var preferencia
  var criterioDiversion
  
  method elementosCerca() = elementosCerca
  
  method solicitarElemento(comensal, elemento) {
    if (!self.tiene(elemento)) {
      throw new NoTieneElementoException(
        message = "La persona no tiene ese elemento cerca"
      )
    }
    comensal.devolverElemento(elemento, self)
  }
  
  method devolverElemento(elemento, solicitante) {
    criterio.aplicar(self, solicitante, elemento)
  }
  
  method quitarElemento(elemento) {
    elementosCerca.delete(elemento)
  }
  
  method agregarElemento(elemento) {
    elementosCerca.add(elemento)
  }
  
  method darElemento(elemento, otroComensal) {
    elementosCerca.quitarElemento(elemento)
    otroComensal.agregarElemento(elemento)
  }
  
  method darTodosLosElementos(otroComensal) {
    elementosCerca.forEach({ x => otroComensal.agregarElemento(x) })
    elementosCerca.clear()
  }
  
  method devolverElementoCerca() = elementosCerca.anyOne()
  
  method cambiarPosicion(comensal) {
    const posicionPersona = posicion
    posicion = comensal.posicion()
    comensal.posicion(posicionPersona)
  }
  
  method posicion(nuevaPosicion) {
    posicion = nuevaPosicion
  }
  
  method posicion() = posicion
  
  method tiene(elemento) = elementosCerca.contains(elemento)
  
  method elegirComidas(bandeja) {
    if (preferencia.comer(bandeja)) comidas.add(bandeja)
  }
  
  method comidas() = comidas
  
  method estaPipon() = comidas.any({ x => x.calorias() >= 500 })
  
  method laEstaPasandoBien() = (!comidas.isEmpty()) && criterioDiversion.evaluar(
    self
  )
}

object sordo {
  method aplicar(persona, comensal, elemento) {
    const elementoRandom = persona.devolverElementoCerca()
    persona.darElemento(elementoRandom, comensal)
  }
}

object comerTranquilo {
  method aplicar(persona, comensal, elemento) {
    persona.darTodosLosElementos(comensal)
  }
}

object sociable {
  method aplicar(persona, comensal, elemento) {
    persona.cambiarPosicion(comensal)
  }
}

object normal {
  method aplicar(persona, comensal, elemento) {
    persona.darElemento(elemento, comensal)
  }
}

class Comida {
  var nombre
  var esCarne
  var calorias
  
  method nombre() = nombre
  
  method esCarne() = esCarne
  
  method calorias() = calorias
}

object vegetariano {
  method comer(bandeja) = !bandeja.esCarne()
}

class Dietetico {
  var caloriasMaximas = 499
  
  method comer(bandeja) = bandeja.calorias() < caloriasMaximas
}

class Alternado {
  var ultimaDecision
  
  method comer(bandeja) {
    ultimaDecision = !ultimaDecision
    return ultimaDecision
  }
}

class Combinacion {
  var condiciones
  
  method comer(bandeja) = condiciones.all({ x => x.comer(bandeja) })
} // Criterios de diversión como objetos polimórficos

object siempreFeliz {
  method evaluar(persona) = true
}

class PosicionEspecifica {
  const posicionDeseada
  
  method evaluar(persona) = persona.posicion() == posicionDeseada
}

object amanteDeLaCarne {
  method evaluar(persona) = persona.comidas().any({ c => c.esCarne() })
}

class MinimoDeElementos {
  const maximo
  
  method evaluar(persona) = persona.elementosCerca().size() <= maximo
}

class NoTieneElementoException inherits DomainException {
  
}

class NoCumplePreferenciaException inherits DomainException {
  
}