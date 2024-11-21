class Persona {
    const property formasDePago = []
    var property formaDePagoPreferida
    var dineroDisponible
    var efectivo
    const property cosasCompradas = []
    var property sueldo
    const property meses = [] 
    var mesActual

    method pasarUnMes() {
        mesActual = mesActual + 1
        self.actualizarDineroDisponible(sueldo)
        self.pagarCoutasDelMes()
        self.actualizarEfectivo(dineroDisponible)
        self.actualizarDineroDisponible(-dineroDisponible)
    }

    method coutasDeEsteMes() = meses.get(mesActual).coutasAPagar()

    method coutaSiguiente() = meses.get(mesActual).coutaSiguiente()

    method coutasParaElMesSiguiente(coutas) {
        meses.get(mesActual + 1).coutasAPagar().addAll(coutas)
    }

    method pagarCoutasDelMes() {
        if(self.coutasDeEsteMes().size() > 0 and dineroDisponible >= self.coutaSiguiente()) 
        {
            self.actualizarDineroDisponible(- self.coutaSiguiente())
            meses.get(mesActual).coutaPaga(self.coutaSiguiente())
            self.pagarCoutasDelMes()
        }
        else {self.coutasParaElMesSiguiente(self.coutasDeEsteMes())}
    }


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
    //var costoApagarPorMes
    const property coutas = [] 

    method agregarCoutaParaPagar(mesSiguiente, couta) {
        mesSiguiente.coutasAPagar().add(couta)
    }

    method precioDeLaCouta(monto) =  monto/bancoEmisor.cantidadCoutas()

    method utilizarMedioDePago(persona, monto) {
        if(bancoEmisor.montoMaximo() >= monto) 
        {
            const precioDeCouta = self.precioDeLaCouta(monto) //acordate del interes
           self.agregarCoutaParaPagar(persona.meses(), precioDeCouta)//Revisar esto porque tiene que ver con la compra
        }
    }
}

class BancoEmisor {
    var montoMaximo
    var cantidadDeCoutas
}

class Mes {
    const property coutasAPagar = []

    method coutaSiguiente() = coutasAPagar.first()

    method coutaPaga(couta) {
      coutasAPagar.remove(couta)
    }

/*
    method pagarCouta(persona) {
        if(persona.dineroDisponible() >= coutasAPagar.first()) 
        {
            persona.actualizarDinero(coutasAPagar.first())
            coutasAPagar.remove(coutasAPagar.first())
        }
        else
        {

        }
    }
*/
}

class Couta{
    var cantidadDeCoutas
    var montoAPagarPorLaCouta
}

