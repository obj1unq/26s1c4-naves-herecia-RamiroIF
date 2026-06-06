class Nave {
	var velocidad = 0

	method velocidad() = velocidad
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
	const velocidadMaximaBase = 300000

	method tripulacion() = cantidadDePasajeros + cantidadDePersonal

	method velocidadMaximaLegal() = velocidadMaximaBase / self.tripulacion() - self.penalizacionPorSeguridad()

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

	//method acoplarArmas() { armasDesplegadas = false }

	method estanArmasDesplegadas() = armasDesplegadas

	method cambiarEstado() {
		modo = modo.estadoAlternativo()
	}
}





// Modos de la nave de combate
object reposo {

	method cumpleInvisible(nave) = nave.velocidad() < 10000

	method recibirAmenaza(nave) {
		nave.emitirMensaje("¡RETIRADA!")
	}

	method estadoAlternativo() = ataque
}

object ataque {

	method cumpleInvisible(nave) = not nave.estanArmasDesplegadas()

	method recibirAmenaza(nave) {
		nave.emitirMensaje("Enemigo encontrado")
		nave.desplegarArmas()
	}

	method estadoAlternativo() = reposo
}

