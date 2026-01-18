class Vikingo {
  var casta
  const tipo
  var armas
  
  method armas() = armas
  
  method puedeIrAExpedicion() = tipo.esProductivo()
  
  method cambiarCasta(nuevaCasta) {
    self.newPercs(nuevaCasta)
    casta = nuevaCasta
  }
  
  method newPercs(nuevaCasta) {
   
  }
}

class Expedicion {
  var vikingos
  var destinos
  
  method valeLaPena() = destinos.all({ x => x.valeLaPena(vikingos) })
}

class Aldea {
  var cantidadCrucifijos
  
  method valeLaPena() = self.botin() >= 15
  
  method botin() = cantidadCrucifijos
}

class AldeaAmurallada inherits Aldea {
  var cantidadMinimaVikingos
  
  override method valeLaPena() = super() && cantidadMinimaVikingos
}

class Capital {
  var cantidadDefensores
  const factorDeRiquza
  
  method valeLaPena(vikingos) = self.botin(vikingos) == (3 * vikingos.size())
  
  method botin(vikingos) = cantidadDefensores - vikingos.size()
}



object karl {
  
}

object jarl {
  
}

class Soldado inherits Vikingo {
  const cantidadDeAsesinatos
  
  method esProductivo() = (cantidadDeAsesinatos < 20) && armas
}

class Granjero inherits Vikingo {
  const cantidadHijos
  const cantidadHectareas
  
  method esProductivo() = (cantidadHijos * 2) == cantidadHectareas
}