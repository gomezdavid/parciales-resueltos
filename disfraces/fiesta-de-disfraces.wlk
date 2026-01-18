class Fiesta {
  const lugar
  const fecha
  const invitados
  
  method esUnBodrio() = invitados.all({ x => !x.estaConforme(self) })
  
  method mejorDisfrazDeLaFiesta() {
    invitados.max({ x => x.disfraz().puntaje(x, self) })
  }
  
  method puedenIntercambiarTrajes(fiesta, invitadoA, invitadoB) {
    ((invitados.contains(invitadoA) && invitados.contains(
      invitadoB
    )) && ((!invitadoA.estaConforme(fiesta)) || (!invitadoB.estaConforme(
      fiesta
    )))) && self.estanConformesDespuesDeCambiar(invitadoA, invitadoB)
  }
  
  method estanConformesDespuesDeCambiar(invitadoA, invitadoB) {
    const trajeA = invitadoA.disfraz()
    const trajeB = invitadoB.disfraz()
    return invitadoA.estariaConformeConDisfraz(
      trajeB,
      self
    ) && invitadoB.estariaConformeConDisfraz(trajeA, self)
  }
  
  method agregarInvitado(invitado) {
    if (not invitado.tieneDisfraz()) {
      throw new ElInvitadoNoTieneDisfrazException(
        message = "El invitado no tiene disfraz"
      )
    }
    if (invitados.contains(invitado)) {
      throw new ElInvitadoYaEstaEnLaListaException(
        message = "El Invitado ya esta en la lista"
      )
    }
    invitados.add(invitado)
  }
}

class Invitado {
  var disfraz
  var personalidad
  const edad
  
  method edad() = edad
  
  method esSexy() {
    personalidad.esSexy(self)
  }
  
  method estaConforme(fiesta) = disfraz.puntaje(self, fiesta) > 10
  
  method estariaConformeCon(unDisfraz, unaFiesta) {
    unDisfraz.puntaje(self, unaFiesta) > 10
  }
  
  method tieneDisfraz() = disfraz != null
  
  method disfraz() = disfraz
  
  method disfraz(nuevoDisfraz) {
    disfraz = nuevoDisfraz
  }
}

class Caprichoso inherits Invitado {
  override method estaConforme(fiesta) = super(
    fiesta
  ) && disfraz.tieneCantidadParDeLetras()
}

class Pretencioso inherits Invitado {
  override method estaConforme(fiesta) = super(
    fiesta
  ) && disfraz.estaHechoHaceMenosDeTreintaDias()
}

class Numerologo inherits Invitado {
  const puntajeElegido
  
  override method estaConforme(fiesta) = super(
    fiesta
  ) && (disfraz.puntaje() == puntajeElegido)
}

object alegre {
  method esSexy(persona) = false
  
  method esAlegre() = true
}

object taciturna {
  method esSexy(persona) = persona.edad() < 30
  
  method esAlegre() = false
}

object cambiante {
  var personalidadActual = alegre
  
  method esSexy(persona) {
    self.cambiarPersonalidad()
    return personalidadActual.esSexy(persona)
  }
  
  method cambiarPersonalidad() {
    if (personalidadActual.esAlegre()) {
      personalidadActual = taciturna
    } else {
      personalidadActual = alegre
    }
  }
}

class Disfraz {
  const nombre
  const fechaDeConfeccionado
  const caracteristicas
  
  //aca deberia empezar a sumar los puntajes de las diferentes caracteristicas
  method puntaje(persona, fiesta) = caracteristicas.sum(
    { x => x.puntaje(persona, fiesta) }
  )
  
  method tieneCantidadParDeLetras() = nombre.length().even()
  
  method estaHechoHaceMenosDeTreintaDias() = fechaDeConfeccionado.plusDays(
    30
  ) > new Date()
}

class Caracteristica {
  method puntaje(persona, fiesta)
}

class Gracioso inherits Caracteristica {
  const nivelDeGracia
  
  override method puntaje(persona, fiesta) {
    if (persona.edad() > 50) {
      return nivelDeGracia * 3
    }
    
    return nivelDeGracia
  }
}

class Tobara inherits Caracteristica {
  const fechaComprado
  
  override method puntaje(persona, fiesta) {
    if (self.fueCompradoAntesDeLaFiesta(fiesta)) {
      return 5
    }
    return 3
  }
  
  method fueCompradoAntesDeLaFiesta(
    fiesta
  ) = (fiesta.fecha().day() - fechaComprado.day()) >= 2
}

class Careta inherits Caracteristica {
  const careta
  
  override method puntaje(persona, fiesta) = careta.puntaje()
}

class Sexy inherits Caracteristica {
  override method puntaje(persona, fiesta) {
    if (persona.esSexy()) {
      return 15
    }
    return 2
  }
}

object mickey {
  method puntaje() = 8
}

object osoCarolina {
  method puntaje() = 6
}

object fiestaInolvidable {
  const lugar = "Casa de  Ricardo Fort"
  const fecha = new Date(day = 31, month = 12, year = 3000)
  const invitados = []
  
  method esUnBodrio() = invitados.all({ x => !x.estaConforme(self) })
  
  method mejorDisfrazDeLaFiesta() {
    invitados.max({ x => x.disfraz().puntaje(x, self) })
  }
  
  method puedenIntercambiarTrajes(fiesta, invitadoA, invitadoB) {
    ((invitados.contains(invitadoA) && invitados.contains(
      invitadoB
    )) && ((!invitadoA.estaConforme(fiesta)) || (!invitadoB.estaConforme(
      fiesta
    )))) && self.estanConformesDespuesDeCambiar(invitadoA, invitadoB)
  }
  
  method estanConformesDespuesDeCambiar(invitadoA, invitadoB) {
    const trajeA = invitadoA.disfraz()
    const trajeB = invitadoB.disfraz()
    return invitadoA.estariaConformeConDisfraz(
      trajeB,
      self
    ) && invitadoB.estariaConformeConDisfraz(trajeA, self)
  }
  
  method agregarInvitado(invitado) {
    if (not invitado.tieneDisfraz()) {
      throw new ElInvitadoNoTieneDisfrazException(
        message = "El invitado no tiene disfraz"
      )
    }
    if (invitados.contains(invitado)) {
      throw new ElInvitadoYaEstaEnLaListaException(
        message = "El Invitado ya esta en la lista"
      )
    }
    if (not invitado.esSexy()) {
      throw new InvitadoNoEsSexyException(message = "El invitado no es sexy")
    }
    
    if (not invitado.estaConforme(self)) {
      throw new InvitadoNoEstaConformeConSuDisfrazException(
        message = "El invitado no esta conforme con su disfraz"
      )
    }
    invitados.add(invitado)
  }
}

class InvitadoNoEsSexyException inherits DomainException {
  
}

class InvitadoNoEstaConformeConSuDisfrazException inherits DomainException {
  
}

class ElInvitadoNoTieneDisfrazException inherits DomainException {
  
}

class ElInvitadoYaEstaEnLaListaException inherits DomainException {
  
}