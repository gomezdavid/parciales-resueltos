class Empleado {
  var antiguedad
  var cargo
  var sucursal
  const personalidad
  
  method sueldoMensual() = cargo.sueldoBase(self) + (100 * antiguedad)
  
  method sePuedeTransferir(nuevaSucursal) {
    nuevaSucursal.validar(self)
    sucursal.eliminarPersonal(self)
    sucursal = nuevaSucursal
  }
  
  method motivacion() {
    personalidad.motivacion().max(0).min(100)
  }
  
  method cambiarCargo(nuevoCargo) {
    cargo = nuevoCargo
  }
}

class Cargo {
  const horasTrabajadasPorDia
  
  method sueldoBase(
    empleado
  ) = (self.sueldoPorHora() * horasTrabajadasPorDia) * self.diasLaborales()
  
  method sueldoPorHora()
  
  method diasLaborales() = 22
}

class Recepcionista inherits Cargo {
  override method sueldoPorHora() = 15
}

class Pasante inherits Cargo {
  const diasDeEstudio
  
  override method sueldoPorHora() = 10
  
  override method diasLaborales() = super() - diasDeEstudio
}

class CargoJerarquico inherits Cargo {
  const plus
  
  override method sueldoBase(
    empleado
  ) = (8 * empleado.cantidadDeColegas()) + plus
}

class Gerente inherits CargoJerarquico {
  
}

class ViceJunior inherits CargoJerarquico {
  override method sueldoBase(empleado) = super(empleado) * 1.03
}

class Sucursal {
  const presupuestoMensual
  var personal
  
  method personal() = personal
  
  method esViable() = presupuestoMensual > self.totalSueldos()
  
  method totalSueldos() = personal.sum({ x => x.sueldoMensual() })
  
  method validar(persona) {
    if (!self.esViable()) {
      throw new Exception(message = "La sucursal no es viable")
    }
    
    if ((!self.personalRestante()) >= 3) {
      throw new Exception(message = "El personal restante no es menor a 3")
    }
    self.agregarPersonal(persona)
  }
  
  method personalRestante() = personal.size() - 1
  
  method agregarPersonal(persona) {
    personal.add(persona)
  }
  
  method eliminarPersonal(persona) {
    personal.delete(persona)
  }
  
  method cantidadDeColegas() = personal.size() - 1
  
  method colegasQueGananMas(empleado) = personal.count(
    { colega =>
      (colega != empleado) && (colega.sueldoMensual() > empleado.sueldoMensual()) }
  )
}

object competitivo {
  method motivacion(empleado) {
    const colegasQueGananMas = empleado.sucursal().colegasQueGananMas(empleado)
    return 100 - (10 * colegasQueGananMas)
  }
}

object sociable {
  method motivacion(empleado) {
    const colegas = empleado.sucursal().cantidadDeColegas()
    return 15 * colegas
  }
}

object indiferente {
  const valorMotivacion = 0
  
  method motivacion(empleado) = valorMotivacion
}

object compleja {
  const personalidades = []
  
  method motivacion(empleado) = personalidades.sum(
    { p => p.motivacion(empleado) }
  ) / personalidades.size()
}