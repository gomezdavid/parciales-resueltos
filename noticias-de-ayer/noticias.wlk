class Noticia {
  const fecha = new Date()
  const autor
  var importancia
  var titulo
  var desarrollo
  
  method titulo() = titulo
  
  method desarrollo() = desarrollo
  
  method esCopada() = (importancia >= 8) && new Date().day().minusDays(
    fecha.day()
  )
  
  method esReportaje() = false
  
  method esADibuMartinez() = true
  
  method estaBienEscrita() = titulo.words().size() > 2
  
  method esDeHoy() = ((fecha.day() == new Date().day()) && (fecha.month() == new Date().month())) && (fecha.year() == new Date().year())
}

class Articulo inherits Noticia {
  var link
  
  override method esCopada() = (link.size() >= 2) && super()
}

class Publicidad inherits Noticia {
  var producto
  var valor
  
  override method esCopada() = (valor > 2000000) && super()
}

class Reportaje inherits Noticia {
  var persona
  
  override method esCopada() = persona.length().odd() && super()
  
  override method esReportaje() = true
  
  override method esADibuMartinez() = persona == "Dibu Martínez"
}

class Cobertura inherits Noticia {
  var noticias
  
  override method esCopada() = noticias.all({ n => n.esCopada() })
}

class Periodista {
  var ingreso = new Date()
  var preferencia
  const noticiasPublicadas = [] // lista vacía
  
  method ingreso() = ingreso
  
  method noticiasPublicadas() = noticiasPublicadas
  
  method publicar(noticia) {
    self.validarPublicacion(noticia)
    noticiasPublicadas.add(noticia)
  }
  
  method validarPublicacion(noticia) {
    if (!noticia.estaBienEscrita()) self.error(
        "La noticia no está bien escrita"
      )
    if (self.superaLimiteDeNoPreferidas(noticia)) self.error(
        "Ya publicaste 2 noticias que no prefieres hoy"
      )
  }
  
  method superaLimiteDeNoPreferidas(noticia) = (!preferencia.cumpleCriterio(
    noticia
  )) && (self.noticiasNoPreferiblesHoy() >= 2)
  
  method noticiasNoPreferiblesHoy() = noticiasPublicadas.filter(
    { n => n.esDeHoy() }
  ).count({ n => !preferencia.cumpleCriterio(n) })
  
  method periodistaReciente(periodista) {
    periodista.filter(
      { p => new Date().month().minusMonths(p.ingreso().month()) <= 12 }
    )
  }
  
  method publicoNoticiaEnLaSemana(periodista) {
    periodista.noticiasPublicadas().any(
      { p => new Date().day().minusDays(p.fecha().day()) <= 7 }
    )
  }
}

object copada {
  method cumpleCriterio(noticia) = noticia.esCopada()
}

object sensacionalista {
  const palabrasClave = ["espectacular", "increible", "grandioso"]
  
  method cumpleCriterio(noticia) = palabrasClave.any(
    { palabra => noticia.titulo().contains(palabra) }
  ) && ((!noticia.esReportaje()) || noticia.esADibuMartinez())
}

object vagos {
  method cumpleCriterio(noticia) = noticia.desarrollo().size() < 100
}

object joseDeZer {
  method cumpleCriterio(noticia) = noticia.titulo().startsWith("T")
}