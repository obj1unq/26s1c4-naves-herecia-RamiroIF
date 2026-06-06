class Nave {
	var velocidad = 0
	const velocidadMaxima = 300000

	method velocidad() = velocidad

	method aumentarVelocidad(kmsxseg) {
		velocidad = (velocidad + kmsxseg).min(velocidadMaxima)
	}

	method propulsar() {
		self.aumentarVelocidad(20000)
	}

	method prepararParaViajar() {
		self.aumentarVelocidad(15000)
	}
}



class NaveDeCarga inherits Nave {
	var carga = 0
	const cargaLimite = 100000
	const velocidadLimite = 100000

	method sobrecargada() = carga > cargaLimite

	method excedidaDeVelocidad() = velocidad > velocidadLimite

	method recibirAmenaza() { carga = 0 }

}



class NaveDePasajeros inherits Nave {
	var alarma = false
	const cantidadDePasajeros
	const cantidadDePersonal = 4
	const velocidadLimiteLegal = 300000

	method tripulacion() = cantidadDePasajeros + cantidadDePersonal

	method velocidadMaximaLegal() = velocidadLimiteLegal / self.tripulacion() - self.penalizacionPorSeguridad()

	method penalizacionPorSeguridad() = if (cantidadDePasajeros > 100) 200 else 0

	method estaEnPeligro() = velocidad > self.velocidadMaximaLegal() or alarma

	method recibirAmenaza() { alarma = true }

}



class NaveDeCombate inherits Nave {
	var modo = reposo
	const property mensajesEmitidos = []
	var armasDesplegadas = false

	method emitirMensaje(mensaje) {
		mensajesEmitidos.add(mensaje)
	}
	
	//method ultimoMensaje() = mensajesEmitidos.last()

	method estaInvisible() = modo.cumpleInvisible(self)

	method recibirAmenaza() {
		modo.recibirAmenaza(self)
	}

	method desplegarArmas() { armasDesplegadas = true }

	method acoplarArmas() { armasDesplegadas = false }

	method estanArmasDesplegadas() = armasDesplegadas

	method cambiarModo() {
		modo = modo.estadoAlternativo()
	}

	override method prepararParaViajar() {
		super()
		modo.preparacionParaViajar(self)
	}
}

// Modos de la nave de combate
object reposo {

	method cumpleInvisible(nave) = nave.velocidad() < 10000

	method recibirAmenaza(nave) {
		nave.emitirMensaje("¡RETIRADA!")
	}

	method estadoAlternativo() = ataque

	method preparacionParaViajar(nave) {
		nave.emitirMensaje("Saliendo en mision")
		nave.cambiarModo()
	}
}

object ataque {

	method cumpleInvisible(nave) = not nave.estanArmasDesplegadas()

	method recibirAmenaza(nave) {
		nave.emitirMensaje("Enemigo encontrado")
		nave.desplegarArmas()
	}

	method estadoAlternativo() = reposo

	method preparacionParaViajar(nave) {
		nave.emitirMensaje("Volviendo a la base")
		//nave.acoplarArmas()
		//nave.cambiarModo()
	}
}


class NaveDeCargaDeResiduosRadiactivos inherits NaveDeCarga{
	var selladoAlVacio = false

	override method recibirAmenaza() { velocidad = 0 }

	method sellarAlVacio() { selladoAlVacio = true }

	method desellarVacio() { selladoAlVacio = false }

	override method prepararParaViajar() {
		super()
		self.sellarAlVacio()
	}
}

