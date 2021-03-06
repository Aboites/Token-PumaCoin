//Especificamos la versión del compilador de Solidity que utilizaremos en el programa.
//*No olvidar* En ocaciones, los funcionamientos varian de version a version, asi que 
//es importante seleccionar el compilador (V0.5.0).
pragma solidity ^0.5.0;

//Definimos el SmartContract(SC) "PumaCoin"
contract PumaCoin {
    //Definimos las variables que utilizaremos en el programa.
    string public name;
    string public symbol;
    //unit hace referencia a enteros positivos. 
    uint8 public decimals;
    uint256 public totalSupply;
    
    //Hacemos el seguimiento de los tokens y vendedores (La cantidad que tiene cada uno).
    //Te puede entender al mapping como una estructura de datos, en donde tomamos una 
    //Direccion(Se puede considerar como una cuenta) y se le asocia un valor.
    //Especificamente en la función "balanceOf" obtenemos el balance de una direccion
    //que especifiquemos.
    mapping(address => uint256 ) public balanceOf;
    
    //Hacemos el seguimiento de los tokes de cuentas a las cuales
    //se les ha autorizado utilizar tokens de otra cuenta.
    //Este mapping lo ligamos con otro mapping, esto quiere decir que se va a hacer una
    //relacion entre la cuenta que tiene los tokens y la cuenta a la que se le dará 
    //permiso de utilizar cierta cantidad de tokens.
    mapping(address => mapping(address => uint256)) public allowance;
    
    //Definimos una funcion inicializadora, la cual se va a ejecutar cuando hagamos el "Deploy"
    //( El deploy podemos definirlo como el lanzamiento de un SC a la plataforma de Ethereum).
    //Todos los contructores deben definirse como publicos
    constructor() public{
        //Definimos los valores de nuestro Token
        name = "PumaCoin";
        symbol = "PCX";
        //Definimos los decimales que tendremos, esto es porque no se pueden definir fracciones,
        //solo se puede escalar el toque por medio de la adicion de 0´s.
        decimals = 18;
        //Ponemos la cantidad total de tokens´que tenemos inicialmente.
        totalSupply = 1000000 * (uint256(10) ** decimals);
        //Asignamos todos los tokens a la cuenta owner(propietario) que haga el deploy del SC.
        balanceOf[msg.sender] = totalSupply;
    }
    //Definimos los eventos que se lanzarpán una vez que ciertas acciones 
    //se hayan hecho correctamente (por ej. Al terminar una transferencia de tokens).
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    
    //Definimos la función para transferir tokens de la cuenta owner a otra. 
    function transfer(address _to, uint256 _value) public returns (bool success) {
        //"require" se utiliza para definir un requisito fundamental para
        //el correcto funcionamiento de la función.
        //Requerimos que el balance de el owner sea mayor o igual 
        //a la cantidad que se va a mandar.
        require(balanceOf[msg.sender] >= _value);
        //Retiramos la cantidad de tokens de la cuenta owner
        balanceOf[msg.sender] -= _value;
        //Añadimos los tokens a la cuenta que se van a transferir.
        balanceOf[_to] += _value;
        //Mandamos un mensaje de que la transferencia fue correcta.
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    
    //Definimos la funcion que le dará permiso a otras cuentas de utilizar
    //cierta cantidad de tokens.
    function approve(address _spender, uint256 _value) public returns (bool success){
        //Llamamos a la persona que va a validar
        allowance[msg.sender][_spender] = _value;
        //Mandamos el mensaje de que fue aprobado correctamente
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    
    //Definimos la funcion que transfiere tokens de una cuenta a otra
    //(Para cuentas que no sean owner)
    function transferFrom(address _from, address _to, uint256 _value) public returns(bool success){
        //Se verifica que la persona tenga los tokens
        require(balanceOf[_from] >= _value);
        //Se verifica que la persona que está invocando esta transaccion
        //tenga derecho a manejar esos tokens
        require(allowance[_from][msg.sender] >= _value);
        //Se retiran los tokens permitidos de la cuenta con permiso.
        balanceOf[_from] -= _value;
        //Se agregan los token a la cuenta que los va a recibir.
        balanceOf[_to] += _value;
        //Llamamos a la persona que va a validar.
        allowance[_from][msg.sender] -= _value;
        //Mandamos el mensaje de que fue aprobado correctamente.
        emit Transfer(_from, _to, _value);
        return true;
    }
}

//-------------------------------------------------------------------------------------------
//Pasos para ejecutar el codigo PumaCoin:

//-Compilar el código.

//-Dar click en la ventana "Run" que se encuentra en la esquina superior derecha.

//-Seleccionar el enviroment "JavaScript VM" (Esto se hace para hacer una simulacion local
//-del funcionamiento del SmartContract en cuentas que tienen un saldo de Ethers).

//-Seleccionar alguna de las cuentas disponibles en la seccion "Account"
//-(Notar que para cada operacion se va a hacer un gasto de "gas", que es el costo 
//-computacional para hacer esa accion, se tendrá un limite por default de 3M de gas),
//-esta cuenta será la cuenta owner que hará el deploy del SC.

//-Clickear el boton "Deploy".

//-El SC ya se encuentra listo para ejecutar.

//-Clickear el boton con el nombre "PumaCoin".

//-------------------------------------------------------------

//(antes de realizar esto, para evitar errores se recomienda
//desplegar cada funcion quen tenga una flecha a la derecha y meter en los cuadros los datos, 
//ya que al desplegarse se separan los rubros y se evitan los errores).

//1) Pasos para ver el balance e informacion adicial de una cuenta

//-Cambiar a la cuenta de la cual se quiere obtener informacion. 

//-Copiar su direccion y pegarla en el recuadro dyacente de "balanceOf"

//-Dar click al boton "balanceOf" para ver el balance de la cuenta

//-Dar click al boton "decimals" para ver los ceros que se le agregan
//a los tokens que inicialmente se tienen.

//-Dar click al boton "name" para ver el nombre del token

//-Dar click al boton "symbol" para ver el nombre del token 

//-Dar click al boton "totalSupply" para ver la cantidad total de tokens

//2) Pasos para hacer una transferencia a otra cuenta

//La ejecucion de todo este punto se debe hacer con la cuenta owner
//solamente se cambia a otra cuenta para poder copiar su direccion

//-Seleccionar la segunda cuenta  y copiar la direccion
//de la cuenta (dando click al boton que se encuenta a la misma
//altura de "Account", es un simbolo negro con un cuadrado blanco 
//que se llama "Copy value to the clipboard")

//-Pegar la direccion en el recuadro adyacente al boton "transfer". 

//-Poner una coma "," y despues poner la cantidad de tokens a transferir
//(Tomar en cuenta que se tienen 1000000000000000000000000 unidades inicialmente)

//-Dar click al boton "transfer" y checar en la consola 
//de comandos que la transaccion se hizo de manera correcta

//3) Pasos para darle permiso de utilizar una cantidad de tokens a cierta cuenta

//La cuenta que dara todos los clicks en los botones de las funciones será el owner
//-Cambiar a la cuenta que dará el permiso para obtener la direccion y 
//poder copiarla

//-Poner en el recuadro adyacente de "approve" la cuenta que tendrá el permiso
//y la cantidad maxima de tokens a las que tendrá permiso.

//
//-Poner en el primer recuadro adyacente de "allowance" la cuenta que dará permiso,
//despues en el recuadro de abajo poner la cuenta que recibirá el permiso, 
//
//-Dar click al boton "allowance" y checar en la consola 
//de comandos que el permiso se concedió de manera correcta

//4) Pasos para Transferir de una cuenta a otra

//-Cambiar a la cuenta que trasferira los tokens (la que tiene permiso)

//-En el recuadro adyacente del boton "transferFrom" 
//poner las dos direcciones y la cantidad a tranferir separada por comas
//o al desplegarse cada recuadro poner:
//primero la cuenta de donde provienen los tokens y que dió permiso (owner),
//despues a la cuenta donde se transferiran 
//y por ultimo la cantidad de tokens a transferir

//-Dar click al boton "transferFrom" y checar en la consola 
//de comandos que la transaccion se hizo de manera correcta
