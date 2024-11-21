class Persona {
    const property formasDePago = []
    var property formaDePagoPreferida
    var dineroDisponible
    var efectivo
    const property cosasCompradas = []
    var property sueldo
    const property meses = [] 
    var mesActual
    //const property coutasVencidas = [] 

    method pasarUnMes() {
        mesActual = mesActual + 1
        self.actualizarDineroDisponible(sueldo)
        meses.get(mesActual).pagarCoutasVencida(self)
        meses.get(mesActual).pagarCoutasDelMes(self) //lo tiene que hacer alguien mas
        self.actualizarEfectivo(dineroDisponible)
        self.actualizarDineroDisponible(-dineroDisponible)
    }

    method plataVencida() = meses.get(mesActual).totalDineroVencido() 

    method actualizarDineroDisponible(cantidad) {
        dineroDisponible = dineroDisponible + cantidad
    }

    method cambiarFormaDePagoFavorita(formaDePago) {
        if (self.tieneLaFormaDePago(formaDePago)) 
            {
            formaDePagoPreferida = formaDePago
            }
    }

    method tieneLaFormaDePago(formaDePago) = formasDePago.contains(formaDePago) 

    method actualizarEfectivo(monto) {
        efectivo = efectivo + monto
    }

    method hacerCompra(compra) {
        formaDePagoPreferida.utilizarMedioDePago(self, compra.costo())
        cosasCompradas.add(compra)
    }
}

class Compra {
    var costo
}

object efectivo {
    method utilizarMedioDePago(persona, monto) {
        if(persona.efectivo() >= monto) 
        {
            persona.actualizarEfectivo(-monto)
        }
        else {self.error("No tiene el dinero suficiente")}
    }
}

class TarjetaDeDebito {
    var saldo

    method actualizarSaldo(monto) {
        saldo = saldo + monto
    }

    method utilizarMedioDePago(persona, monto) {
        if(saldo >= monto) 
        {
            self.actualizarSaldo(-monto)
        }
        else {self.error("No tiene el dinero suficiente en la cuenta")}
    } //terminar esto, revisar el hecho de compartir la tarjeta
}


class TarjetaDeCredito {
    const bancoEmisor 
    var cantidadDeCoutas
    var contadorDeCoutas
    var coutas = []

    method agregarCouta(monto) {
        coutas.add(monto)
    } //terminar esto

    method precioDeCouta(monto) = monto/cantidadDeCoutas 

    method utilizarMedioDePago(persona, monto) {
        if(bancoEmisor.montoMaximo() >= monto) 
        {
            self.agregarCouta(self.precioDeCouta(monto))
            contadorDeCoutas = contadorDeCoutas + 1
            if(cantidadDeCoutas > contadorDeCoutas) {self.utilizarMedioDePago(persona, monto)}
        }
    }

}

class TarjetaDeCreditoConBeneficios inherits TarjetaDeCredito {
    var descuento //porcentaje

    method calcularDescuento(monto) =  (monto/100) * descuento

    override method precioDeCouta(monto) = super(monto) * self.calcularDescuento(monto)
}

class BancoEmisor {
    var montoMaximo
}

class Mes {
    const property coutasAPagar = []
    const property coutasVencidas = []

    method coutaSiguiente() = coutasAPagar.first()

    method coutaPaga(couta) {
      coutasAPagar.remove(couta)
    }

    method pagarCoutasDelMes(persona) {
        if(coutasAPagar.size() > 0 and persona.dineroDisponible() >= self.coutaSiguiente()) 
        {
            persona.actualizarDineroDisponible(- self.coutaSiguiente())
            self.coutaPaga(self.coutaSiguiente())
            self.pagarCoutasDelMes(persona)
        }   
       else {self.coutasVencidas().addAll(coutasAPagar)}
    }

    method pagarCoutasVencidas(persona) {
        if(coutasVencidas.size() > 0 and persona.dineroDisponible() >= self.coutaSiguiente()) 
        {
            persona.actualizarDineroDisponible(- self.coutaSiguiente())
            self.coutaPaga(self.coutaSiguiente())
            self.pagarCoutasVencidas(persona)
        } 
    }

    method totalDeDineroVencido() = coutasVencidas.sum() 
}

class Couta{
    var monto
    var vencida
}
