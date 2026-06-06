class Nave {
	const velocidadMaxima = 300000
	var velocidad = 0

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

	method recibirAmenaza()

	method encontrarEnemigo() {
		self.recibirAmenaza()
		self.propulsar()
	}
}


class NaveDeCarga inherits Nave {
	const cargaLimite = 100000
	const velocidadLimite = 100000
	var carga = 0

	method sobrecargada() = carga > cargaLimite

	method excedidaDeVelocidad() = velocidad > velocidadLimite

	override method recibirAmenaza() { carga = 0 }

}



class NaveDePasajeros inherits Nave {
	const cantidadDePasajeros
	const cantidadDePersonal = 4
	const velocidadLimiteLegal = 300000
	var alarma = false

	method tripulacion() = cantidadDePasajeros + cantidadDePersonal

	method velocidadMaximaLegal() = velocidadLimiteLegal / self.tripulacion() - self.penalizacionPorSeguridad()

	method penalizacionPorSeguridad() = if (cantidadDePasajeros > 100) 200 else 0

	method estaEnPeligro() = velocidad > self.velocidadMaximaLegal() or alarma

	override method recibirAmenaza() { alarma = true }

}



class NaveDeCombate inherits Nave {
	var modo = reposo
	var armasDesplegadas = false
	const property mensajesEmitidos = []

	method emitirMensaje(mensaje) {
		mensajesEmitidos.add(mensaje)
	}
	
	//method ultimoMensaje() = mensajesEmitidos.last()

	method estaInvisible() = modo.cumpleInvisible(self)

	override method recibirAmenaza() {
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

