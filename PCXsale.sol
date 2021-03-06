//Especificamos la versión del compilador de Solidity que utilizaremos en el programa.
//*No olvidar* En ocaciones, los funcionamientos varian de version a version, asi que 
//es importante usar el compilador mostrado (V0.5.0).
pragma solidity ^0.5.0;

//especifica todos los metodos accesibles del SC (PumaCoin) al cual se le hace referencia.
interface PumaCoin {
    //No utilizaremos todas sus funciones, solo las que necesitemos(tranferencias y decimales).
    //Notar que varias funciones cuentan con un modificador llamado "view",
    //se debe agregar view, dado que solo vemos los datos del SC y para no gastar gas,
    //ademas que no se hace ninguna operacion en el SC, por lo que es obligatorio ponerlo.
    function decimals() external view returns(uint8);
    function balanceOf(address _address) external view returns(uint256);
    function transfer(address _to, uint256 _value) external returns (bool success);
}

//Definimos el SC para poder vender nuestro Token
contract PumaCoinSale {
    //Definimos las variables utilizadas en el contrato
    address owner;
    uint256 price;
    PumaCoin PumaCoinContract;
    uint256 tokensSold;
    
    //Definimos el evento "venta de tokens"
    event Sold(address buyer, uint256 amount);
    
    //Definimos el contructor que se ejecutará al hacer el deploy del contrato.
    constructor(uint256 _price, address _addressContract) public {
        owner = msg.sender;
        price = _price;
        //Hacemos la referencia del SC PumaCoin
        PumaCoinContract = PumaCoin(_addressContract);
    }
    
    //Esta funcion nos va a ayuda a hacer operaciones de multiplicacion en nuestro token
    //Hace las operaciones invocando una funcion de la libreria "SafeMath",
    //todo esto se hace para no tener problemas de seguridad en nuestro SC.
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b);
        return c;
    }
    
    //Definimos la funcion de compra de tokensSold
    //Para las funciones en donde se haga una pago, se tiene que poner el modificador "payable"
    function buy(uint256 _numTokens) public payable {
        //Se requiere que al ingresar la cantidad a pagar, 
        //esta sea concordante al resultado de multiplicar el precio*num_de_tokens
        require(msg.value == mul(price, _numTokens));
        //Se define una variable que hará el escalado del token con sus respectivos 0´s
        uint256 scaledAmount = mul(_numTokens, uint256(10) ** PumaCoinContract.decimals());
        //Requerimos que la persona que va a vender tenga la cantidad 
        //necesaria de tokens para poder hacer la transferencia.
        require(PumaCoinContract.balanceOf(address(this)) >= scaledAmount);
        tokensSold += _numTokens;
        //Hacemos la transferencia de tokens
        require(PumaCoinContract.transfer(msg.sender, scaledAmount));
        //Mandamos el mensaje de que la transaccion se hizo correctamente
        emit Sold(msg.sender, _numTokens);
    }
    
    //
    function endSold() public{
        require(msg.sender == owner);
        //Transferir al dueno del contrato todo el sueldo de tokens 
        require(PumaCoinContract.transfer(owner, PumaCoinContract.balanceOf(address(this))));
        //en este ultimo this se hace referencia a la direccion de contrato
        //Aqui tranferimos el saldo restante al owner 
        msg.sender.transfer(address(this).balance);
    }
}

//-------------------------------------------------------------------------------------------
//Pasos para ejecutar el codigo PCXsale
//*Importante* (Primero se debe compilar y hacer deploy al 
//programa PumaCoin para que este codigo funcione correctamente)

//-Compilar el código PCXsale

//-Dar click en la ventana "Run" que se encuentra en la esquina superior derecha.

//-Seleccionar el enviroment "JavaScript VM" (Esto se hace para hacer una simulacion local
//-del funcionamiento del SmartContract en cuentas que tienen un saldo de Ethers).

//-Seleccionar el archivo PumaCoinSale para hacer su deploy

//-Copiar la direccion del SC PumaCoin (dando click al boton que se encuenta a la misma
//altura de "PumaCoin at...(memory)", es un simbolo negro con un cuadrado blanco 
//que se llama "Copy value to the clipboard").

//-En el recuadro adyacente del boton "Deploy", poner el precio al que se pondrá
//el token (El equipo descidió que fuera 100 wei por token) y 
//la direccion que copiamos en el paso anterior.

//-Clickear el boton "Deploy".

//-El SC ya se encuentra listo para ejecutar.

//-Clickear el boton con el nombre "PumaCoinSale".

//-Copiar la direccion del contrato PumaCoinSale

//-Proceder a transferir tokens al SC, los suficientes para poder 
//realizar compras

//-------------------------------------------------------------
//1) Pasos para comprar tokens

//-Seleccionar la cuenta con la que queremos comprar tokens

//-En el campo adyacente al boton "buy",  
//se pondrá la cantidad de tokens a comprar

//-En el campo value se debe poner el costo del token
// multiplicado por la cantidad de tokens que queremos 
//(100*(cantidad de tokens))

//-Clickear el botón "buy"

//2) Paso para dejar de vender tokens y transferir el sueldo total

//-Cambiar a la cuenta owner que hizo deploy al SC PumaCoin

//-Clikear el boton "endSold"

//-Revisar en la linea de comandos que la transaccion fue correcta

//-Revisar el saldo de wei (Unidad minima de un Ether)

//Nota* Si queremos ver un cambio verdadero, se recomienda que 
//el costo total de wei´s sea mayor a 80000 para que no se vea 
//afectado por el gas utilizado en la transaccion.
//-
